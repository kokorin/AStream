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
/* Although " and ' are not escaped by XML in AS3,
 * XStream correctly reads such XML.
 * So we can just pass values through */
public class StringConverter implements AStreamConverter {
    public function fromString(string:String):Object {
        return string;
    }

    public function toString(value:Object):String {
        return value as String;
    }
}
}
