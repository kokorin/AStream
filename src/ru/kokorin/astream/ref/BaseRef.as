package ru.kokorin.astream.ref {
import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;

public class BaseRef implements AStreamRef {
    private const classMap:Map = new Map();

    public function hasRef(object:Object):Boolean {
        return getRef(object) != null;
    }

    public function addValue(value:Object, xml:XML):void {
        const classInfo:ClassInfo = ClassInfo.forInstance(value);
        var valueMap:Map = classMap.get(classInfo) as Map;
        if (!valueMap) {
            valueMap = new Map();
            classMap.put(classInfo, valueMap);
        }
        const ref:String = getValueRef(xml);
        valueMap.put(value, ref);
    }

    public function getRef(value:Object):String {
        const classInfo:ClassInfo = ClassInfo.forInstance(value);
        const valueMap:Map = classMap.get(classInfo) as Map;
        if (valueMap) {
            return valueMap.get(value) as String;
        }
        return null;
    }

    public function clear():void {
        for each (var valueMap:Map in classMap.values) {
            valueMap.removeAll();
        }
        classMap.removeAll();
    }

    protected function getValueRef(xml:XML):String {
        return null;
    }
}
}
