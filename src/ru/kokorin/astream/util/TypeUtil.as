package ru.kokorin.astream.util {
import as3.lang.Enum;

import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;

public class TypeUtil {
    private static const SIMPLE_TYPES:Array = [Boolean, int, uint, Number, String, Date, Enum];
    private static const ILIST_TYPE:ClassInfo = getIListInfo();
    private static const IS_VECTOR_MAP:Map = new Map();
    private static const ITEM_TYPE_MAP:Map = new Map();
    private static const VECTOR_NAME_REGEXP:RegExp = /__AS3__\.vec::Vector\.<(.*)>/;

    public static function isSimple(classInfo:ClassInfo):Boolean {
        for each (var clazz:Class in SIMPLE_TYPES) {
            if (classInfo.isType(clazz)) {
                return true;
            }
        }
        return false;
    }

    public static function isList(classInfo:ClassInfo):Boolean {
        return ILIST_TYPE && classInfo.isType(ILIST_TYPE.getClass());
    }

    public static function isVector(classInfo:ClassInfo):Boolean {
        if (IS_VECTOR_MAP.containsKey(classInfo)) {
            return IS_VECTOR_MAP.get(classInfo) as Boolean;
        }
        const match:Array = classInfo.name.match(VECTOR_NAME_REGEXP);
        const result:Boolean = match != null && match.length > 0;
        IS_VECTOR_MAP.put(classInfo, result);
        if (result) {
            const itemTypeName:String = match[1] as String;
            const itemType:ClassInfo = ClassInfo.forName(itemTypeName);
            ITEM_TYPE_MAP.put(classInfo, itemType);
        }
        return result;
    }

    public static function isCollection(classInfo:ClassInfo):Boolean {
        return classInfo.isType(Array) || isList(classInfo) || isVector(classInfo);
    }

    public static function getVectorItemType(classInfo:ClassInfo):ClassInfo {
        if (isVector(classInfo)) {
            return ITEM_TYPE_MAP.get(classInfo) as ClassInfo;
        }
        //TODO возможно стоит возвращать Object
        return null;
    }

    public static function constructVectorWithItemType(classInfo:ClassInfo):ClassInfo {
        return ClassInfo.forName("__AS3__.vec::Vector.<" + classInfo.name + ">");
    }

    public static function addToCollection(collection:Object, items:Array):void {
        if (!items || !items.length) {
            return;
        }
        const collectionInfo:ClassInfo = ClassInfo.forInstance(collection);
        var item:Object;
        //TODO possible optimization for array and vector with splice() method
        if (collectionInfo.isType(Array)) {
            const array:Array = collection as Array;
            for each (item in items) {
                array.push(item);
            }
        } else if (isList(collectionInfo)) {
            for each (item in items) {
                collection.addItem(item);
            }
        } else if (isVector(collectionInfo)) {
            for each (item in items) {
                collection.push(item);
            }
        }
    }


    /**
     * @param collection:Object — collection to iterate through
     * @param callback:Function — The function to run on each item in the array.
     * This function is invoked with three arguments:
        function callback(item:*, index:int, collection:Object):void;
     */
    public static function forEachInCollection(collection:Object, callback:Function):void {
        if (callback == null) {
            return;
        }
        const collectionInfo:ClassInfo = ClassInfo.forInstance(collection);
        if (collectionInfo.isType(Array)) {
            const array:Array = collection as Array;
            array.forEach(callback, null);
        } else if (isList(collectionInfo)) {
            for (var i:int = 0; i < collection.length; i++) {
                var item:Object = collection.getItemAt(i);
                callback(item, i, collection);
            }
        } else if (isVector(collectionInfo)) {
            collection.forEach(callback, null);
        }
    }

    private static function getIListInfo():ClassInfo {
        var result:ClassInfo;
        try {
            result = ClassInfo.forName("mx.collections.IList");
        } catch (e:Error) {

        }
        return result;
    }
}
}
