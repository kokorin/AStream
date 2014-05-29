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
