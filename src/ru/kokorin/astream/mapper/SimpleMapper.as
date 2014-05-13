package ru.kokorin.astream.mapper {
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.converter.AStreamConverter;
import ru.kokorin.astream.ref.AStreamRef;

public class SimpleMapper implements AStreamMapper {
    private var classInfo:ClassInfo;
    private var registry:AStreamRegistry;
    private var nodeName:String;
    private var converter:AStreamConverter;

    public function SimpleMapper(classInfo:ClassInfo, registry:AStreamRegistry) {
        this.classInfo = classInfo;
        this.registry = registry;
        reset();
    }

    public function fromXML(xml:XML, ref:AStreamRef):Object {
        var result:Object = null;
        if (xml != null && converter != null) {
            result = converter.fromString(String(xml.text()));
        }
        return result;
    }

    public function toXML(instance:Object, ref:AStreamRef, nodeName:String = null):XML {
        if (nodeName == null) {
            nodeName = this.nodeName;
        }
        const result:XML = <{nodeName}/>;
        if (instance != null && converter != null) {
            result.appendChild(converter.toString(instance));
        }
        return result;
    }

    public function reset():void {
        nodeName = registry.getAlias(classInfo);
        converter = registry.getConverter(classInfo);
    }
}
}
