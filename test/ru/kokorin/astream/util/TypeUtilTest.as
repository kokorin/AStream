package ru.kokorin.astream.util {

import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;

import org.flexunit.assertThat;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertTrue;
import org.hamcrest.collection.array;
import org.spicefactory.lib.collection.List;
import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.valueobject.TestVO;

[RunWith("org.flexunit.runners.Parameterized")]
public class TypeUtilTest {
    public static var IS_SIMPLE:Array = [
        [Number,    true],
        [int,       true],
        [uint,      true],
        [Boolean,   true],
        [String,    true],
        [TestVO,    false]
    ];
    [Test(dataProvider="IS_SIMPLE")]
    public function testIsSimple(type:Class, isSimple:Boolean):void {
        const info:ClassInfo = ClassInfo.forClass(type);
        assertEquals("isSimple: " + info.name, TypeUtil.isSimple(info), isSimple);
    }

    public static var IS_COLLECTION_AND_IS_MAP:Array = [
        [Array,             true, false],
        [ArrayCollection,   true, false],
        [ArrayList,         true, false],
        [List,              true, false],
        [Vector.<int>,      true, false, int],
        [Vector.<Object>,   true, false, Object],
        [Vector.<Boolean>,  true, false, Boolean],
        [Vector.<uint>,     true, false, uint],
        [Vector.<String>,   true, false, String],
        [Vector.<TestVO>,   true, false, TestVO],
        //[Vector.<*>,        true, false, Object],
        [Object,            false, true],
        [Dictionary,        false, true],
        [Map,               false, true],
    ];
    [Test(dataProvider="IS_COLLECTION_AND_IS_MAP")]
    public function testIsCollection(type:Class, isCollection:Boolean, isMap:Boolean, itemType:Class = null):void {
        const typeInfo:ClassInfo = ClassInfo.forClass(type);
        const instanceInfo:ClassInfo = ClassInfo.forInstance(new type());

        assertEquals("forClass and forInstance", typeInfo, instanceInfo);
        assertEquals("isCollection: " + typeInfo.name, TypeUtil.isCollection(typeInfo), isCollection);
        if (itemType != null) {
            assertTrue("isVector: " + typeInfo.name, TypeUtil.isVector(typeInfo));
            assertEquals("getVectorItemType: " + typeInfo.name, TypeUtil.getVectorItemType(typeInfo).getClass(), itemType);
        }
        assertEquals("isMap: " + typeInfo.name, TypeUtil.isMap(typeInfo), isMap);
    }

    private static const COLLECTION:Array = [1, true, "Test", new TestVO()];
    public static var FOR_EACH_IN_COLLECTION:Array = [
        [Array,             COLLECTION],
        [List,              COLLECTION],
        [ArrayList,         COLLECTION],
        [ArrayCollection,   COLLECTION],
        [Vector.<Object>,   COLLECTION]
    ];
    [Test(dataProvider="FOR_EACH_IN_COLLECTION")]
    public function testForEachInCollection(type:Class, items:Array):void {
        const collection:Object = new type();
        const copy:Array = new Array();

        TypeUtil.addToCollection(collection, items);
        TypeUtil.forEachInCollection(collection,
                function(item:Object, index:int, collection:Object) {
                    copy[index] = item;
                }
        );

        assertThat(copy, array(items));
    }

    private static const KEYS:Array = COLLECTION;
    private static const VALUES:Array = COLLECTION.concat().reverse();
    private static function intOrString(item:*, index:int, array:Array):Object {
        if (item is int) {
            return item;
        }
        return String(item);
    }
    private static function notBoolean(item:*, index:int, array:Array):Object {
        if (item is Boolean) {
            return String(item);
        }
        return item;
    }

    public static var FOR_EACH_IN_MAP:Array = [
        [Object,        KEYS.map(intOrString), VALUES],
        [Dictionary,    KEYS.map(notBoolean), VALUES],
        [Map,           KEYS.map(notBoolean), VALUES]
    ];
    [Test(dataProvider="FOR_EACH_IN_MAP")]
    public function testForEachInMap(type:Class, keys:Array, values:Array):void {
        const map:Object = new type();
        const copyKeys:Array = new Array();
        const copyValues:Array = new Array();

        TypeUtil.putToMap(map, keys, values);
        TypeUtil.forEachInMap(map,
                function(value:Object, key:Object, map:Object) {
                    copyKeys.push(key);
                    copyValues.push(value);
                }
        );

        for (var i:int = 0; i < keys.length; i++) {
            var key:Object = keys[i];
            var value:Object = values[i];

            var copyI:int = copyKeys.indexOf(key);
            assertTrue("Key not found: " + key, copyI != -1);
            var copyValue:Object = copyValues[copyI];
            assertEquals("Values", copyValue, value);
        }
    }
}
}
