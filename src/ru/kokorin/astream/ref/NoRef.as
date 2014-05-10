package ru.kokorin.astream.ref {
public class NoRef implements AStreamRef {
    public function hasRef(toValue:Object):Boolean {
        return false;
    }

    //TODO добавить проверку на цикличиские зависимости
    public function addValue(value:Object, atNode:XML):void {
    }

    public function getRef(toValue:Object, fromNode:XML):String {
        return null;
    }

    public function clear():void {
    }
}
}
