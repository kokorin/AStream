package ru.kokorin.astream.mapper {
import mx.collections.ArrayCollection;
import mx.collections.ArrayList;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertEquals;
import org.hamcrest.collection.array;

import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.AStreamNoDeref;
import ru.kokorin.astream.ref.AStreamNoRef;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.util.TypeUtil;

[RunWith("org.flexunit.runners.Parameterized")]
public class AStreamCollectionMapperTest {
    public static var TYPE_VALUES_PAIRS:Array = [
        [Array, [5, 2.5, -12]],
        [Array, ["Quot \" Apos \' amp & lt < gt > Me!", "Test Me123", 123]],
        [ArrayList, ["Quot \" Apos \' amp & lt < gt > Me!", "Test Me123", 123]],
        [ArrayCollection, [-123, 123]],
        [Vector.<Boolean>, [false, true]],
        [Vector.<int>, [123, 33, 412, 0]],
        [Vector.<uint>, [uint(321), uint(123), uint(0)]]
    ];

    private const registry:AStreamRegistry = new AStreamRegistry();
    private const noRef:AStreamRef = new AStreamNoRef();
    private const noDeref:AStreamDeref = new AStreamNoDeref();

    [Test(dataProvider="TYPE_VALUES_PAIRS")]
    public function test(type:Class, items:Array):void {
        const info:ClassInfo = ClassInfo.forClass(type);
        const values:Object = info.newInstance([]);
        TypeUtil.addToCollection(values, items);
        const collectionMapper:AStreamCollectionMapper = new AStreamCollectionMapper(info, registry);

        const xml:XML = collectionMapper.toXML(values, noRef);
        const restored:Object = collectionMapper.fromXML(xml, noDeref);
        const restoredItems:Array = new Array();
        TypeUtil.forEachInCollection(restored,
                function (item:Object, i:int, collection:Object):void {
                    restoredItems.push(item);
                }
        );

        assertEquals("Restored type", ClassInfo.forInstance(restored), info);
        assertThat("Restored value", restoredItems, array(items));
    }
}
}
