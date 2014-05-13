package ru.kokorin.astream.ref {
public class BaseRef {
    private var forceSingleNode:Boolean;
    protected const currentNodePath:Array = new Array();

    public function BaseRef(forceSingleNode:Boolean = false) {
        this.forceSingleNode = forceSingleNode;
    }

    public function beginNode(nodeName:String):void {
        var nodeIndex:int = 0;
        if (currentNodePath.length > 0) {
            const currentNodeData:NodeData = currentNodePath[currentNodePath.length - 1] as NodeData;
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
        currentNodePath.splice(0);
        currentNodePath.push(new NodeData("", 0));
    }

    protected function getCurrentXPath():Array {
        var result:Array = new Array();
        for (var i:int = 0; i < currentNodePath.length; i++) {
            var nodeData:NodeData = currentNodePath[i] as NodeData;
            var indexStr:String = "";
            if (i > 0 && (nodeData.index > 0 || forceSingleNode)) {
                indexStr = "[" + (nodeData.index + 1) + "]";
            }
            result.push(nodeData.name + indexStr);
        }
        return result;
    }
}
}

import org.spicefactory.lib.collection.Map;

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
