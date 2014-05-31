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
public class XPathRef extends BaseRef implements AStreamRef {
    private var relative:Boolean;
    private const instanceXPathPairs:Array = new Array();

    public function XPathRef(forceSingleNode:Boolean, relative:Boolean) {
        super(forceSingleNode);
        this.relative = relative;
        clear();
    }

    public function addValue(value:Object):Object {
        const pair:InstancePathPair = new InstancePathPair();
        const xPath:Array = getCurrentXPath();
        pair.instance = value;
        pair.xPath = xPath;
        instanceXPathPairs.push(pair);
        return xPathToString(xPath);
    }

    public function getValue(reference:Object):Object {
        const ref:String = reference as String;
        if (ref != null) {
            const relativeXPath:Array = ref.split("/");
            const absoluteXPath:Array = getAbsoluteXPath(relativeXPath);
            for each (var pair:InstancePathPair in instanceXPathPairs) {
                if (pair.xPath == null || pair.xPath.length != absoluteXPath.length) {
                    continue;
                }
                var match:Boolean = true;
                for (var i:int = 0; i < absoluteXPath.length; i++) {
                    if (pair.xPath[i] != absoluteXPath[i]) {
                        match = false;
                        break;
                    }
                }
                if (match) {
                    return pair.instance;
                }
            }
        }
        return null;
    }

    public function hasRef(toValue:Object):Boolean {
        for each (var pair:InstancePathPair in instanceXPathPairs) {
            if (pair.instance == toValue) {
                return true;
            }
        }
        return false;
    }

    public function getRef(value:Object):Object {
        for each (var pair:InstancePathPair in instanceXPathPairs) {
            if (pair.instance == value) {
                var relativeXPath:Array = getRelativeXPath(pair.xPath);
                return xPathToString(relativeXPath);
            }
        }
        return null;
    }

    override public function clear():void {
        super.clear();
        instanceXPathPairs.splice(0);
    }

    private function getAbsoluteXPath(relativeXPath:Array):Array {
        if (!relative) {
            return relativeXPath;
        }
        relativeXPath = relativeXPath.concat();
        const result:Array = getCurrentXPath();
        while (relativeXPath.length > 0) {
            var part:String = relativeXPath.shift() as String;
            if (part == "..") {
                result.pop();
            } else if (part != ".") {
                result.push(part);
            }
        }
        return result;
    }

    private function getRelativeXPath(toXPath:Array):Array {
        if (!relative) {
            return toXPath;
        }
        toXPath = toXPath.concat();
        const fromXPath:Array = getCurrentXPath();
        while (toXPath.length > 0 && fromXPath.length > 0) {
            if (toXPath[0] != fromXPath[0]) {
                break;
            }
            toXPath.shift();
            fromXPath.shift();
        }

        for (var i:int = 0; i < fromXPath.length; i++) {
            toXPath.unshift("..");
        }
        return toXPath;
    }

    private static function xPathToString(xPath:Array):String {
        if (xPath) {
            return xPath.join("/");
        }
        return null;
    }
}
}

class InstancePathPair {
    public var instance:Object;
    public var xPath:Array;
}