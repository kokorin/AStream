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
import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;

import ru.kokorin.astream.mapper.handler.PropertyHandler;
import ru.kokorin.astream.ref.AStreamRef;

/**
 * Base mapper that can handle object properties
 */
public class PropertyMapper extends BaseMapper {
    private var processed:Boolean = false;
    private var propertyHandlers:Array = new Array();

    public function PropertyMapper(classInfo:ClassInfo) {
        super(classInfo);
    }

    private function process():void {
        if (processed) {
            return;
        }
        //Set this.handlers after all properties handled in case of exception
        const result:Array = new Array();
        const unorderedProperties:Array = classInfo.getProperties();
        const orderedProperties:Array = unorderedProperties.concat().sort(compareProperties);
        const nodeNamesByType:Map = new Map();

        for each (var property:Property in orderedProperties) {
            //If property cannot be properly mapped it should be omitted
            if (registry.getOmit(classInfo, property.name) || !property.readable || !property.writable) {
                continue;
            }

            var propertyHandler:PropertyHandler = createPropertyHandler(property);
            //Check ambiguous node names
            var names:Array = nodeNamesByType.get(propertyHandler.nodeType) as Array;
            if (names == null) {
                names = new Array();
                nodeNamesByType.put(propertyHandler.nodeType, names);
            }
            if (names.indexOf(propertyHandler.nodeName) != -1) {
                throw Error("Ambiguous node name: " + propertyHandler.nodeName);
            }
            names.push(propertyHandler.nodeName);

            result.push(propertyHandler);
        }
        processed = true;
        propertyHandlers = result;
    }

    /**
     * Create handler for property.
     * @param property description of Class' property
     * @return handler that will map specified property
     *
     * Method is called for every public property of Class that can be mapped, i.e.
     * not omitted, readable and writable.
     *
     * Should be overridden by subclasses.
     */
    protected function createPropertyHandler(property:Property):PropertyHandler {
        return null;
    }

    /** @inheritDoc */
    override protected function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
        super.fillXML(instance, xml, ref);
        process();
        for each (var handler:PropertyHandler in propertyHandlers) {
            handler.toXML(instance, xml, ref);
        }
    }

    /** @inheritDoc */
    override protected function fillObject(instance:Object, xml:XML, ref:AStreamRef):void {
        super.fillObject(instance, xml, ref);
        process();
        for each (var handler:PropertyHandler in propertyHandlers) {
            handler.fromXML(xml, instance, ref);
        }
    }

    /** @inheritDoc */
    override public function reset():void {
        super.reset();
        propertyHandlers = null;
        processed = false;
    }

    private function compareProperties(prop1:Property, prop2:Property):int {
        const order1:int = registry.getOrder(classInfo, prop1.name);
        const order2:int = registry.getOrder(classInfo, prop2.name);
        if (order1 > order2 || (order1 == order2 && prop1.name > prop2.name)) {
            return 1;
        }
        return -1;
    }
}
}
