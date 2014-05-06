package ru.kokorin.astream.mapper {
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.AStreamRef;

public interface AStreamMapper {
    function toXML(instance:Object, ref:AStreamRef):XML;
    function fromXML(xml:XML, deref:AStreamDeref):Object;

    function fillXML(instance:Object, xml:XML, ref:AStreamRef):void;
    //function fillObject(xml:XML, instance:Object):void;
}
}