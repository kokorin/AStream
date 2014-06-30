package ru.kokorin.astream.converter {
public class SomeConverter implements Converter{
    public var param:String;

    public function SomeConverter(param:String) {
        this.param = param;
    }

    public function fromString(string:String):Object {
        return null;
    }

    public function toString(value:Object):String {
        return null;
    }
}
}
