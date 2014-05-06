package ru.kokorin.astream.ref {
import org.spicefactory.lib.collection.Map;

public class AStreamBaseDeref implements AStreamDeref {
    const refMap:Map = new Map();

    public function AStreamBaseDeref() {
    }

    public function addRef(value:Object, xml:XML):void {
        const ref:String = getValueRef(xml);
        refMap.put(ref, value);
    }

    public function getValue(ref:String):Object {
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
