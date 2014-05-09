package ru.kokorin.astream {
import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.converter.AStreamConverter;
import ru.kokorin.astream.mapper.AStreamMapper;
import ru.kokorin.astream.util.TypeUtil;

public class AStreamRegistry {
    private var _autodetectMetadata:Boolean = false;
    private var metadataProcessor:AStreamMetadataProcessor;
    private const mapperMap:Map = new Map();
    private const classDataMap:Map = new Map();
    private const aliasMap:Map = new Map();
    private const converterMap:Map = new Map();
    private const mapperFactory:AStreamMapperFactory = new AStreamMapperFactory();
    private const converterFactory:AStreamConverterFactory = new AStreamConverterFactory();

    private static const VECTOR_ALIAS:String = "vector-";

    public function AStreamRegistry() {
        alias("null", null);
        metadataProcessor = new AStreamMetadataProcessor(this);
    }

    public function getConverter(classInfo:ClassInfo):AStreamConverter {
        if (converterMap.containsKey(classInfo)) {
            return converterMap.get(classInfo) as AStreamConverter;
        }
        const converter:AStreamConverter = converterFactory.createConverter(classInfo);
        converterMap.put(classInfo, converter);
        return converter;
    }

    public function autodetectMetadata(value:Boolean):void {
        _autodetectMetadata = value;
    }

    public function processMetadata(classInfo:ClassInfo):void {
        metadataProcessor.processMetadata(classInfo);
        autodetectMetadata(false);
    }

    public function getMapperForClass(classInfo:ClassInfo):AStreamMapper {
        var mapper:AStreamMapper = mapperMap.get(classInfo);
        if (!mapper) {
            if (_autodetectMetadata) {
                metadataProcessor.processMetadata(classInfo);
            }
            mapper = mapperFactory.createMapper(classInfo, this);
            mapperMap.put(classInfo, mapper);
        }
        return mapper;
    }

    public function getMapperForName(name:String):AStreamMapper {
        return getMapperForClass(getClass(name));
    }

    public function alias(name:String, classInfo:ClassInfo):void {
        const classData:ClassData = getClassData(classInfo);
        if (classData.alias) {
            aliasMap.remove(classData.alias);
        }
        classData.alias = name;
        aliasMap.put(name, classInfo);
    }
    public function getAlias(classInfo:ClassInfo):String {
        //TODO необходимо учитывать алиасы на пакеты
        var result:String = getClassData(classInfo).alias;
        if (!result) {
            if (TypeUtil.isVector(classInfo)) {
                result = VECTOR_ALIAS + getAlias(TypeUtil.getVectorItemType(classInfo));
            } else  {
                result = classInfo.name.replace("::", ".");
            }
        }
        return result;
    }

    private function getClass(nameOrAlias:String):ClassInfo {
        //TODO необходимо учитывать алиасы на пакеты
        if (aliasMap.containsKey(nameOrAlias)) {
            return aliasMap.get(nameOrAlias);
        }

        const beginsWithVector:Boolean = nameOrAlias.indexOf(VECTOR_ALIAS) == 0;
        if (beginsWithVector) {
            nameOrAlias = nameOrAlias.substr(VECTOR_ALIAS.length);
            const vectorItemType:ClassInfo = getClass(nameOrAlias);
            return TypeUtil.constructVectorWithItemType(vectorItemType);
        }

        const lastDotIndex:int = nameOrAlias.lastIndexOf(".");
        if (lastDotIndex != -1) {
            nameOrAlias = nameOrAlias.substring(0, lastDotIndex) + "::" + nameOrAlias.substring(lastDotIndex+1);
        }
        return ClassInfo.forName(nameOrAlias);
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
}
}

import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;

class ClassData {
    public var alias:String;
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
