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

package ru.kokorin.astream.mapper {
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.util.TypeUtil;

public class SequenceMapper extends BaseMapper {
    public function SequenceMapper(classInfo:ClassInfo) {
        super(classInfo);
    }

    override protected function fillObject(instance:Object, xml:XML, deref:AStreamRef):void {
        super.fillObject(instance, xml, deref);
        const sequence:Array = new Array();
        for each (var itemXML:XML in xml.elements()) {
            var itemMapper:Mapper = registry.getMapper(itemXML.localName());
            var itemValue:Object = itemMapper.fromXML(itemXML, deref);
            sequence.push(itemValue);
        }
        setSequence(instance, sequence);
    }

    override protected function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
        super.fillXML(instance, xml, ref);
        const sequence:Object = getSequence(instance);
        //Use forEachInCollection() loop wrapper because ArrayList doesn't support for each() loop
        TypeUtil.forEachInCollection(sequence,
                function (itemValue:Object, i:int, collection:Object):void {
                    var itemType:ClassInfo;
                    if (itemValue != null) {
                        itemType = ClassInfo.forInstance(itemValue);
                    }
                    const itemValueMapper:Mapper = registry.getMapper(itemType);
                    const itemResult:XML = itemValueMapper.toXML(itemValue, ref);
                    xml.appendChild(itemResult);
                }
        );
    }

    protected function setSequence(instance:Object, sequence:Array):void {
    }

    protected function getSequence(instance:Object):Object {
        return null;
    }
}
}
