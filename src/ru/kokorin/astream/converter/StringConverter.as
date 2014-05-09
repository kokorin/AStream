package ru.kokorin.astream.converter {
public class StringConverter implements AStreamConverter {
    public function fromString(string:String):Object {
        return string;
    }

    public function toString(value:Object):String {
        return value as String;
    }
}
}
