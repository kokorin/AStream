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
import as3.lang.Enum;

import flash.utils.ByteArray;
import flash.utils.IExternalizable;

import org.spicefactory.lib.collection.List;

import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;

import ru.kokorin.astream.converter.Converter;
import ru.kokorin.astream.converter.BooleanConverter;
import ru.kokorin.astream.converter.ByteArrayConverter;
import ru.kokorin.astream.converter.DateConverter;
import ru.kokorin.astream.converter.EnumConverter;
import ru.kokorin.astream.converter.NumberConverter;
import ru.kokorin.astream.converter.StringConverter;
import ru.kokorin.astream.mapper.Mapper;
import ru.kokorin.astream.mapper.CollectionMapper;
import ru.kokorin.astream.mapper.ComplexMapper;
import ru.kokorin.astream.mapper.ExternalizableMapper;
import ru.kokorin.astream.mapper.MapMapper;
import ru.kokorin.astream.mapper.SimpleMapper;
import ru.kokorin.astream.util.TypeUtil;

public class AStreamRegistry {
    private var _autodetectMetadata:Boolean = false;
    private var metadataProcessor:AStreamMetadataProcessor;

    private const packageByAliasMap:Map = new Map();
    private const aliasByPackageMap:Map = new Map();
    private const classDataMap:Map = new Map();
    private const classByAliasMap:Map = new Map();

    private static const VECTOR_POSTFIX:String = "-array";
    private static const VECTOR_POSTFIX_LENGTH:int = VECTOR_POSTFIX.length;

    public function AStreamRegistry() {
        alias("null", null);
        alias("string", ClassInfo.forClass(String));
        alias("float", ClassInfo.forClass(Number));
        alias("int", ClassInfo.forClass(int));
        alias("uint", ClassInfo.forClass(uint));
        alias("date", ClassInfo.forClass(Date));
        alias("byte-array", ClassInfo.forClass(ByteArray));
        alias("list", ClassInfo.forClass(List));
        alias("map", ClassInfo.forClass(Map));
        metadataProcessor = new AStreamMetadataProcessor(this);
    }

    public function autodetectMetadata(value:Boolean):void {
        _autodetectMetadata = value;
    }

    public function processMetadata(classInfo:ClassInfo):void {
        metadataProcessor.processMetadata(classInfo);
        autodetectMetadata(false);
    }

    public function registerConverter(converter:Converter, classInfo:ClassInfo):void {
        const classData:ClassData = getClassData(classInfo);
        classData.converter = converter;
        classData.mapper = new SimpleMapper(classInfo, this, converter);
    }

    public function registerConverterProperty(converter:Converter, classInfo:ClassInfo, propertyName:String):void {
        const classData:ClassData = getClassData(classInfo);
        const propertyData:PropertyData = classData.getPropertyData(propertyName);

        propertyData.converter = converter;
        propertyData.mapper = new SimpleMapper(classInfo, this, converter);
    }

    public function getConverter(classInfo:ClassInfo):Converter {
        const classData:ClassData = getClassData(classInfo);

        if (classData.converter == null) {
            classData.converter = createConverter(classInfo);
        }
        return classData.converter;
    }

    public function getConverterProperty(classInfo:ClassInfo, propertyName:String):Converter {
        const propertyData:PropertyData = getClassData(classInfo).getPropertyData(propertyName);
        if (propertyData.converter) {
            return propertyData.converter;
        }
        const property:Property = classInfo.getProperty(propertyName);
        if (property != null) {
            return getConverter(property.type);
        }
        return null;
    }

    public function registerMapper(mapper:Mapper, classInfo:ClassInfo):void {
        const classData:ClassData = getClassData(classInfo);
        classData.mapper = mapper;
    }

    public function registerMapperProperty(mapper:Mapper, classInfo:ClassInfo, propertyName:String):void {
        const propertyData:PropertyData = getClassData(classInfo).getPropertyData(propertyName);
        propertyData.mapper = mapper;
    }

    public function getMapper(nameOrClassInfo:Object):Mapper {
        const classInfo:ClassInfo = getClassInfo(nameOrClassInfo);
        const classData:ClassData = getClassData(classInfo);

        if (classData.mapper == null) {
            if (_autodetectMetadata) {
                metadataProcessor.processMetadata(classInfo);
            }
            classData.mapper = createMapper(classInfo);
        }
        return classData.mapper;
    }

    public function getMapperProperty(classInfo:ClassInfo, propertyName:String):Mapper {
        const classData:ClassData = getClassData(classInfo);
        const propertyData:PropertyData = classData.getPropertyData(propertyName);
        if (propertyData.mapper) {
            return propertyData.mapper;
        }

        const property:Property = classInfo.getProperty(propertyName);
        if (property != null) {
            return getMapper(property.type);
        }
        return null;
    }

    public function aliasPackage(name:String, pckg:String):void {
        if (name == null) {
            name = "";
        }
        if (pckg == null) {
            pckg = "";
        }
        const oldName:String = aliasByPackageMap.get(pckg);
        const oldPckg:String = packageByAliasMap.get(name);
        if (oldName != null) {
            packageByAliasMap.remove(oldName);
        }
        if (oldPckg != null) {
            aliasByPackageMap.remove(oldPckg);
        }
        aliasByPackageMap.put(pckg, name);
        packageByAliasMap.put(name, pckg);
    }
    public function alias(name:String, classInfo:ClassInfo):void {
        const classData:ClassData = getClassData(classInfo);
        if (classData.alias != null) {
            classByAliasMap.remove(classData.alias);
        }
        classData.alias = name;
        classByAliasMap.put(name, classInfo);
    }
    public function getAlias(classInfo:ClassInfo):String {
        const alias:String = getClassData(classInfo).alias;
        if (alias != null) {
            return alias;
        }

        if (TypeUtil.isVector(classInfo)) {
            return getAlias(TypeUtil.getVectorItemType(classInfo)) + VECTOR_POSTFIX;
        }

        const pckgAndName:Array = classInfo.name.split("::");
        if (pckgAndName.length == 1) {
            pckgAndName.unshift("");
        }
        var pckg:String = pckgAndName[0] as String;
        const name:String = pckgAndName[1] as String;
        pckg = replaceByLongestMatch(pckg, aliasByPackageMap);
        if (pckg != null && pckg.length > 0) {
            return pckg + "." + name;
        }
        return name;
    }

    private function getClassInfo(nameOrClassInfo:Object):ClassInfo {
        var result:ClassInfo = nameOrClassInfo as ClassInfo;
        if (result == null) {
            if (nameOrClassInfo is String) {
                result = getClassByName(nameOrClassInfo as String);
            } else if (nameOrClassInfo is Class) {
                result = ClassInfo.forClass(nameOrClassInfo as Class);
            }
        }
        return result;
    }

    /** Declared as internal for tests*/
    internal function getClassByName(nameOrAlias:String):ClassInfo {
        if (classByAliasMap.containsKey(nameOrAlias)) {
            return classByAliasMap.get(nameOrAlias) as ClassInfo;
        }

        const postfixIndex:int = nameOrAlias.length - VECTOR_POSTFIX_LENGTH;
        const endsWithVector:Boolean = postfixIndex > 0 && nameOrAlias.substr(postfixIndex) == VECTOR_POSTFIX;
        if (endsWithVector) {
            nameOrAlias = nameOrAlias.substr(0, postfixIndex);
            const vectorItemType:ClassInfo = getClassByName(nameOrAlias);
            return TypeUtil.constructVectorWithItemType(vectorItemType);
        }

        const lastDotIndex:int = nameOrAlias.lastIndexOf(".");
        var pckg:String = nameOrAlias.substring(0, lastDotIndex);
        const name:String = nameOrAlias.substring(lastDotIndex+1);
        pckg = replaceByLongestMatch(pckg, packageByAliasMap);
        if (pckg != null && pckg.length > 0) {
            return ClassInfo.forName(pckg + "::" + name);
        }
        return ClassInfo.forName(name);
    }

    public function aliasProperty(name:String, classInfo:ClassInfo, propertyName:String):void {
        getClassData(classInfo).getPropertyData(propertyName).alias = name;
    }
    public function getAliasProperty(classInfo:ClassInfo, propertyName:String):String {
        var result:String = getClassData(classInfo).getPropertyData(propertyName).alias;
        if (result == null) {
            result = propertyName;
        }
        return result;
    }

    public function attribute(classInfo:ClassInfo, propertyName:String):void {
        getClassData(classInfo).getPropertyData(propertyName).attribute = true;
    }
    public function getAttribute(classInfo:ClassInfo, propertyName:String):Boolean {
        return getClassData(classInfo).getPropertyData(propertyName).attribute;
    }

    public function omit(classInfo:ClassInfo, propertyName:String):void {
        getClassData(classInfo).getPropertyData(propertyName).omit = true;
    }
    public function getOmit(classInfo:ClassInfo, propertyName:String):Boolean {
        return getClassData(classInfo).getPropertyData(propertyName).omit;
    }

    public function implicit(classInfo:ClassInfo, propertyName:String,
                                itemName:String, itemType:ClassInfo, keyProperty:String):void {
        const propertyData:PropertyData = getClassData(classInfo).getPropertyData(propertyName);
        propertyData.implicit = true;
        propertyData.implicitItemName = itemName;
        propertyData.implicitItemType = itemType;
        propertyData.implicitKeyProperty = keyProperty;
    }
    public function getImplicit(classInfo:ClassInfo, propertyName:String):Boolean {
        return getClassData(classInfo).getPropertyData(propertyName).implicit;
    }
    public function getImplicitItemName(classInfo:ClassInfo, propertyName:String):String {
        return getClassData(classInfo).getPropertyData(propertyName).implicitItemName;
    }
    public function getImplicitItemType(classInfo:ClassInfo, propertyName:String):ClassInfo {
        return getClassData(classInfo).getPropertyData(propertyName).implicitItemType;
    }
    public function getImplicitKeyProperty(classInfo:ClassInfo, propertyName:String):String {
        return getClassData(classInfo).getPropertyData(propertyName).implicitKeyProperty;
    }

    public function order(value:int, classInfo:ClassInfo, propertyName:String):void {
        getClassData(classInfo).getPropertyData(propertyName).order = value;
    }
    public function getOrder(classInfo:ClassInfo, propertyName:String):int {
        return getClassData(classInfo).getPropertyData(propertyName).order;
    }

    public function resetMappers():void {
        for each (var classData:ClassData in classDataMap.values) {
            classData.resetMappers();
        }
    }

    private function createConverter(classInfo:ClassInfo):Converter {
        if (classInfo) {
            if (classInfo.isType(Boolean)) {
                return new BooleanConverter();
            } else if (classInfo.isType(Date)) {
                return new DateConverter();
            } else if (classInfo.isType(Number)) {
                return new NumberConverter();
            } else if (classInfo.isType(String)) {
                return new StringConverter();
            } else if (classInfo.isType(ByteArray)) {
                return new ByteArrayConverter();
            } else if (classInfo.isType(Enum)) {
                return new EnumConverter(classInfo);
            }
        }
        return null;
    }

    private function createMapper(classInfo:ClassInfo):Mapper {
        if (classInfo == null || TypeUtil.isSimple(classInfo) || classInfo.isType(ByteArray)) {
            return new SimpleMapper(classInfo, this);
        }
        if (TypeUtil.isCollection(classInfo)) {
            return new CollectionMapper(classInfo, this);
        }
        if (TypeUtil.isMap(classInfo)) {
            return new MapMapper(classInfo, this);
        }
        if (classInfo.isType(IExternalizable)) {
            return new ExternalizableMapper(classInfo, this);
        }
        return new ComplexMapper(classInfo, this);
    }

    private function getClassData(classInfo:ClassInfo):ClassData {
        var result:ClassData = classDataMap.get(classInfo);
        if (result == null) {
            result = new ClassData();
            classDataMap.put(classInfo, result);
        }
        return result;
    }

    private static function replaceByLongestMatch(pckg:String, replaceMap:Map):String {
        if (pckg == null) {
            return null;
        }
        var match:String = null;
        for each (var test:String in replaceMap.keys) {
            if (match != null && test.length < match.length) {
                continue;
            }
            if (pckg == test || pckg.indexOf(test+".") == 0) {
                match = test;
            }
        }
        if (match != null) {
            const replace:String = replaceMap.get(match) as String;
            return replace + pckg.substr(match.length);
        }

        return pckg;
    }
}
}

import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.converter.Converter;
import ru.kokorin.astream.mapper.Mapper;

class ClassData {
    public var alias:String;
    public var mapper:Mapper;
    public var converter:Converter;
    private const propertyDataMap:Map = new Map();

    public function getPropertyData(propertyName:String):PropertyData {
        var result:PropertyData = propertyDataMap.get(propertyName);
        if (result == null) {
            result = new PropertyData();
            propertyDataMap.put(propertyName, result);
        }
        return result;
    }

    public function resetMappers():void {
        if (mapper) {
            mapper.reset();
        }
        for each (var propertyData:PropertyData in propertyDataMap.values) {
            if (propertyData.mapper) {
                propertyData.mapper.reset();
            }
        }
    }
}

class PropertyData {
    public var alias:String;
    public var mapper:Mapper;
    public var converter:Converter;
    public var attribute:Boolean = false;
    public var omit:Boolean = false;
    public var implicit:Boolean = false;
    public var implicitItemName:String = null;
    public var implicitItemType:ClassInfo = null;
    public var implicitKeyProperty:String = null;
    public var order:int = int.MAX_VALUE;
}
