package ru.kokorin.astream.mapper {
import ru.kokorin.astream.ref.AStreamRef;

public interface AStreamMapper {
    function toXML(instance:Object, ref:AStreamRef, nodeName:String = null):XML;
    function fromXML(xml:XML, ref:AStreamRef):Object;

    function reset():void;
}
}