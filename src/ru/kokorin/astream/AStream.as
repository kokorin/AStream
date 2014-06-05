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

package ru.kokorin.astream {
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.mapper.AStreamMapper;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.ref.IdRef;
import ru.kokorin.astream.ref.NoRef;
import ru.kokorin.astream.ref.XPathRef;

public class AStream {
    private var ref:AStreamRef;
    private var needReset:Boolean = false;
    private const registry:AStreamRegistry = new AStreamRegistry();

    public function AStream() {
        mode = AStreamMode.XPATH_RELATIVE_REFERENCES;
    }

    public function set mode(value:AStreamMode):void {
        switch (value) {
            case AStreamMode.NO_REFERENCES: {
                ref = new NoRef();
                break;
            }
            case AStreamMode.ID_REFERENCES: {
                ref = new IdRef();
                break;
            }
            case AStreamMode.SINGLE_NODE_XPATH_ABSOLUTE_REFERENCES: {
                ref = new XPathRef(true, false);
                break;
            }
            case AStreamMode.SINGLE_NODE_XPATH_RELATIVE_REFERENCES:{
                ref = new XPathRef(true, true);
                break;
            }
            case AStreamMode.XPATH_ABSOLUTE_REFERENCES: {
                ref = new XPathRef(false, false);
                break;
            }
            case AStreamMode.XPATH_RELATIVE_REFERENCES:
            default: {
                ref = new XPathRef(false, true);
                break;
            }
        }
    }

    public function processMetadata(clazz:Class):void {
        const classInfo:ClassInfo = ClassInfo.forClass(clazz);
        registry.processMetadata(classInfo);
        needReset = true;
    }

    public function alias(name:String, clazz:Class):void {
        registry.alias(name, ClassInfo.forClass(clazz));
        needReset = true;
    }

    public function aliasProperty(name:String, clazz:Class, propertyName:String):void {
        registry.aliasProperty(name, ClassInfo.forClass(clazz), propertyName);
        needReset = true;
    }

    public function useAttributeFor(clazz:Class, propertyName:String):void {
        registry.attribute(ClassInfo.forClass(clazz), propertyName);
        needReset = true;
    }

    public function aliasPackage(name:String, pckg:String):void {
        registry.aliasPackage(name, pckg);
        needReset = true;
    }

    public function implicitCollection(clazz:Class, propertyName:String, itemName:String, itemClazz:Class):void {
        registry.implicit(ClassInfo.forClass(clazz), propertyName, itemName, ClassInfo.forClass(itemClazz), null);
        needReset = true;
    }

    public function implicitMap(clazz:Class, propertyName:String, itemName:String, itemClazz:Class, keyProperty:String):void {
        registry.implicit(ClassInfo.forClass(clazz), propertyName, itemName, ClassInfo.forClass(itemClazz), keyProperty);
        needReset = true;
    }

    public function orderProperty(order:int, clazz:Class, propertyName:String):void {
        registry.order(order, ClassInfo.forClass(clazz), propertyName);
    }

    public function autodetectMetadata(value:Boolean):void {
        registry.autodetectMetadata(value);
    }

    public function toXML(object:Object):XML {
        reset();
        var classInfo:ClassInfo = null;
        if (object != null) {
            classInfo = ClassInfo.forInstance(object);
        }
        const mapper:AStreamMapper = registry.getMapper(classInfo);
        var result:XML;
        try {
            result = mapper.toXML(object, ref);
        } finally {
            ref.clear();
        }
        return result;
    }

    public function fromXML(xml:XML):Object {
        reset();
        const mapper:AStreamMapper = registry.getMapper(xml.localName());
        var result:Object;
        try {
            result = mapper.fromXML(xml, ref);
        } finally {
            ref.clear();
        }
        return result;
    }

    private function reset():void {
        if (!needReset) {
            return;
        }
        registry.resetMappers();
        needReset = false;
    }
}
}
