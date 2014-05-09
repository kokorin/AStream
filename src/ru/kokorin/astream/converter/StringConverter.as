package ru.kokorin.astream.converter {
/** Although " and ' are not escaped by XML in AS3,
 * XStream correctly reads such XML.
 * So we can just pass values through */
public class StringConverter implements AStreamConverter {
    public function fromString(string:String):Object {
        return string;
    }

    public function toString(value:Object):String {
        return value as String;
    }
}
}
