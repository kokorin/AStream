package ru.kokorin.astream.ref {
import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;

public class BaseRef implements AStreamRef {
    private const classMap:Map = new Map();

    public function hasRef(toValue:Object):Boolean {
        const classInfo:ClassInfo = ClassInfo.forInstance(toValue);
        const instanceMap:Map = classMap.get(classInfo);
        if (instanceMap) {
            return instanceMap.containsKey(toValue);
        }
        return false;
    }

    public function addValue(value:Object, atNode:XML):void {
        const classInfo:ClassInfo = ClassInfo.forInstance(value);
        var instanceMap:Map = classMap.get(classInfo);
        if (!instanceMap) {
            instanceMap = new Map();
            classMap.put(classInfo, instanceMap);
        }
        instanceMap.put(value, getValueRef(atNode));
    }

    public function getRef(toValue:Object, fromNode:XML):String {
        const classInfo:ClassInfo = ClassInfo.forInstance(toValue);
        const instanceMap:Map = classMap.get(classInfo);
        if (instanceMap) {
            return instanceMap.get(toValue) as String;
        }
        return null;
    }

    public function clear():void {
        for each (var instanceMap:Map in classMap.values) {
            instanceMap.removeAll();
        }
        classMap.removeAll();
    }

    protected function getValueRef(xml:XML):String {
        return null;
    }
}
}
