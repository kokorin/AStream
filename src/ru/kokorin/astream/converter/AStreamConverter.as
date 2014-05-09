package ru.kokorin.astream.converter {
public interface AStreamConverter {
    function fromString(string:String):Object;
    function toString(value:Object):String;
}
}
