package ru.kokorin.astream.ref {
public class IdRef implements AStreamRef {
    private var nextId:int;
    private const values:Array = new Array();

    public function hasRef(toValue:Object):Boolean {
        return false;
    }

    public function getRef(toValue:Object):String {
        return "";
    }

    public function addValue(value:Object):void {
    }

    public function getValue(ref:String):Object {
        return null;
    }

    public function beginNode(nodeName:String):void {
    }

    public function endNode():void {
    }

    public function clear():void {
        nextId = 0;
        values.splice(0);
    }
}
}
