package ru.kokorin.astream.ref {
public interface AStreamRef {
    function hasRef(object:Object):Boolean;

    function addValue(value:Object, xml:XML):void;

    function getRef(value:Object):String;

    function clear():void;
}
}
