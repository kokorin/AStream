package ru.kokorin.astream.mapper {
import com.sociodox.utils.Base64;

import flash.utils.ByteArray;

import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.AStreamRef;

public class ByteArrayMapper implements AStreamMapper {
    private var classInfo:ClassInfo;
    private var registry:AStreamRegistry;

    public function ByteArrayMapper(classInfo:ClassInfo, registry:AStreamRegistry) {
        this.classInfo = classInfo;
        this.registry = registry;
    }

    public function toXML(instance:Object, ref:AStreamRef):XML {
        const name:String = registry.getAlias(classInfo);
        const result:XML = <{name}/>;
        fillXML(instance, result, ref);
        return result;
    }

    public function fromXML(xml:XML, deref:AStreamDeref):Object {
        var result:ByteArray = null;
        var text:String = String(xml);
        if (text && text != "") {
            result = Base64.decode(text);
        }
        return result;
    }

    public function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
        const byteArray:ByteArray = instance as ByteArray;
        if (byteArray) {
            xml.appendChild(Base64.encode(byteArray));
        }
    }
}
}
