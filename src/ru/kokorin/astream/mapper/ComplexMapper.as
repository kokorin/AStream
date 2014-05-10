package ru.kokorin.astream.mapper {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;

import ru.kokorin.astream.*;
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.util.TypeUtil;

public class ComplexMapper implements AStreamMapper{
    private var classInfo:ClassInfo;
    private var registry:AStreamRegistry;
    private var processed:Boolean = false;
    private const handlers:Array = new Array();


    public function ComplexMapper(classInfo:ClassInfo, registry:AStreamRegistry) {
        this.classInfo = classInfo;
        this.registry = registry;
    }

    public function process():void {
        if (processed) {
            return;
        }
        const unorderedProperties:Array = classInfo.getProperties();
        const orderedProperties:Array = unorderedProperties.concat().sort(compareProperties);
        for each (var property:Property in orderedProperties) {
            if (registry.getOmit(classInfo, property.name)) {
                continue;
            }

            var propertyHandler:PropertyHandler;
            var propertyAlias:String = registry.getAliasProperty(classInfo, property.name);
            var asAttribute:Boolean = registry.getAttribute(classInfo, property.name);
            var asImplicitCollection:Boolean = registry.getImplicitCollection(classInfo, property.name);

            if (asAttribute && TypeUtil.isSimple(property.type)) {
                propertyHandler = new AttributeHandler(property, propertyAlias, registry);
            } else if (asImplicitCollection && TypeUtil.isCollection(property.type)) {
                //TODO для вложенного списка необходимо задать itemName и itemType
                var itemName:String = registry.getImplicitItemName(classInfo, property.name);
                //TODO получить тип элемента через TypeUtil.getItemType
                var itemType:ClassInfo = registry.getImplicitItemType(classInfo, property.name);
                propertyHandler = new ImplicitCollectionHandler(property, itemName, itemType, registry);
            } else {
                propertyHandler = new ChildElementHandler(property, propertyAlias, registry);
            }
            if (propertyHandler) {
                handlers.push(propertyHandler);
            }
        }
        processed = true;
    }

    public function toXML(instance:Object, ref:AStreamRef):XML {
        const name:String = registry.getAlias(classInfo);
        const result:XML = <{name}/>;
        fillXML(instance, result, ref);
        return result;
    }

    public function fromXML(xml:XML, deref:AStreamDeref):Object {
        process();
        const attRef:XML = xml.attribute("reference")[0];
        if (attRef) {
            return deref.getValue(String(attRef), xml);
        }
        const result:Object = classInfo.newInstance([]);
        deref.addRef(result, xml);
        for each (var handler:PropertyHandler in handlers) {
            handler.fromXML(xml, result, deref);
        }
        return result;
    }

    public function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
        process();
        if (ref.hasRef(instance)) {
            xml.attribute("reference")[0] = ref.getRef(instance, xml);
            return;
        }
        ref.addValue(instance, xml);
        for each (var handler:PropertyHandler in handlers) {
            handler.toXML(instance, xml, ref);
        }
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
}
}

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.converter.AStreamConverter;
import ru.kokorin.astream.mapper.AStreamMapper;
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.util.TypeUtil;

interface PropertyHandler {
    function toXML(parentInstance:Object, parentXML:XML, ref:AStreamRef):void;
    function fromXML(parentXML:XML, parentInstance:Object, deref:AStreamDeref):void;
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

    public function fromXML(parentXML:XML, parentInstance:Object, deref:AStreamDeref):void {
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
            const result:XML = <{name}/>;
            parentXML.appendChild(result);

            const valueType:ClassInfo = ClassInfo.forInstance(value);
            /* Integer numbers are always of type int, not Number!
             * i.e. (10 is int) == true and (10.1 is Number) == true */
            if (!TypeUtil.isSimple(property.type) && valueType != property.type) {
                result.attribute("class")[0] = registry.getAlias(valueType);
            }

            const valueMapper:AStreamMapper = registry.getMapperForClass(valueType);
            valueMapper.fillXML(value, result, ref);
        }
    }

    public function fromXML(parentXML:XML, parentInstance:Object, deref:AStreamDeref):void {
        const elementValue:XML = parentXML.elements(name)[0];
        var value:Object;
        if (elementValue != null) {
            const attAlias:XML = elementValue.attribute("class")[0];
            var valueMapper:AStreamMapper;
            if (attAlias) {
                valueMapper = registry.getMapperForName(String(attAlias));
            } else {
                valueMapper = registry.getMapperForClass(property.type);
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
        const itemMapper:AStreamMapper = registry.getMapperForClass(itemType);
        TypeUtil.forEachInCollection(value,
                function (item:Object, i:int, collection:Object):void {
                    const result:XML = <{itemName}/>;
                    itemMapper.fillXML(item, result, ref);
                    parentXML.appendChild(result);
                }
        );
    }

    public function fromXML(parentXML:XML, parentInstance:Object, deref:AStreamDeref):void {
        var result:Object;
        const itemMapper:AStreamMapper = registry.getMapperForClass(itemType);
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