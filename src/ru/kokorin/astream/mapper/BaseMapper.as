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

public class BaseMapper implements Mapper {
    private var _classInfo:ClassInfo;
    private var _registry:AStreamRegistry;
    private var nodeName:String;

    public function BaseMapper(classInfo:ClassInfo, registry:AStreamRegistry) {
        this._classInfo = classInfo;
        this._registry = registry;
        reset();
    }

    public final function toXML(instance:Object, ref:AStreamRef, nodeName:String = null):XML {
        if (nodeName == null) {
            nodeName = this.nodeName;
        }
        const result:XML = <{nodeName}/>;

        if (instance != null) {
            ref.beginNode(nodeName);
            if (ref.hasRef(instance)) {
                result.attribute("reference")[0] = ref.getRef(instance);
            } else if (classInfo != null) {
                fillXML(instance, result, ref);
            }
            ref.endNode();
        }

        return result;
    }

    public final function fromXML(xml:XML, ref:AStreamRef):Object {
        var result:Object = null;

        if (xml != null) {
            ref.beginNode(xml.localName());
            const attRef:XML = xml.attribute("reference")[0];
            if (attRef != null) {
                result = ref.getValue(String(attRef));
            } else if (classInfo != null) {
                result = classInfo.newInstance([]);
                fillObject(result, xml, ref);
            }
            ref.endNode();
        }

        return result;
    }

    protected function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
        const reference:Object = ref.addValue(instance);
        if (reference is Number) {
            xml.attribute("id")[0] = String(reference);
        }
    }

    protected function fillObject(instance:Object, xml:XML, ref:AStreamRef):void {
        ref.addValue(instance);
    }

    public function get classInfo():ClassInfo {
        return _classInfo;
    }

    protected function get registry():AStreamRegistry {
        return _registry;
    }

    public function reset():void {
        nodeName = registry.getAlias(classInfo);
    }
}
}
