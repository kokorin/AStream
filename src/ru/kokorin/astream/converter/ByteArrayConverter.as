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
import com.sociodox.utils.Base64;

import flash.utils.ByteArray;

public class ByteArrayConverter implements AStreamConverter {
    public function fromString(string:String):Object {
        if (string != null && string.length > 0) {
            return Base64.decode(string);
        }
        return null;
    }

    public function toString(value:Object):String {
        const bytes:ByteArray = value as ByteArray;
        if (bytes != null) {
            return Base64.encode(bytes);
        }
        return "";
    }
}
}
