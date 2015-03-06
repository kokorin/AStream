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
import ru.kokorin.astream.ref.AStreamRef;

public class BaseHandler implements PropertyHandler {
    private var _nodeName:String;
    private var _nodeType:NodeType;


    public function BaseHandler(nodeName:String, nodeType:NodeType) {
        _nodeName = nodeName;
        _nodeType = nodeType;
    }

    public function toXML(parentInstance:Object, parentXML:XML, ref:AStreamRef):void {

    }

    public function fromXML(parentXML:XML, parentInstance:Object, deref:AStreamRef):void {

    }

    public final function get nodeName():String {
        return _nodeName;
    }

    public final function get nodeType():NodeType {
        return _nodeType;
    }
}
}
