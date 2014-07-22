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

import ru.kokorin.astream.mapper.handler.PropertyHandler;
import ru.kokorin.astream.mapper.handler.TextHandler;

public class TextNodeMapper extends PropertyMapper {
    private var textPropertyName:String;

    public function TextNodeMapper(classInfo:ClassInfo, textPropertyName:String) {
        super(classInfo);
        this.textPropertyName = textPropertyName;
    }

    override protected function createPropertyHandler(property:Property):PropertyHandler {
        if (property.name == textPropertyName) {
            return new TextHandler(property, registry);
        }

        const propertyAlias:String = registry.getPropertyAlias(classInfo, property.name);
        return new AttributeHandler(property, propertyAlias, registry);
    }
}
}
