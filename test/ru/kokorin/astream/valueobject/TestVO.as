package ru.kokorin.astream.valueobject {
import flash.utils.getQualifiedClassName;

public class TestVO {
    public var name:String;
    public var enum:EnumVO;
    public var date:Date;
    public var date2:Date;
    public var value1:Number;
    public var value2:int = 2147483640;
    public var value3:uint = 4294967290;
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
        const result:Array = [name];
        if (enum != null) {
            result.push("enum="+enum);
        }
        if (date != null) {
            result.push("date="+date);
        }
        if (date2 != null) {
            result.push("date2="+date2);
        }
        if (!isNaN(value1)) {
            result.push("value1="+value1);
        }
        result.push("value2="+value2);
        result.push("value3="+value3);
        if (value4 != null) {
            result.push("value4="+value4);
        }
        result.push("checked="+checked);
        if (children != null) {
            result.push("children="+children);
        }
        const clazzName:String = getQualifiedClassName(this).split(".").reverse()[0];
        return clazzName + "{" + result.join(", ") + "}";
    }
}
}
