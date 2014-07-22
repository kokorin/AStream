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
import org.spicefactory.lib.reflect.Metadata;
import org.spicefactory.lib.reflect.MetadataAware;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.lib.reflect.Property;

import ru.kokorin.astream.converter.Converter;
import ru.kokorin.astream.mapper.Mapper;

import ru.kokorin.astream.metadata.AStreamAlias;
import ru.kokorin.astream.metadata.AStreamAsAttribute;
import ru.kokorin.astream.metadata.AStreamConverter;
import ru.kokorin.astream.metadata.AStreamImplicit;
import ru.kokorin.astream.metadata.AStreamMapper;
import ru.kokorin.astream.metadata.AStreamOmitField;
import ru.kokorin.astream.metadata.AStreamOrder;
import ru.kokorin.astream.metadata.ArrayElementType;
import ru.kokorin.astream.util.TypeUtil;

public class AStreamMetadataProcessor {
    private var registry:AStreamRegistry;
    private const processedClasses:Array = new Array();

    private static var metadataRegistered:Boolean = false;
    private static const metadataClasses:Array = [
        AStreamAlias,
        AStreamAsAttribute,
        AStreamOmitField,
        AStreamImplicit,
        AStreamConverter,
        AStreamMapper,
        AStreamOrder,
        ArrayElementType
    ];

    public function AStreamMetadataProcessor(registry:AStreamRegistry) {
        this.registry = registry;
        registerMetadata();
    }

    private static function registerMetadata():void {
        if (metadataRegistered) {
            return;
        }
        for each (var metadataClass:Class in metadataClasses) {
            Metadata.registerMetadataClass(metadataClass);
        }
        metadataRegistered = true;
    }

    private static const OBJECT_INFO:ClassInfo = ClassInfo.forClass(Object);
    public function processMetadata(classInfo:ClassInfo):void {
        while (classInfo != null && classInfo != OBJECT_INFO) {
            if (TypeUtil.isCollection(classInfo)) {
                if (TypeUtil.isVector(classInfo)) {
                    processMetadata(TypeUtil.getVectorItemType(classInfo));
                }
                break;
            }
            if (TypeUtil.isSimple(classInfo) || processedClasses.indexOf(classInfo) != -1) {
                break;
            }

            var alias:String = getAlias(classInfo);
            if (alias != null) {
                registry.alias(alias, classInfo);
            }

            var converter:Converter = getConverter(classInfo);
            if (converter != null) {
                registry.registerConverter(converter, classInfo);
            }

            var mapper:Mapper = getMapper(classInfo);
            if (mapper != null) {
                registry.registerMapper(mapper, classInfo);
            }

            processedClasses.push(classInfo);

            for each (var property:Property in classInfo.getProperties()) {
                processMetadata(property.type);

                if (hasMetadata(property, AStreamOmitField)) {
                    registry.omit(classInfo, property.name);
                    continue;
                }

                var propertyAlias:String = getAlias(property);
                if (propertyAlias != null) {
                    registry.aliasProperty(propertyAlias, classInfo, property.name);
                }
                if (getMetadata(property, AStreamAsAttribute) != null) {
                    registry.attribute(classInfo, property.name);
                }
                var orderMeta:AStreamOrder = getMetadata(property, AStreamOrder) as AStreamOrder;
                if (orderMeta != null) {
                    registry.order(orderMeta.order, classInfo, property.name);
                }

                var itemType:ClassInfo = null;
                if (TypeUtil.isCollection(property.type) || TypeUtil.isMap(property.type)) {
                    if (TypeUtil.isVector(property.type)) {
                        itemType = TypeUtil.getVectorItemType(property.type);
                    } else {
                        for each (var elementTypeMeta:ArrayElementType in property.getMetadata(ArrayElementType)) {
                            itemType = ClassInfo.forName(elementTypeMeta.elementType);
                            processMetadata(itemType);
                        }
                    }
                }

                var implicitMeta:AStreamImplicit = getMetadata(property, AStreamImplicit) as AStreamImplicit;
                if (implicitMeta != null) {
                    var implicitItemType:ClassInfo = null;
                    if (implicitMeta.itemType != null) {
                        implicitItemType = ClassInfo.forName(implicitMeta.itemType);
                        processMetadata(implicitItemType);
                    } else if (itemType != null) {
                        implicitItemType = itemType;
                    }
                    registry.implicit(classInfo, property.name, implicitMeta.itemName, implicitItemType, implicitMeta.keyProperty);
                }

                converter = getConverter(property);
                if (converter != null) {
                    registry.registerConverterForProperty(converter, classInfo, property.name);
                }

                mapper = getMapper(property);
                if (mapper != null) {
                    registry.registerMapperForProperty(mapper, classInfo, property.name);
                }

            }

            classInfo = ClassInfo.forClass(classInfo.getSuperClass());
        }
    }

    private static function hasMetadata(metadataAware:MetadataAware, metadata:Class):Object {
        return getMetadata(metadataAware, metadata) != null;
    }

    private static function getMetadata(metadataAware:MetadataAware, metadata:Class):Object {
        const metaArray:Array = metadataAware.getMetadata(metadata);
        if (metaArray && metaArray.length > 0) {
            return metaArray[0];
        }
        return null;
    }

    private static function getAlias(metadataAware:MetadataAware):String {
        const aliasMeta:AStreamAlias = getMetadata(metadataAware, AStreamAlias) as AStreamAlias;
        if (aliasMeta) {
            return aliasMeta.name;
        }
        return null;
    }

    private static function createObject(typeName:String, metadataAware:MetadataAware, params:String, paramDelimiter:String):Object {
        const type:ClassInfo = ClassInfo.forName(typeName);
        const parameters:Array = type.getConstructor().parameters;
        const constructorArgs:Array = params != null ? params.split(paramDelimiter) : new Array();
        if (parameters.length > 0) {
            var firstParameter:Parameter = parameters[0] as Parameter;
            if (firstParameter.type.getClass() == ClassInfo) {
                var classInfo:ClassInfo = metadataAware as ClassInfo;
                if (classInfo == null) {
                    var property:Property = metadataAware as Property;
                    if (property != null) {
                        classInfo = property.type;
                    }
                }
                constructorArgs.unshift(classInfo);
            }
        }

        return type.newInstance(constructorArgs);
    }

    private static function getConverter(metadataAware:MetadataAware):Converter {
        const converterMeta:AStreamConverter = getMetadata(metadataAware, AStreamConverter) as AStreamConverter;
        if (converterMeta != null) {
            return createObject(converterMeta.converterType, metadataAware,
                                converterMeta.params, converterMeta.paramDelimiter) as Converter;
        }
        return null;
    }

    private static function getMapper(metadataAware:MetadataAware):Mapper {
        const mapperMeta:AStreamMapper = getMetadata(metadataAware, AStreamMapper) as AStreamMapper;
        if (mapperMeta != null) {
            return createObject(mapperMeta.mapperType, metadataAware,
                                mapperMeta.params, mapperMeta.paramDelimiter) as Mapper;
        }
        return null;
    }
}
}
