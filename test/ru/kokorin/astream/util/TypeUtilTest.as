package ru.kokorin.astream.util {

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertTrue;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.valueobject.TestVO;

[RunWith("org.flexunit.runners.Parameterized")]
public class TypeUtilTest {
    public static var SIMPLE_TYPES:Array = [[Number], [int], [uint], [Boolean], [String]];
    [Test(dataProvider="SIMPLE_TYPES")]
    public function testIsSimple(type:Class) {
        const info:ClassInfo = ClassInfo.forClass(type);

        assertTrue("Expected to be SIMPLE: " + info.name, TypeUtil.isSimple(info));
    }

    public static var COMPLEX_TYPES:Array = [[TestVO]];
    [Test(dataProvider="COMPLEX_TYPES")]
    public function testIsComplex(type:Class) {
        const info:ClassInfo = ClassInfo.forClass(type);

        assertFalse("Expected to be COMPLEX: " + info.name, TypeUtil.isSimple(info));
    }

    public static var COLLECTION_TYPES:Array = [
        [Array],
        [ArrayCollection],
        [ArrayList],
        [Vector.<int>],
        [Vector.<Object>],
        [Vector.<Boolean>],
        [Vector.<uint>],
        [Vector.<String>],
        [Vector.<TestVO>]
    ];
    [Test(dataProvider="COLLECTION_TYPES")]
    public function testIsCollection(type:Class) {
        const info:ClassInfo = ClassInfo.forClass(type);
        const collection:Object = new type();
        const collectionInfo:ClassInfo = ClassInfo.forInstance(collection);

        assertEquals("ClassInfo.forClass(type) and ClassInfo.forInstance(new type())", info, collectionInfo);
        assertTrue("Expected to be a COLLECTION: " + info.name, TypeUtil.isCollection(info));
    }

    public static var VECTOR_TYPES:Array = [
        [Vector.<int>, int],
        [Vector.<Object>, Object],
        [Vector.<TestVO>, TestVO]
    ];
    [Test(dataProvider="VECTOR_TYPES")]
    public function testVector(type:Class, itemType:Class) {
        const info:ClassInfo = ClassInfo.forClass(type);

        assertTrue("Expected to be a VECTOR: " + info.name, TypeUtil.isVector(info));
        assertEquals("Item type of " + info.name, itemType, TypeUtil.getVectorItemType(info).getClass());
    }

    public static var NOT_COLLECTION_TYPES:Array = [[TestVO], [Number], [Boolean]];
    [Test(dataProvider="NOT_COLLECTION_TYPES")]
    public function testIsNotCollection(type:Class) {
        const info:ClassInfo = ClassInfo.forClass(type);

        assertFalse("Expected not to be a COLLECTION: " + info.name, TypeUtil.isCollection(info));
    }

}
}
