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

package ru.kokorin.astream.mapper.handler {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.mapper.Mapper;
import ru.kokorin.astream.ref.AStreamRef;

public class ChildElementHandler extends BaseHandler {
    private var propertyName:String;
    private var propertyType:ClassInfo;
    private var registry:AStreamRegistry;
    private var defaultMapper:Mapper;

    public function ChildElementHandler(property:Property, nodeName:String, registry:AStreamRegistry) {
        super(nodeName, NodeType.ELEMENT);
        this.propertyName = property.name;
        this.propertyType = property.type;
        this.registry = registry;
        this.defaultMapper = registry.getMapperForProperty(property.owner, property.name);
    }

    override public function toXML(parentInstance:Object, parentXML:XML, ref:AStreamRef):void {
        const value:Object = parentInstance[propertyName];
        if (value != null) {
            const valueType:ClassInfo = ClassInfo.forInstance(value);
            var valueMapper:Mapper;
            var className:String = null;
            /* int is subtype of Number! We do not need "class" attribute in XML in case of any numbers*/
            if (!valueType.isType(Number) && valueType != propertyType) {
                valueMapper = registry.getMapper(valueType);
                className = registry.getAlias(valueType);
            } else {
                valueMapper = defaultMapper;
            }

            const result:XML = valueMapper.toXML(value, ref, nodeName);
            if (className != null) {
                result.attribute("class")[0] = className;
            }
            parentXML.appendChild(result);
        }
    }

    override public function fromXML(parentXML:XML, parentInstance:Object, deref:AStreamRef):void {
        const elementValue:XML = parentXML.elements(nodeName)[0];
        var value:Object;
        if (elementValue != null) {
            const attAlias:XML = elementValue.attribute("class")[0];
            var valueMapper:Mapper;
            if (attAlias != null) {
                valueMapper = registry.getMapper(String(attAlias));
            } else {
                valueMapper = defaultMapper;
            }
            value = valueMapper.fromXML(elementValue, deref);
        }
        parentInstance[propertyName] = value;
    }
}
}
