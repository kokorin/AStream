package ru.kokorin.astream.ref {
import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;

public class BaseRef implements AStreamRef {
    private const classMap:Map = new Map();

    public function hasRef(toValue:Object):Boolean {
        const classInfo:ClassInfo = ClassInfo.forInstance(toValue);
        return getClassData(classInfo).hasInstanceData(toValue);
    }

    public function addValue(value:Object, atNode:XML):void {
        const classInfo:ClassInfo = ClassInfo.forInstance(value);
        const instanceData:InstanceData = getClassData(classInfo).getInstanceData(value);
        instanceData.ref = getValueRef(atNode);
    }

    public function getRef(toValue:Object, fromNode:XML):String {
        const classInfo:ClassInfo = ClassInfo.forInstance(toValue);
        return getClassData(classInfo).getInstanceData(toValue).ref;
    }

    public function clear():void {
        for each (var data:ClassData in classMap.values) {
            data.clear();
        }
        classMap.removeAll();
    }

    protected function getValueRef(xml:XML):String {
        return null;
    }

    private function getClassData(classInfo:ClassInfo):ClassData {
        var result:ClassData = classMap.get(classInfo);
        if (!result) {
            result = new ClassData();
            classMap.put(classInfo, result);
        }
        return result;
    }
}
}

import org.spicefactory.lib.collection.Map;

class ClassData {
    private const instanceMap:Map = new Map();

    public function hasInstanceData(instance:Object):Boolean {
        return instanceMap.containsKey(instance);
    }

    public function getInstanceData(instance:Object):InstanceData {
        var result:InstanceData = instanceMap.get(instance);
        if (!result) {
            result = new InstanceData();
            instanceMap.put(instance, result);
        }
        return result;
    }

    public function clear():void {
        instanceMap.removeAll();
    }
}

class InstanceData {
    public var ref:String;
}
