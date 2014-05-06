package ru.kokorin.astream.mapper {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Converter;
import org.spicefactory.lib.reflect.Converters;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.converter.DateConverter;
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.AStreamRef;

public class AStreamSimpleMapper implements AStreamMapper {
    private var classInfo:ClassInfo;
    private var registry:AStreamRegistry;

    private static const converters:Array = [[Date, new DateConverter()]];
    private static var convertersRegistered:Boolean = false;

    public function AStreamSimpleMapper(classInfo:ClassInfo, registry:AStreamRegistry) {
        this.classInfo = classInfo;
        this.registry = registry;
    }

    private static function registerConverters():void {
        if (convertersRegistered) {
            return;
        }
        for each (var typeConverterPair:Array in converters) {
            var type:Class = typeConverterPair[0] as Class;
            var converter:Converter = typeConverterPair[1] as Converter;
            Converters.addConverter(type, converter);
        }
        convertersRegistered = true;
    }

    public function toXML(instance:Object, ref:AStreamRef):XML {
        const name:String = registry.getAlias(classInfo);
        const result:XML = <{name}/>;
        fillXML(instance, result, ref);
        return result;
    }

    public function fromXML(xml:XML, deref:AStreamDeref):Object {
        registerConverters();
        var result:Object = null;
        if (xml) {
            result = Converters.convert(String(xml.text()), classInfo.getClass());
        }
        return result;
    }

    public function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
        registerConverters();
        if (xml != null && instance != null) {
            xml.appendChild(String(instance));
        }
    }
}
}
