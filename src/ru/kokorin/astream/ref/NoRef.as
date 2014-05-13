package ru.kokorin.astream.ref {
public class NoRef implements AStreamRef {
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
    }
}
}
