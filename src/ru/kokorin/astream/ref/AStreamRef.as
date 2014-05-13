package ru.kokorin.astream.ref {
public interface AStreamRef {
    function hasRef(toValue:Object):Boolean;
    function getRef(toValue:Object):String;

    function addValue(value:Object):void;
    function getValue(ref:String):Object;

    function beginNode(nodeName:String):void;
    function endNode():void;

    function clear():void;
}
}
