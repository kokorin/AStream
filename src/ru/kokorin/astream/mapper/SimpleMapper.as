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
import ru.kokorin.astream.converter.Converter;
import ru.kokorin.astream.ref.AStreamRef;

public class SimpleMapper implements Mapper {
    private var classInfo:ClassInfo;
    private var propertyName:String;
    private var converter:Converter;
    private var nodeName:String;
    private var _registry:AStreamRegistry;

    public function SimpleMapper(classInfo:ClassInfo, propertyName:String = null) {
        this.classInfo = classInfo;
        this.propertyName = propertyName;
    }

    public function fromXML(xml:XML, ref:AStreamRef):Object {
        var result:Object = null;
        if (xml != null && converter != null) {
            result = converter.fromString(String(xml.text()));
        }
        return result;
    }

    public function toXML(instance:Object, ref:AStreamRef, nodeName:String = null):XML {
        if (nodeName == null) {
            nodeName = this.nodeName;
        }
        const result:XML = <{nodeName}/>;
        if (instance != null && converter != null) {
            result.appendChild(converter.toString(instance));
        }
        return result;
    }

    public function get registry():AStreamRegistry {
        return _registry;
    }

    public function set registry(value:AStreamRegistry):void {
        _registry = value;
        reset();
    }

    public function reset():void {
        nodeName = registry.getAlias(classInfo);
        converter = registry.getConverterForProperty(classInfo, propertyName);
    }
}
}
