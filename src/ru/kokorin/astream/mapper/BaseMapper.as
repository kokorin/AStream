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
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamRef;

/**
 * Base implementation of <code>Mapper</code> interface.
 * The main purpose of this class is to handle references in object and XML.
 */
public class BaseMapper implements Mapper {
    private var _classInfo:ClassInfo;
    private var _registry:AStreamRegistry;
    private var nodeName:String;
    private var clazz:Class;

    /**
     * @param classInfo Description of Class which this mapper will handle
     */
    public function BaseMapper(classInfo:ClassInfo) {
        this._classInfo = classInfo;
    }

    /**
     * If you need to override this method, possibly you should implement <code>Mapper</code>
     * interface by yourself
     * @inheritDoc
     */
    public final function toXML(instance:Object, ref:AStreamRef, nodeName:String = null):XML {
        if (nodeName == null) {
            nodeName = this.nodeName;
        }
        const result:XML = <{nodeName}/>;

        if (instance != null) {
            ref.beginNode(nodeName);
            if (ref.hasRef(instance)) {
                result.attribute("reference")[0] = ref.getRef(instance);
            } else if (classInfo != null) {
                fillXML(instance, result, ref);
            }
            ref.endNode();
        }

        return result;
    }

    /**
     * If you need to override this method, possibly you should implement <code>Mapper</code>
     * interface by yourself
     * @inheritDoc
     */
    public final function fromXML(xml:XML, ref:AStreamRef):Object {
        var result:Object = null;

        if (xml != null) {
            ref.beginNode(xml.localName());
            const attRef:XML = xml.attribute("reference")[0];
            if (attRef != null) {
                result = ref.getValue(String(attRef));
            } else if (classInfo != null) {
                result = new clazz();
                fillObject(result, xml, ref);
            }
            ref.endNode();
        }

        return result;
    }

    /**
     * Set values of child nodes of XML with values of instance's properties
     * @param instance object to be described
     * @param xml XML to be filled
     * @param ref reference handler
     *
     * Called only when instance haven't been already processed.
     * Should be overridden by subclasses
     */
    protected function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
        const reference:Object = ref.addValue(instance);
        if (reference is Number) {
            xml.attribute("id")[0] = String(reference);
        }
    }

    /**
     * Set instance's properties with values from XML child nodes
     * @param instance whose properties are to be set
     * @param xml to read values from
     * @param ref reference handler
     *
     * Called only when xml node is not a reference to other node.
     * Should be overridden by subclasses
     */
    protected function fillObject(instance:Object, xml:XML, ref:AStreamRef):void {
        ref.addValue(instance);
    }

    public function get classInfo():ClassInfo {
        return _classInfo;
    }

    /** @inheritDoc */
    public function get registry():AStreamRegistry {
        return _registry;
    }

    public function set registry(value:AStreamRegistry):void {
        _registry = value;
        reset();
    }

    public function reset():void {
        nodeName = registry.getAlias(classInfo);
        clazz = classInfo.getClass();
    }
}
}
