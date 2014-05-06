package ru.kokorin.astream.ref {
public interface AStreamDeref {
    function addRef(value:Object, xml:XML):void;
    function getValue(ref:String):Object;
    function clear():void;
}
}
