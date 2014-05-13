package ru.kokorin.astream {
import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.converter.AStreamConverter;
import ru.kokorin.astream.mapper.AStreamMapper;
import ru.kokorin.astream.util.TypeUtil;

public class AStreamRegistry {
    private var _autodetectMetadata:Boolean = false;
    private var metadataProcessor:AStreamMetadataProcessor;

    private const packageByAliasMap:Map = new Map();
    private const aliasByPackageMap:Map = new Map();
    private const classDataMap:Map = new Map();
    private const classByAliasMap:Map = new Map();

    private const mapperFactory:AStreamMapperFactory = new AStreamMapperFactory();
    private const converterFactory:AStreamConverterFactory = new AStreamConverterFactory();

    private static const VECTOR_ALIAS:String = "vector-";

    public function AStreamRegistry() {
        alias("null", null);
        metadataProcessor = new AStreamMetadataProcessor(this);
    }

    public function autodetectMetadata(value:Boolean):void {
        _autodetectMetadata = value;
    }

    public function processMetadata(classInfo:ClassInfo):void {
        metadataProcessor.processMetadata(classInfo);
        autodetectMetadata(false);
    }

    public function getConverter(classInfo:ClassInfo):AStreamConverter {
        const classData:ClassData = getClassData(classInfo);
        if (!classData.converter) {
            classData.converter = converterFactory.createConverter(classInfo);
        }
        return classData.converter;
    }

    public function getMapper(nameOrClass:Object):AStreamMapper {
        var classInfo:ClassInfo = nameOrClass as ClassInfo;
        if (!classInfo) {
            if (nameOrClass is String) {
                classInfo = getClass(nameOrClass as String);
            } else if (nameOrClass is Class) {
                classInfo = ClassInfo.forClass(nameOrClass as Class);
            }
        }

        const classData:ClassData = getClassData(classInfo);
        if (!classData.mapper) {
            if (_autodetectMetadata) {
                metadataProcessor.processMetadata(classInfo);
            }
            classData.mapper = mapperFactory.createMapper(classInfo, this);
        }
        return classData.mapper;
    }

    public function aliasPackage(name:String, pckg:String):void {
        if (!name) {
            name = "";
        }
        if (!pckg) {
            pckg = "";
        }
        const oldName:String = aliasByPackageMap.get(pckg);
        const oldPckg:String = packageByAliasMap.get(name);
        if (oldName) {
            packageByAliasMap.remove(oldName);
        }
        if (oldPckg) {
            aliasByPackageMap.remove(oldPckg);
        }
        aliasByPackageMap.put(pckg, name);
        packageByAliasMap.put(name, pckg);
    }
    public function alias(name:String, classInfo:ClassInfo):void {
        const classData:ClassData = getClassData(classInfo);
        if (classData.alias) {
            classByAliasMap.remove(classData.alias);
        }
        classData.alias = name;
        classByAliasMap.put(name, classInfo);
    }
    public function getAlias(classInfo:ClassInfo):String {
        const alias:String = getClassData(classInfo).alias;
        if (alias) {
            return alias;
        }

        if (TypeUtil.isVector(classInfo)) {
            return VECTOR_ALIAS + getAlias(TypeUtil.getVectorItemType(classInfo));
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

    /** Declared as internal for tests*/
    internal function getClass(nameOrAlias:String):ClassInfo {
        if (classByAliasMap.containsKey(nameOrAlias)) {
            return classByAliasMap.get(nameOrAlias);
        }

        const beginsWithVector:Boolean = nameOrAlias.indexOf(VECTOR_ALIAS) == 0;
        if (beginsWithVector) {
            nameOrAlias = nameOrAlias.substr(VECTOR_ALIAS.length);
            const vectorItemType:ClassInfo = getClass(nameOrAlias);
            return TypeUtil.constructVectorWithItemType(vectorItemType);
        }

        const lastDotIndex:int = nameOrAlias.lastIndexOf(".");
        var pckg:String = nameOrAlias.substring(0, lastDotIndex);
        const name:String = nameOrAlias.substring(lastDotIndex+1);
        pckg = replaceByLongestMatch(pckg, packageByAliasMap);
        if (pckg != null && pckg != "") {
            return ClassInfo.forName(pckg + "::" + name);
        }
        return ClassInfo.forName(name);
    }

    public function aliasProperty(name:String, classInfo:ClassInfo, propertyName:String):void {
        getClassData(classInfo).getPropertyData(propertyName).alias = name;
    }
    public function getAliasProperty(classInfo:ClassInfo, propertyName:String):String {
        var result:String = getClassData(classInfo).getPropertyData(propertyName).alias;
        if (!result) {
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

    public function implicitCollection(classInfo:ClassInfo, propertyName:String, itemName:String, itemType:ClassInfo):void {
        const propertyData:PropertyData = getClassData(classInfo).getPropertyData(propertyName);
        propertyData.implicitCollection = true;
        propertyData.implicitItemName = itemName;
        propertyData.implicitItemType = itemType;
    }
    public function getImplicitCollection(classInfo:ClassInfo, propertyName:String):Boolean {
        return getClassData(classInfo).getPropertyData(propertyName).implicitCollection;
    }
    public function getImplicitItemName(classInfo:ClassInfo, propertyName:String):String {
        return getClassData(classInfo).getPropertyData(propertyName).implicitItemName;
    }
    public function getImplicitItemType(classInfo:ClassInfo, propertyName:String):ClassInfo {
        return getClassData(classInfo).getPropertyData(propertyName).implicitItemType;
    }

    public function order(value:int, classInfo:ClassInfo, propertyName:String):void {
        getClassData(classInfo).getPropertyData(propertyName).order = value;
    }
    public function getOrder(classInfo:ClassInfo, propertyName:String):int {
        return getClassData(classInfo).getPropertyData(propertyName).order;
    }

    private function getClassData(classInfo:ClassInfo):ClassData {
        var result:ClassData = classDataMap.get(classInfo);
        if (!result) {
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

import ru.kokorin.astream.converter.AStreamConverter;

import ru.kokorin.astream.mapper.AStreamMapper;

class ClassData {
    public var alias:String;
    public var mapper:AStreamMapper;
    public var converter:AStreamConverter;
    private const propertyDataMap:Map = new Map();

    public function getPropertyData(propertyName:String):PropertyData {
        var result:PropertyData = propertyDataMap.get(propertyName);
        if (!result) {
            result = new PropertyData();
            propertyDataMap.put(propertyName, result);
        }
        return result;
    }
}

class PropertyData {
    public var alias:String;
    public var attribute:Boolean = false;
    public var omit:Boolean = false;
    public var implicitCollection:Boolean = false;
    public var implicitItemName:String = null;
    public var implicitItemType:ClassInfo = null;
    public var order:int = int.MAX_VALUE;
}
