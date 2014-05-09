package ru.kokorin.astream.converter {
public class BooleanConverter implements AStreamConverter {
    public function fromString(string:String):Object {
        return string == "true";
    }

    public function toString(value:Object):String {
        return String(value);
    }
}
}
