package ru.kokorin.astream.ref {
import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;

public class NoRef implements AStreamRef {
    private const classMap:Map = new Map();

    public function hasRef(toValue:Object):Boolean {
        return false;
    }

    public function addValue(value:Object, atNode:XML):void {
        const classInfo:ClassInfo = ClassInfo.forInstance(value);
        var instanceMap:Map = classMap.get(classInfo);
        if (!instanceMap) {
            instanceMap = new Map();
            classMap.put(classInfo, instanceMap);
        }
        const oldNode:XML = instanceMap.put(value, atNode) as XML;
        if (oldNode) {
            while (atNode) {
                atNode = atNode.parent();
                if (oldNode == atNode) {
                    throw new Error("Recursive reference to parent object");
                }
            }
        }
    }

    public function getRef(toValue:Object, fromNode:XML):String {
        return null;
    }

    public function clear():void {
        for each (var instanceMap:Map in classMap.values) {
            instanceMap.removeAll();
        }
        classMap.removeAll();
    }
}
}
