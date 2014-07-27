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

package ru.kokorin.astream.mapper {
import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamRef;

/**
 * An interface describing conversion of typed object
 * to XML representation and back
 */
public interface Mapper {

    /**
     * Generate XML from object
     * @param instance object to be processed
     * @param ref reference handler
     * @param nodeName optional XML element name. If not specified default name from
     *                  registry should be used
     * @return XML-description of instance
     */
    function toXML(instance:Object, ref:AStreamRef, nodeName:String = null):XML;

    /**
     * Restore object from XML
     * @param xml XML-description of object
     * @param ref reference handler
     * @return restored object
     */
    function fromXML(xml:XML, ref:AStreamRef):Object;

    /**
     * Registry for this mapper
     */
    function get registry():AStreamRegistry;

    function set registry(value:AStreamRegistry):void;

    /**
     * Reset mapper cache. Is called automatically by <code>AStreamRegistry</code> upon configuration change.
     */
    function reset():void;
}
}