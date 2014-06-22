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
import org.spicefactory.lib.collection.Map;

import ru.kokorin.astream.util.SimpleDateFormat;

public class DateConverter implements AStreamConverter {
    private static const formatterMap:Map = new Map();

    private var formatter:SimpleDateFormat;

    public function DateConverter(pattern:String = "yyyy-MM-dd HH:mm:ss.S z") {
        formatter = formatterMap.get(pattern) as SimpleDateFormat;
        if (formatter == null) {
            formatter = new SimpleDateFormat(pattern);
            formatterMap.put(pattern, formatter);
        }
    }

    public function fromString(string:String):Object {
        return formatter.parse(string);
    }

    public function toString(value:Object):String {
        return formatter.format(value as Date);
    }
}
}
