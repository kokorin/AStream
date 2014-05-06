package ru.kokorin.astream {
import flash.utils.ByteArray;
import flash.utils.IExternalizable;

import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.mapper.AStreamByteArrayMapper;

import ru.kokorin.astream.mapper.AStreamCollectionMapper;

import ru.kokorin.astream.mapper.AStreamComplexMapper;
import ru.kokorin.astream.mapper.AStreamExternalizableMapper;

import ru.kokorin.astream.mapper.AStreamMapper;
import ru.kokorin.astream.mapper.AStreamNullMapper;
import ru.kokorin.astream.mapper.AStreamSimpleMapper;
import ru.kokorin.astream.util.TypeUtil;

public class AStreamMapperFactory {
    public function createMapper(classInfo:ClassInfo, registry:AStreamRegistry):AStreamMapper {
        if (classInfo == null) {
            return new AStreamNullMapper();
        }
        if (TypeUtil.isSimple(classInfo)) {
            return new AStreamSimpleMapper(classInfo, registry);
        }
        if (classInfo.isType(ByteArray)) {
            return new AStreamByteArrayMapper(classInfo, registry);
        }
        if (TypeUtil.isCollection(classInfo)) {
            return new AStreamCollectionMapper(classInfo, registry);
        }
        if (classInfo.isType(IExternalizable)) {
            return new AStreamExternalizableMapper(classInfo, registry);
        }
        return new AStreamComplexMapper(classInfo, registry);
    }
}
}
