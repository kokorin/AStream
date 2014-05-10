package ru.kokorin.astream.ref {
public interface AStreamDeref {
    function addRef(value:Object, xml:XML):void;

    function getValue(ref:String, atNode:XML):Object;

    function clear():void;
}
}
