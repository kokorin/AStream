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

public class ImplicitCollectionHandler extends BaseHandler {
    private var propertyName:String;
    private var itemType:ClassInfo;
    private var registry:AStreamRegistry;
    private var itemMapper:Mapper;
    private var clazz:Class;


    public function ImplicitCollectionHandler(property:Property, nodeName:String, itemType:ClassInfo, registry:AStreamRegistry) {
        super(nodeName, NodeType.ELEMENT);
        this.propertyName = property.name;
        this.itemType = itemType;
        this.registry = registry;
        this.itemMapper = registry.getMapper(itemType);
        this.clazz = property.type.getClass();
    }

    override public function toXML(parentInstance:Object, parentXML:XML, ref:AStreamRef):void {
        const value:Object = parentInstance[propertyName];
        TypeUtil.forEachInCollection(value,
                function (item:Object, i:int, collection:Object):void {
                    if (item == null) {
                        throw Error("Null items cannot be mapped in implicit collection");
                    }
                    const result:XML = itemMapper.toXML(item, ref, nodeName);
                    parentXML.appendChild(result);
                }
        );
    }

    override public function fromXML(parentXML:XML, parentInstance:Object, deref:AStreamRef):void {
        var result:Object;
        const items:Array = new Array();
        for each (var itemXML:XML in parentXML.elements(nodeName)) {
            var item:Object = itemMapper.fromXML(itemXML, deref);
            items.push(item);
        }

        if (items.length > 0) {
            result = new clazz();
            TypeUtil.addToCollection(result, items);
        }

        parentInstance[propertyName] = result;
    }
}
}
