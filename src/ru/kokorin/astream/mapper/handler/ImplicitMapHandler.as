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
import ru.kokorin.astream.util.TypeUtil;

public class ImplicitMapHandler extends BaseHandler {
    private var property:Property;
    private var itemType:ClassInfo;
    private var keyProperty:Property;
    private var registry:AStreamRegistry;

    public function ImplicitMapHandler(property:Property, nodeName:String, itemType:ClassInfo,
                                       keyProperty:Property, registry:AStreamRegistry)
    {
        super(nodeName, NodeType.ELEMENT);
        this.property = property;
        this.itemType = itemType;
        this.keyProperty = keyProperty;
        this.registry = registry;
    }

    override public function toXML(parentInstance:Object, parentXML:XML, ref:AStreamRef):void {
        const value:Object = property.getValue(parentInstance);
        const itemMapper:Mapper = registry.getMapper(itemType);
        TypeUtil.forEachInMap(value,
                function (value:Object, key:Object, map:Object):void {
                    if (value == null) {
                        throw Error("Null items cannot be mapped in implicit map");
                    }
                    const result:XML = itemMapper.toXML(value, ref, nodeName);
                    parentXML.appendChild(result);
                }
        );
    }

    override public function fromXML(parentXML:XML, parentInstance:Object, deref:AStreamRef):void {
        var result:Object;
        const itemMapper:Mapper = registry.getMapper(itemType);
        const keys:Array = new Array();
        const values:Array = new Array();

        for each (var itemXML:XML in parentXML.elements(nodeName)) {
            var value:Object = itemMapper.fromXML(itemXML, deref);
            var key:Object = keyProperty.getValue(value);
            keys.push(key);
            values.push(value);
        }

        if (keys.length > 0) {
            result = property.type.newInstance([]);
            TypeUtil.putToMap(result, keys, values);
        }

        property.setValue(parentInstance, result);
    }
}
}
