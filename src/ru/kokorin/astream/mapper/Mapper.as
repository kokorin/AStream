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
import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamRef;

public interface Mapper {
    function toXML(instance:Object, ref:AStreamRef, nodeName:String = null):XML;

    function fromXML(xml:XML, ref:AStreamRef):Object;

    function set registry(value:AStreamRegistry):void;

    function get registry():AStreamRegistry;

    function reset():void;
}
}