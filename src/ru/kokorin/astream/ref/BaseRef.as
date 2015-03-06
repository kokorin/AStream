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
public class BaseRef {
    private var forceSingleNode:Boolean;
    private const currentNodePath:Array = new Array();
    private const currentXPath:Array = [""];

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

        const temp:Array = [nodeName];
        if (forceSingleNode || nodeIndex > 0) {
            temp.push("[", nodeIndex + 1, "]");
        }
        currentXPath.push(temp.join(""));
    }

    public function endNode():void {
        const nodeData:NodeData = currentNodePath.pop() as NodeData;
        nodeData.childNodeCount.removeAll();
        currentXPath.pop();
    }

    public function clear():void {
        currentNodePath.splice(0);
        currentXPath.splice(1);
    }

    protected function getCurrentXPath():Array {
        return currentXPath;
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
