/*
 * Copyright 2014 Kokorin Denis
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ru.kokorin.astream {
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.converter.Converter;

import ru.kokorin.astream.mapper.Mapper;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.ref.IdRef;
import ru.kokorin.astream.ref.NoRef;
import ru.kokorin.astream.ref.XPathRef;

public class AStream {
    private var ref:AStreamRef;
    private var needReset:Boolean = false;
    private var _autodetectMetadata:Boolean = false;
    private const registry:AStreamRegistry = new AStreamRegistry();
    private const metadataProcessor:AStreamMetadataProcessor = new AStreamMetadataProcessor(registry);


    public function AStream() {
        mode = AStreamMode.XPATH_RELATIVE_REFERENCES;
    }

    /**
     * @default AStreamMode.XPATH_RELATIVE_REFERENCES
     * @param value reference handling mode
     */
    public function set mode(value:AStreamMode):void {
        switch (value) {
            case AStreamMode.NO_REFERENCES: {
                ref = new NoRef();
                break;
            }
            case AStreamMode.ID_REFERENCES: {
                ref = new IdRef();
                break;
            }
            case AStreamMode.SINGLE_NODE_XPATH_ABSOLUTE_REFERENCES: {
                ref = new XPathRef(true, false);
                break;
            }
            case AStreamMode.SINGLE_NODE_XPATH_RELATIVE_REFERENCES:{
                ref = new XPathRef(true, true);
                break;
            }
            case AStreamMode.XPATH_ABSOLUTE_REFERENCES: {
                ref = new XPathRef(false, false);
                break;
            }
            case AStreamMode.XPATH_RELATIVE_REFERENCES:
            default: {
                ref = new XPathRef(false, true);
                break;
            }
        }
    }

    /**
     * Process metadata on supplied classes
     * @param classOrArray Class or Array of classes
     *
     * <p>
     * [AStreamAlias("alias")] - both class and property level
     * Sets alias for class or property
     * </p>
     *
     * <p>
     * [AStreamAsAttribute] - property level
     * Map property to attribute node. Converter must be registered for the type of the property
     * or for the property itself.
     * </p>
     *
     * <p>
     * [AStreamOmitField] - property level
     * Omit the property from processing
     * </p>
     *
     * <p>
     * [AStreamOrder(10)] - property level
     * Order in which the property will be processed.
     * There is no guarantee in Flash that you will get class' properties in order they were declared!
     * Use this metadata if order is significant. Otherwise they will be ordered alphabetically.
     * </p>
     *
     * <p>
     * [AStreamImplicit("itemName", itemType="full.qualified.ClassName", keyProperty="key")] - property level
     * Add elements directly as child element nodes.
     * It is possible to omit itemType from metadata if the property is a Vector (<code>Vector.<ClassName></code>) or
     * if [ArrayElementType("full.qualified.ClassName")] metadata is specified on the property.
     * keyProperty is taken into account only for maps.
     * </p>
     *
     * <p>
     * [AStreamConverter("full.qualified.ConverterName", params="", paramDelimiter="")] - both class and property level
     * </p>
     *
     * <p>
     * [AStreamConverter("full.qualified.MapperName", params="", paramDelimiter="")] - both class and property level
     * </p>
     *
     * @see http://xstream.codehaus.org/alias-tutorial.html XStream alias tutorial
     * @see http://xstream.codehaus.org/graphs.html XStream Object references
     * @see http://xstream.codehaus.org/manual-tweaking-output.html#Configuration_ImplicitCollection XStream Implicit collections and maps
     */
    public function processMetadata(classOrArray:Object):void {
        if (classOrArray is Class) {
            classOrArray = [classOrArray];
        }
        for each (var clazz:Class in classOrArray) {
            var classInfo:ClassInfo = ClassInfo.forClass(clazz);
            metadataProcessor.processMetadata(classInfo);
        }
        autodetectMetadata(false);
        needReset = true;
    }

    /**
     * Register global converter for class.
     * @param converter global converter
     * @param clazz class which can be handled by converter
     *
     * Automatically global SimpleTypeMapper will be set up for specified clazz.
     * @see ru.kokorin.astream.mapper.SimpleMapper
     */
    public function registerConverter(converter:Converter, clazz:Class):void {
        registry.registerConverter(converter, ClassInfo.forClass(clazz));
    }

    /**
     * Register converter for class' property
     *
     * Automatically global SimpleTypeMapper will be set up for specified clazz.
     * @see ru.kokorin.astream.mapper.SimpleMapper
     */
    public function registerConverterForProperty(converter:Converter, clazz:Class, propertyName:String):void {
        registry.registerConverterForProperty(converter, ClassInfo.forClass(clazz), propertyName);
    }

    /**
     * Register global mapper for class.
     * @param mapper
     * @param clazz
     */
    public function registerMapper(mapper:Mapper, clazz:Class):void {
        registry.registerMapper(mapper, ClassInfo.forClass(clazz));
    }

    /**
     * Register mapper for class' property
     */
    public function registerMapperForProperty(mapper:Mapper, clazz:Class, propertyName:String):void {
        registry.registerMapperForProperty(mapper, ClassInfo.forClass(clazz), propertyName);
    }

    /**
     * Set up class' alias
     * @param name alias
     * @param clazz Class. Pass null to set alias for <b>null</b>
     */
    public function alias(name:String, clazz:Class):void {
        var clazzInfo:ClassInfo = null;
        if (clazz != null) {
            clazzInfo = ClassInfo.forClass(clazz);
        }
        registry.alias(name, clazzInfo);
        needReset = true;
    }

    /**
     * Set up property's alias
     */
    public function aliasProperty(name:String, clazz:Class, propertyName:String):void {
        registry.aliasProperty(name, ClassInfo.forClass(clazz), propertyName);
        needReset = true;
    }

    /**
     * Map property to attribute node
     */
    public function useAttributeFor(clazz:Class, propertyName:String):void {
        registry.attribute(ClassInfo.forClass(clazz), propertyName);
        needReset = true;
    }

    /**
     * Set up alias for package
     * @see http://xstream.codehaus.org/alias-tutorial.html#packages XStream Package aliasing
     */
    public function aliasPackage(name:String, pckg:String):void {
        registry.aliasPackage(name, pckg);
        needReset = true;
    }

    public function implicitCollection(clazz:Class, propertyName:String, itemName:String, itemClazz:Class):void {
        registry.implicit(ClassInfo.forClass(clazz), propertyName, itemName, ClassInfo.forClass(itemClazz), null);
        needReset = true;
    }

    public function implicitMap(clazz:Class, propertyName:String, itemName:String, itemClazz:Class, keyProperty:String):void {
        registry.implicit(ClassInfo.forClass(clazz), propertyName, itemName, ClassInfo.forClass(itemClazz), keyProperty);
        needReset = true;
    }

    public function orderProperty(order:int, clazz:Class, propertyName:String):void {
        registry.order(order, ClassInfo.forClass(clazz), propertyName);
    }

    public function autodetectMetadata(value:Boolean):void {
        _autodetectMetadata = value;
    }

    public function toXML(object:Object):XML {
        reset();
        var classInfo:ClassInfo = null;
        if (object != null) {
            classInfo = ClassInfo.forInstance(object);
        }
        const mapper:Mapper = registry.getMapper(classInfo);
        var result:XML;
        try {
            result = mapper.toXML(object, ref);
        } finally {
            ref.clear();
        }
        return result;
    }

    public function fromXML(xml:XML):Object {
        reset();
        const mapper:Mapper = registry.getMapper(xml.localName());
        var result:Object;
        try {
            result = mapper.fromXML(xml, ref);
        } finally {
            ref.clear();
        }
        return result;
    }

    private function reset():void {
        if (!needReset) {
            return;
        }
        registry.resetMappers();
        needReset = false;
    }
}
}
