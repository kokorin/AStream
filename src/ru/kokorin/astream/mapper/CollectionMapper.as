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

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.util.TypeUtil;

/**
 * Maps a collection to a sequence of nested XML element nodes.
 * @see ru.kokorin.astream.util.TypeUtil#isCollection
 */
public class CollectionMapper extends SequenceMapper {

    public function CollectionMapper(classInfo:ClassInfo) {
        super(classInfo);
    }

    /** @inheritDoc */
    override protected function setSequence(instance:Object, sequence:Array):void {
        TypeUtil.addToCollection(instance, sequence);
    }

    /** @inheritDoc */
    override protected function getSequence(instance:Object):Object {
        return instance;
    }
}
}
