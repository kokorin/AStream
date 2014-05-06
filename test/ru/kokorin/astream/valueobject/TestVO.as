package ru.kokorin.astream.valueobject {
import flash.utils.getQualifiedClassName;

public class TestVO {
    public var name:String;
    public var value1:Number;
    public var value2:int;
    public var value3:uint;
    public var value4:Object;
    public var checked:Boolean;
    public var children:Array;

    public function TestVO(name:String = null) {
        this.name = name;
    }


    public function toString():String {
        return getQualifiedClassName(this) + "{name=" + String(name) + "}";
    }

    public function describe():String {
        return getQualifiedClassName(this) + "{name=" + String(name) +
                ",value1=" + String(value1) +
                ",value2=" + String(value2) +
                ",value3=" + String(value3) +
                ",value4=" + String(value4) +
                ",checked=" + String(checked) +
                ",children=" + String(children) + "}";
    }
}
}
