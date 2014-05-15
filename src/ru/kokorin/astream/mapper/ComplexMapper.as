package ru.kokorin.astream.mapper {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;

import ru.kokorin.astream.*;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.util.TypeUtil;

public class ComplexMapper extends BaseMapper {
    private var processed:Boolean = false;
    private var handlers:Array = new Array();

    public function ComplexMapper(classInfo:ClassInfo, registry:AStreamRegistry) {
        super(classInfo, registry);
    }

    private function process():void {
        if (processed) {
            return;
        }
        //Set this.handlers after all properties handled in case of exception
        const result:Array = new Array();
        const unorderedProperties:Array = classInfo.getProperties();
        const orderedProperties:Array = unorderedProperties.concat().sort(compareProperties);
        const attributeNames:Array = new Array();
        const elementNames:Array = new Array();

        for each (var property:Property in orderedProperties) {
            //If property cannot be properly mapped it should be omitted
            if (registry.getOmit(classInfo, property.name) ||
                    !property.readable || !property.writable)
            {
                continue;
            }

            var propertyHandler:PropertyHandler = null;
            var propertyAlias:String = registry.getAliasProperty(classInfo, property.name);
            var asAttribute:Boolean = registry.getAttribute(classInfo, property.name);
            var asImplicitCollection:Boolean = registry.getImplicitCollection(classInfo, property.name);
            var attributeName:String = null;
            var elementName:String = null;

            if (asAttribute && TypeUtil.isSimple(property.type)) {
                attributeName = propertyAlias;
                propertyHandler = new AttributeHandler(property, propertyAlias, registry);
            } else if (asImplicitCollection && TypeUtil.isCollection(property.type)) {
                var itemName:String = registry.getImplicitItemName(classInfo, property.name);
                var itemType:ClassInfo = registry.getImplicitItemType(classInfo, property.name);
                if (!itemType && TypeUtil.isVector(property.type)) {
                    itemType = TypeUtil.getVectorItemType(property.type);
                }
                if (itemName != null && itemName != "" && itemType != null) {
                    elementName = itemName;
                    propertyHandler = new ImplicitCollectionHandler(property, itemName, itemType, registry);
                }
            }
            // Use ChildElementHandler by default
            if (propertyHandler == null) {
                elementName = propertyAlias;
                propertyHandler = new ChildElementHandler(property, propertyAlias, registry);
            }
            checkAmbiguousNames(attributeNames, attributeName);
            checkAmbiguousNames(elementNames, elementName);
            result.push(propertyHandler);
        }
        processed = true;
        handlers = result;
    }

    override protected function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
        super.fillXML(instance, xml, ref);
        process();
        for each (var handler:PropertyHandler in handlers) {
            handler.toXML(instance, xml, ref);
        }
    }

    override protected function fillObject(instance:Object, xml:XML, ref:AStreamRef):void {
        super.fillObject(instance, xml, ref);
        process();
        for each (var handler:PropertyHandler in handlers) {
            handler.fromXML(xml, instance, ref);
        }
    }

    override public function reset():void {
        super.reset();
        handlers = null;
        processed = false;
    }

    private function compareProperties(prop1:Property, prop2:Property):int {
        const order1:int = registry.getOrder(classInfo, prop1.name);
        const order2:int = registry.getOrder(classInfo, prop2.name);
        if (order1 == order2 ) {
            return 0;
        }
        if (order1 > order2) {
            return 1;
        }
        return -1;
    }

    private static function checkAmbiguousNames(names:Array, name:String):void {
        if (name) {
            if (names.indexOf(name) != -1) {
                throw Error("Ambiguous node name: " + name);
            }
            names.push(name);
        }
    }
}
}

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.converter.AStreamConverter;
import ru.kokorin.astream.mapper.AStreamMapper;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.util.TypeUtil;

interface PropertyHandler {
    function toXML(parentInstance:Object, parentXML:XML, ref:AStreamRef):void;
    function fromXML(parentXML:XML, parentInstance:Object, deref:AStreamRef):void;
}

class AttributeHandler implements PropertyHandler {
    private var property:Property;
    private var name:String;
    private var registry:AStreamRegistry;

    public function AttributeHandler(property:Property, name:String, registry:AStreamRegistry) {
        this.property = property;
        this.name = name;
        this.registry = registry;
    }

    public function toXML(parentInstance:Object, parentXML:XML, ref:AStreamRef):void {
        const value:Object = property.getValue(parentInstance);
        const converter:AStreamConverter = registry.getConverter(property.type);
        if (value != null && converter != null) {
            parentXML.attribute(name)[0] = converter.toString(value);
        }
    }

    public function fromXML(parentXML:XML, parentInstance:Object, deref:AStreamRef):void {
        const attValue:XML = parentXML.attribute(name)[0];
        const converter:AStreamConverter = registry.getConverter(property.type);
        var value:Object = null;
        if (attValue != null && converter != null) {
            value = converter.fromString(String(attValue));
        }
        property.setValue(parentInstance, value);
    }
}

class ChildElementHandler implements PropertyHandler {
    private var property:Property;
    private var name:String;
    private var registry:AStreamRegistry;

    public function ChildElementHandler(property:Property, name:String, registry:AStreamRegistry) {
        this.property = property;
        this.name = name;
        this.registry = registry;
    }

    public function toXML(parentInstance:Object, parentXML:XML, ref:AStreamRef):void {
        const value:Object = property.getValue(parentInstance);
        if (value != null) {
            const valueType:ClassInfo = ClassInfo.forInstance(value);
            const valueMapper:AStreamMapper = registry.getMapper(valueType);
            const result:XML = valueMapper.toXML(value, ref, name);
            /* Integer numbers are always of type int, not Number!
             * i.e. (10 is int) == true and (10.1 is Number) == true */
            if (!TypeUtil.isSimple(property.type) && valueType != property.type) {
                result.attribute("class")[0] = registry.getAlias(valueType);
            }
            parentXML.appendChild(result);
        }
    }

    public function fromXML(parentXML:XML, parentInstance:Object, deref:AStreamRef):void {
        const elementValue:XML = parentXML.elements(name)[0];
        var value:Object;
        if (elementValue != null) {
            const attAlias:XML = elementValue.attribute("class")[0];
            var valueMapper:AStreamMapper;
            if (attAlias) {
                valueMapper = registry.getMapper(String(attAlias));
            } else {
                valueMapper = registry.getMapper(property.type);
            }
            value = valueMapper.fromXML(elementValue, deref);
        }
        property.setValue(parentInstance, value);
    }
}

class ImplicitCollectionHandler implements PropertyHandler {
    private var property:Property;
    private var itemName:String;
    private var itemType:ClassInfo;
    private var registry:AStreamRegistry;

    public function ImplicitCollectionHandler(property:Property, itemName:String, itemType:ClassInfo, registry:AStreamRegistry) {
        this.property = property;
        this.itemName = itemName;
        this.itemType = itemType;
        this.registry = registry;
    }

    public function toXML(parentInstance:Object, parentXML:XML, ref:AStreamRef):void {
        const value:Object = property.getValue(parentInstance);
        const itemMapper:AStreamMapper = registry.getMapper(itemType);
        TypeUtil.forEachInCollection(value,
                function (item:Object, i:int, collection:Object):void {
                    if (item == null) {
                        throw Error("Null items cannot be mapped in implicit collection");
                    }
                    const result:XML = itemMapper.toXML(item, ref, itemName);
                    parentXML.appendChild(result);
                }
        );
    }

    public function fromXML(parentXML:XML, parentInstance:Object, deref:AStreamRef):void {
        var result:Object;
        const itemMapper:AStreamMapper = registry.getMapper(itemType);
        const items:Array = new Array();
        for each (var itemXML:XML in parentXML.elements(itemName)) {
            var item:Object = itemMapper.fromXML(itemXML, deref);
            items.push(item);
        }

        if (items.length) {
            result = property.type.newInstance([]);
            TypeUtil.addToCollection(result, items);
        }

        property.setValue(parentInstance, result);
    }
}