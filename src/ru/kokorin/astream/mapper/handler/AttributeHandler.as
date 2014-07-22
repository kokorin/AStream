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
import org.spicefactory.lib.reflect.Property;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.converter.Converter;
import ru.kokorin.astream.ref.AStreamRef;

public class AttributeHandler extends BaseHandler {
    private var property:Property;
    private var converter:Converter;

    public function AttributeHandler(property:Property, nodeName:String, registry:AStreamRegistry) {
        super(nodeName, NodeType.ATTRIBUTE);
        this.property = property;
        this.converter = registry.getConverterForProperty(property.owner, property.name);
    }

    override public function toXML(parentInstance:Object, parentXML:XML, ref:AStreamRef):void {
        const value:Object = property.getValue(parentInstance);
        if (value != null && converter != null) {
            parentXML.attribute(nodeName)[0] = converter.toString(value);
        }
    }

    override public function fromXML(parentXML:XML, parentInstance:Object, deref:AStreamRef):void {
        const attValue:XML = parentXML.attribute(nodeName)[0];
        var value:Object = null;
        if (attValue != null && converter != null) {
            value = converter.fromString(String(attValue));
        }
        property.setValue(parentInstance, value);
    }
}
}
