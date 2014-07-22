package ru.kokorin.astream.converter {
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.mapper.Mapper;
import ru.kokorin.astream.ref.AStreamRef;

public class SomeMapper implements Mapper {
    public var classInfo:ClassInfo;
    public var param:String;

    public function SomeMapper(classInfo:ClassInfo, param:String) {
        this.classInfo = classInfo;
        this.param = param;
    }

    public function toXML(instance:Object, ref:AStreamRef, nodeName:String = null):XML {
        return null;
    }

    public function fromXML(xml:XML, ref:AStreamRef):Object {
        return null;
    }

    public function set registry(value:AStreamRegistry):void {
    }

    public function get registry():AStreamRegistry {
        return null;
    }

    public function reset():void {
    }
}
}
