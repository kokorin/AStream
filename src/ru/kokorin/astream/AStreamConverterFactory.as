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

package ru.kokorin.astream {
import as3.lang.Enum;

import flash.utils.ByteArray;

import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.converter.AStreamConverter;
import ru.kokorin.astream.converter.BooleanConverter;
import ru.kokorin.astream.converter.ByteArrayConverter;
import ru.kokorin.astream.converter.DateConverter;
import ru.kokorin.astream.converter.EnumConverter;
import ru.kokorin.astream.converter.NumberConverter;
import ru.kokorin.astream.converter.StringConverter;

public class AStreamConverterFactory {
    public function createConverter(classInfo:ClassInfo):AStreamConverter {
        if (classInfo) {
            if (classInfo.isType(Boolean)) {
                return new BooleanConverter();
            } else if (classInfo.isType(Date)) {
                return new DateConverter();
            } else if (classInfo.isType(Number)) {
                return new NumberConverter();
            } else if (classInfo.isType(String)) {
                return new StringConverter();
            } else if (classInfo.isType(ByteArray)) {
                return new ByteArrayConverter();
            } else if (classInfo.isType(Enum)) {
                return new EnumConverter(classInfo);
            }
        }
        return null;
    }
}
}
