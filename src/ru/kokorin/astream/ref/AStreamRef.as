package ru.kokorin.astream.ref {
public interface AStreamRef {
    function hasRef(toValue:Object):Boolean;

    function addValue(value:Object, atNode:XML):void;

    function getRef(toValue:Object, fromNode:XML):String;

    function clear():void;
}
}
