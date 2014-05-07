package ru.kokorin.astream.mapper {
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.AStreamRef;

public class NullMapper implements AStreamMapper {
    public function toXML(instance:Object, ref:AStreamRef):XML {
        return XML("<null/>");
    }

    public function fromXML(xml:XML, deref:AStreamDeref):Object {
        return null;
    }

    public function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
    }
}
}
