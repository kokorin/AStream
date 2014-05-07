package ru.kokorin.astream.mapper {
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.util.TypeUtil;

public class CollectionMapper extends SequenceMapper {

    public function CollectionMapper(classInfo:ClassInfo, registry:AStreamRegistry) {
        super(classInfo, registry);
    }

    override protected function setSequence(instance:Object, sequence:Array):void {
        TypeUtil.addToCollection(instance, sequence);
    }

    override protected function getSequence(instance:Object):Object {
        return instance;
    }
}
}
