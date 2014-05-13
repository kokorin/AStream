package ru.kokorin.astream.ref {
public class XPathRef extends BaseRef implements AStreamRef {
    private var relative:Boolean;
    private const instanceXPathPairs:Array = new Array();

    public function XPathRef(forceSingleNode:Boolean, relative:Boolean) {
        super(forceSingleNode);
        this.relative = relative;
        clear();
    }

    public function addValue(value:Object):void {
        const pair:InstancePathPair = new InstancePathPair();
        pair.instance = value;
        pair.xPath = getCurrentXPath();
        instanceXPathPairs.push(pair);
    }

    public function getValue(ref:String):Object {
        if (ref) {
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

    public function getRef(toValue:Object):String {
        for each (var pair:InstancePathPair in instanceXPathPairs) {
            if (pair.instance == toValue) {
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