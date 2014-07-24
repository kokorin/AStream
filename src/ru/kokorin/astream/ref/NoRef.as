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
import org.spicefactory.lib.collection.Map;

public class NoRef extends BaseRef implements AStreamRef {
    private const pathMap:Map = new Map();

    public function hasRef(toValue:Object):Boolean {
        return false;
    }

    public function getRef(toValue:Object):Object {
        return null;
    }

    public function addValue(value:Object):Object {
        const curPath:Array = getCurrentXPath();
        if (pathMap.containsKey(value)) {
            const prevPath:Array = pathMap.get(value) as Array;
            if (isParentPath(curPath, prevPath)) {
                throw new Error("Recursive reference to parent object");
            }
        }
        pathMap.put(value, curPath);
        return null;
    }

    public function getValue(reference:Object):Object {
        return null;
    }

    override public function clear():void {
        super.clear();
        pathMap.removeAll();
    }

    private static function isParentPath(path:Array, parentPath:Array):Boolean {
        if (path.length > parentPath.length) {
            return false;
        }
        for (var i:int = 0; i < path.length; i++) {
            if (path[i] != parentPath[i]) {
                return false;
            }
        }
        return true;
    }
}
}
