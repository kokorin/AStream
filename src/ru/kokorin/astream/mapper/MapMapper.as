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

public class MapMapper extends BaseMapper {
    public function MapMapper(classInfo:ClassInfo, registry:AStreamRegistry) {
        super(classInfo, registry);
    }

    override protected function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
        super.fillXML(instance, xml, ref);

        TypeUtil.forEachInMap(instance,
                function (value:Object, key:Object, map:Object):void {
                    const entryXML:XML = <entry/>;

                    var keyType:ClassInfo;
                    if (key != null) {
                        keyType = ClassInfo.forInstance(key);
                    }
                    const keyMapper:Mapper = registry.getMapper(keyType);
                    entryXML.appendChild(keyMapper.toXML(key, ref));

                    var valueType:ClassInfo;
                    if (value != null) {
                        valueType = ClassInfo.forInstance(value);
                    }
                    const valueMapper:Mapper = registry.getMapper(valueType);
                    entryXML.appendChild(valueMapper.toXML(value, ref));

                    xml.appendChild(entryXML);
                }
        );
    }

    override protected function fillObject(instance:Object, xml:XML, ref:AStreamRef):void {
        super.fillObject(instance, xml, ref);

        const keys:Array = new Array();
        const values:Array = new Array();

        for each (var entryXML:XML in xml.elements("entry")) {
            var keyXML:XML = entryXML.elements()[0];
            var keyMapper:Mapper = registry.getMapper(keyXML.localName());
            var key:Object = keyMapper.fromXML(keyXML, ref);

            var valueXML:XML = entryXML.elements()[1];
            var valueMapper:Mapper = registry.getMapper(valueXML.localName());
            var value:Object = valueMapper.fromXML(valueXML, ref);

            keys.push(key);
            values.push(value);
        }

        TypeUtil.putToMap(instance, keys, values);
    }
}
}
