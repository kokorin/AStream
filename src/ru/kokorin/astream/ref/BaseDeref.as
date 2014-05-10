package ru.kokorin.astream.ref {
import org.spicefactory.lib.collection.Map;

public class BaseDeref implements AStreamDeref {
    private const refMap:Map = new Map();

    public function BaseDeref() {
    }

    public function addRef(value:Object, xml:XML):void {
        const ref:String = getValueRef(xml);
        refMap.put(ref, value);
    }

    public function getValue(ref:String, atNode:XML):Object {
        return refMap.get(ref);
    }

    public function clear():void {
        refMap.removeAll();
    }

    protected function getValueRef(xml:XML):String {
        return null;
    }
}
}
