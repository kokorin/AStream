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
import org.spicefactory.lib.reflect.Property;

import ru.kokorin.astream.mapper.handler.AttributeHandler;
import ru.kokorin.astream.mapper.handler.ChildElementHandler;
import ru.kokorin.astream.mapper.handler.ImplicitCollectionHandler;
import ru.kokorin.astream.mapper.handler.ImplicitMapHandler;
import ru.kokorin.astream.mapper.handler.PropertyHandler;
import ru.kokorin.astream.util.TypeUtil;

public class ComplexMapper extends PropertyMapper {
    public function ComplexMapper(classInfo:ClassInfo) {
        super(classInfo);
    }

    override protected function createPropertyHandler(property:Property):PropertyHandler {
        var result:PropertyHandler = null;

        const propertyAlias:String = registry.getPropertyAlias(classInfo, property.name);
        const asAttribute:Boolean = registry.getAttribute(classInfo, property.name);
        const asImplicit:Boolean = registry.getImplicit(classInfo, property.name);

        //We can map property to attribute only if there is an appropriate converter
        if (asAttribute && registry.getConverterForProperty(classInfo, property.name) != null) {
            result = new AttributeHandler(property, propertyAlias, registry);
        } else if (asImplicit) {
            var itemName:String = registry.getImplicitItemName(classInfo, property.name);
            var itemType:ClassInfo = registry.getImplicitItemType(classInfo, property.name);

            if (itemName != null && itemName.length > 0) {
                if (TypeUtil.isCollection(property.type)) {
                    if (itemType == null && TypeUtil.isVector(property.type)) {
                        itemType = TypeUtil.getVectorItemType(property.type);
                    }
                    if (itemType != null) {
                        result = new ImplicitCollectionHandler(property, itemName, itemType, registry);
                    }
                } else if (TypeUtil.isMap(property.type)) {
                    var keyPropertyName:String = registry.getImplicitKeyProperty(classInfo, property.name);
                    var keyProperty:Property = itemType.getProperty(keyPropertyName);
                    if (itemType != null && keyProperty != null) {
                        result = new ImplicitMapHandler(property, itemName, itemType, keyProperty, registry);
                    }
                }
            }

        }
        // Use ChildElementHandler by default
        if (result == null) {
            result = new ChildElementHandler(property, propertyAlias, registry);
        }

        return result;
    }
}
}
