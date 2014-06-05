package ru.kokorin.astream.mapper {
import flash.utils.Dictionary;

import mx.utils.ObjectUtil;

import org.flexunit.asserts.assertEquals;
import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.ref.NoRef;
import ru.kokorin.astream.valueobject.EnumVO;
import ru.kokorin.astream.valueobject.TestVO;

[RunWith("org.flexunit.runners.Parameterized")]
public class MapMapperTest {
    private const registry:AStreamRegistry = new AStreamRegistry();
    private const noRef:AStreamRef = new NoRef();

    [Test]
    public function testObject():void {
        const original:Object = new Object();
        original["name"] = "Object";
        original["number"] = 5;
        original["array"] = [new TestVO("First"), null, new TestVO("Third")];

        const mapper:MapMapper = new MapMapper(ClassInfo.forClass(Object), registry);
        const xml:XML = mapper.toXML(original, noRef);
        const restored:Object = mapper.fromXML(xml, noRef);

        assertEquals(ObjectUtil.toString(original), ObjectUtil.toString(restored));
    }

    [Test]
    public function testDictionary():void {
        const original:Dictionary = new Dictionary();
        original["name"] = "Object";
        original[123] = 321;
        original[EnumVO.FIRST] = EnumVO.SECOND;
        original[new Object()] = [new TestVO("First"), null, new TestVO("Third")];

        const mapper:MapMapper = new MapMapper(ClassInfo.forInstance(original), registry);
        const xml:XML = mapper.toXML(original, noRef);
        const restored:Object = mapper.fromXML(xml, noRef);

        assertEquals(ObjectUtil.toString(original), ObjectUtil.toString(restored));
    }

    [Test]
    public function testMap():void {
        const original:Map = new Map();
        original.put("name", "Object");
        original.put(123, 321);
        original.put(EnumVO.FIRST, EnumVO.SECOND);
        original.put(new Object(), [new TestVO("First"), null, new TestVO("Third")]);

        const mapper:MapMapper = new MapMapper(ClassInfo.forInstance(original), registry);
        const xml:XML = mapper.toXML(original, noRef);
        const restored:Object = mapper.fromXML(xml, noRef);

        assertEquals(ObjectUtil.toString(original.toDictionary()), ObjectUtil.toString(restored.toDictionary()));
    }
}
}
