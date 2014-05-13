package ru.kokorin.astream.ref {
public class XPathRef implements AStreamRef {
    private var forceSingleNode:Boolean;
    private var relative:Boolean;
    private const instanceXPathPairs:Array = new Array();
    private const currentNodePath:Array = new Array();

    public function XPathRef(forceSingleNode:Boolean, relative:Boolean) {
        this.forceSingleNode = forceSingleNode;
        this.relative = relative;
        clear();
    }

    public function addValue(value:Object):void {
        const pair:InstancePathPair = new InstancePathPair();
        pair.instance = value;
        pair.xPath = nodePathToXPath(currentNodePath);
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

    public function beginNode(nodeName:String):void {
        var nodeIndex:int = 0;
        if (currentNodePath.length > 0) {
            const currentNodeData:NodeData = currentNodePath[currentNodePath.length-1] as NodeData;
            if (currentNodeData.childNodeCount.containsKey(nodeName)) {
                nodeIndex = (currentNodeData.childNodeCount.get(nodeName) as int) + 1;
            }
            currentNodeData.childNodeCount.put(nodeName, nodeIndex);
        }
        currentNodePath.push(new NodeData(nodeName, nodeIndex));
    }

    public function endNode():void {
        const nodeData:NodeData = currentNodePath.pop() as NodeData;
        nodeData.childNodeCount.removeAll();
    }

    public function clear():void {
        instanceXPathPairs.splice(0);
        currentNodePath.splice(0);
        currentNodePath.push(new NodeData("", 0));
    }

    private function nodePathToXPath(nodePath:Array):Array {
        var result:Array = new Array();
        for (var i:int = 0; i < nodePath.length; i++) {
            var nodeData:NodeData = nodePath[i] as NodeData;
            var indexStr:String = "";
            if (i > 0 && (nodeData.index > 0 || forceSingleNode)) {
                indexStr = "[" + (nodeData.index+1) + "]";
            }
            result.push(nodeData.name + indexStr);
        }
        return result;
    }

    private function getAbsoluteXPath(relativeXPath:Array):Array {
        if (!relative) {
            return relativeXPath;
        }
        relativeXPath = relativeXPath.concat();
        const result:Array = nodePathToXPath(currentNodePath);
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
        const fromXPath:Array = nodePathToXPath(currentNodePath);
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

import org.spicefactory.lib.collection.Map;

class InstancePathPair {
    public var instance:Object;
    public var xPath:Array;
}

class NodeData {
    private var _name:String;
    private var _index:int = 0;
    public const childNodeCount:Map = new Map();

    public function NodeData(name:String, index:int) {
        _name = name;
        _index = index;
    }

    public function get name():String {
        return _name;
    }

    public function get index():int {
        return _index;
    }
}
