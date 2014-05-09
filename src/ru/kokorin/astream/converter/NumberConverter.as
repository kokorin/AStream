package ru.kokorin.astream.converter {

public class NumberConverter implements AStreamConverter {
    public function fromString(string:String):Object {
        if (string) {
            return parseFloat(string);
        }
        return 0;
    }

    public function toString(value:Object):String {
        return String(value);
    }
}
}
