package ru.kokorin.astream.ref {
import org.spicefactory.lib.collection.Map;

public class NoRef extends BaseRef implements AStreamRef {
    private const pathMap:Map = new Map();

    public function hasRef(toValue:Object):Boolean {
        return false;
    }

    public function getRef(toValue:Object):String {
        return null;
    }

    public function addValue(value:Object):void {
        const curPath:Array = getCurrentXPath();
        if (pathMap.containsKey(value)) {
            const prevPath:Array = pathMap.get(value) as Array;
            if (isParentPath(curPath, prevPath)) {
                throw new Error("Recursive reference to parent object");
            }
        }
        pathMap.put(value, curPath);
    }

    public function getValue(ref:String):Object {
        return null;
    }

    private static function isParentPath(path:Array, parentPath:Array):Boolean {
        if (path.length > parentPath.length) {
            return false;
        }
        for (var i:int = 0; i < path.length; i++) {
            if (path[i] != parentPath[i]) {
                return false;
            }
        }
        return true;
    }
}
}
