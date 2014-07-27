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

/**
 * Reference handler
 */
public interface AStreamRef {
    /**
     * @param value object to test
     * @return true if value has been added
     */
    function hasRef(value:Object):Boolean;

    /**
     * @param value object to test
     * @return reference in XML to the XML-description of supplied object
     */
    function getRef(value:Object):Object;

    /**
     * Add object to internal storage
     * @param value object to add
     * @return value's reference in XML
     */
    function addValue(value:Object):Object;

    /**
     * Get object from internal storage by its reference
     * @param reference object's reference in XML
     * @return object
     */
    function getValue(reference:Object):Object;

    /**
     * Called from mapper when it starts a new node
     * @param nodeName name of the node
     */
    function beginNode(nodeName:String):void;

    /**
     * Called from mapper when it finishes a node
     */
    function endNode():void;

    /**
     * Clear internal storage.
     * Removes all referenced objects and their references.
     */
    function clear():void;
}
}
