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
import as3.lang.Enum;

public class NodeType extends Enum {
    public static const TEXT:NodeType = new NodeType("text");
    public static const ELEMENT:NodeType = new NodeType("element");
    public static const ATTRIBUTE:NodeType = new NodeType("attribute");

    public function NodeType(name:String) {
        super(name);
    }
}
}
