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

package ru.kokorin.astream.ref {
public class IdRef implements AStreamRef {
    private var nextId:int;
    private const values:Array = new Array();

    public function IdRef() {
        clear();
    }

    public function hasRef(value:Object):Boolean {
        return values.indexOf(value) != -1;
    }

    public function getRef(value:Object):Object {
        return values.indexOf(value);
    }

    public function addValue(value:Object):Object {
        values[nextId] = value;
        return nextId;
    }

    public function getValue(ref:Object):Object {
        const index:int = parseInt(String(ref));
        return values[index];
    }

    public function beginNode(nodeName:String):void {
        nextId++;
    }

    public function endNode():void {
    }

    public function clear():void {
        nextId = 0;
        values.splice(0);
    }
}
}
