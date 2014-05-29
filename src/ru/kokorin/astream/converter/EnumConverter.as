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

package ru.kokorin.astream.converter {
import as3.lang.Enum;

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;

public class EnumConverter implements AStreamConverter {
    private var classInfo:ClassInfo;

    public function EnumConverter(classInfo:ClassInfo) {
        this.classInfo = classInfo;
    }

    public function fromString(string:String):Object {
        const staticProperty:Property = classInfo.getStaticProperty(string);
        if (staticProperty) {
            return staticProperty.getValue(null);
        }
        return null;
    }

    public function toString(value:Object):String {
        const enum:Enum = value as Enum;
        if (enum) {
            return enum.name;
        }
        return null;
    }
}
}
