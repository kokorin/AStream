package ru.kokorin.astream.mapper {
import org.flexunit.assertThat;
import org.flexunit.asserts.assertEquals;
import org.hamcrest.number.closeTo;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;

[RunWith("org.flexunit.runners.Parameterized")]
public class AStreamSimpleMapperTest {
    public static var TYPE_VALUE_PAIRS:Array = [
        [Number, 5],
        [Number, 2.5],
        [String, "Quot \" Apos \' amp & lt < gt > Me!"],
        [Boolean, false],
        [Boolean, true],
        [int, -123],
        [uint, 321]
    ];

    private const registry:AStreamRegistry = new AStreamRegistry();

    [Test(dataProvider="TYPE_VALUE_PAIRS")]
    public function test(type:Class, value:Object):void {
        const info:ClassInfo = ClassInfo.forClass(type);
        const simpleMapper:AStreamSimpleMapper = new AStreamSimpleMapper(info, registry);
        const xml:XML = simpleMapper.toXML(value, null);
        const restored:Object = simpleMapper.fromXML(xml, null);

        assertEquals("Restored value", value, restored);
    }

    [Test]
    public function testDate():void {
        const info:ClassInfo = ClassInfo.forClass(Date);
        const value:Date = new Date();
        const simpleMapper:AStreamSimpleMapper = new AStreamSimpleMapper(info, registry);
        const xml:XML = simpleMapper.toXML(value, null);
        const restored:Date = simpleMapper.fromXML(xml, null) as Date;

        assertThat("Restored Date.time", value.time, closeTo(restored.time, 1000));
    }
}
}
