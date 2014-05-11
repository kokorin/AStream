package ru.kokorin.astream.mapper {
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.converter.AStreamConverter;
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.AStreamRef;

public class SimpleMapper implements AStreamMapper {
    private var classInfo:ClassInfo;
    private var registry:AStreamRegistry;

    public function SimpleMapper(classInfo:ClassInfo, registry:AStreamRegistry) {
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
        var result:Object = null;
        const converter:AStreamConverter = registry.getConverter(classInfo);
        if (xml != null && converter != null) {
            result = converter.fromString(String(xml.text()));
        }
        return result;
    }

    public function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
        const converter:AStreamConverter = registry.getConverter(classInfo);
        if (xml != null && instance != null && converter != null) {
            xml.appendChild(converter.toString(instance));
        }
    }
}
}
