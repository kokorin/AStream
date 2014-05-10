package ru.kokorin.astream.ref {
public class NoDeref implements AStreamDeref {
    public function addRef(value:Object, xml:XML):void {
    }

    public function getValue(ref:String, atNode:XML):Object {
        return null;
    }

    public function clear():void {
    }
}
}
