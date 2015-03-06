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
    //TODO replace with MAP
    private const instanceXPathPairs:Array = new Array();

    public function XPathRef(forceSingleNode:Boolean, relative:Boolean) {
        super(forceSingleNode);
        this.relative = relative;
    }

    public function addValue(value:Object):Object {
        const pair:InstancePathPair = new InstancePathPair();
        const xPath:Array = getCurrentXPath().concat();
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

        const result:Array = getCurrentXPath().concat();
        const relativeLength:int = relativeXPath.length;

        for (var i:int = 0; i < relativeLength; ++i) {
            var part:String = relativeXPath[i] as String;
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

        const fromXPath:Array = getCurrentXPath();
        const length:uint = toXPath.length < fromXPath.length ? toXPath.length : fromXPath.length;
        for (var i:int = 0; i < length; ++i) {
            if (toXPath[i] != fromXPath[i]) {
                break;
            }
        }
        const diffIndex:uint = i;

        var result:Array = new Array();
        for (i = fromXPath.length - diffIndex; i > 0; --i) {
            result.push("..");
        }
        result = result.concat(toXPath.slice(diffIndex));
        return result;
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