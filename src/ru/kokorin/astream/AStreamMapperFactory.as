package ru.kokorin.astream {
import flash.utils.ByteArray;
import flash.utils.IExternalizable;

import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.mapper.AStreamMapper;
import ru.kokorin.astream.mapper.CollectionMapper;
import ru.kokorin.astream.mapper.ComplexMapper;
import ru.kokorin.astream.mapper.ExternalizableMapper;
import ru.kokorin.astream.mapper.SimpleMapper;
import ru.kokorin.astream.util.TypeUtil;

public class AStreamMapperFactory {
    public function createMapper(classInfo:ClassInfo, registry:AStreamRegistry):AStreamMapper {
        if (classInfo == null || TypeUtil.isSimple(classInfo) || classInfo.isType(ByteArray)) {
            return new SimpleMapper(classInfo, registry);
        }
        if (TypeUtil.isCollection(classInfo)) {
            return new CollectionMapper(classInfo, registry);
        }
        if (classInfo.isType(IExternalizable)) {
            return new ExternalizableMapper(classInfo, registry);
        }
        return new ComplexMapper(classInfo, registry);
    }
}
}
