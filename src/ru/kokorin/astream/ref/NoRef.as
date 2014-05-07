package ru.kokorin.astream.ref {
public class NoRef implements AStreamRef {
    public function hasRef(object:Object):Boolean {
        return false;
    }

    //TODO добавить проверку на цикличиские зависимости
    public function addValue(value:Object, xml:XML):void {
    }

    public function getRef(value:Object):String {
        return null;
    }

    public function clear():void {
    }
}
}
