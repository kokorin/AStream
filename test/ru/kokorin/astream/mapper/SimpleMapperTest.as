package ru.kokorin.astream.mapper {
import org.flexunit.assertThat;
import org.flexunit.asserts.assertEquals;
import org.hamcrest.number.closeTo;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.valueobject.EnumVO;

[RunWith("org.flexunit.runners.Parameterized")]
public class SimpleMapperTest {
    public static var TYPE_VALUE_PAIRS:Array = [
        [Number, 5],
        [Number, 2.5],
        [String, "The quick brown fox jumps over the lazy dog"],
        [Boolean, false],
        [Boolean, true],
        [int, -123],
        [uint, 321],
        [EnumVO, EnumVO.FIRST]
    ];

    private const registry:AStreamRegistry = new AStreamRegistry();

    [Test(dataProvider="TYPE_VALUE_PAIRS")]
    public function test(type:Class, value:Object):void {
        const info:ClassInfo = ClassInfo.forClass(type);
        const simpleMapper:SimpleMapper = new SimpleMapper(info, registry);
        const xml:XML = simpleMapper.toXML(value, null);
        const restored:Object = simpleMapper.fromXML(xml, null);

        assertEquals("Restored value", value, restored);
    }

    [Test]
    public function testDate():void {
        const info:ClassInfo = ClassInfo.forClass(Date);
        const value:Date = new Date();
        const simpleMapper:SimpleMapper = new SimpleMapper(info, registry);
        const xml:XML = simpleMapper.toXML(value, null);
        const restored:Date = simpleMapper.fromXML(xml, null) as Date;

        assertThat("Restored Date.time", value.time, closeTo(restored.time, 1000));
    }

    public static var ESCAPE_PAIRS:Array = [
        ["&", "&amp;"],
        //["\"", "&quot;"], NOT escaped in AS3 XML
        //["'", "&apos;"],  NOT escaped in AS3 XML
        ["<", "&lt;"],
        [">", "&gt;"]
    ];
    [Test(dataProvider="ESCAPE_PAIRS")]
    public function testEscape(value:String, xmlText:String):void {
        const info:ClassInfo = ClassInfo.forClass(String);
        const simpleMapper:SimpleMapper = new SimpleMapper(info, registry);
        const xml:XML = simpleMapper.toXML(value, null);
        const restored:String = simpleMapper.fromXML(xml, null) as String;

        assertEquals("Restored String", value, restored);
        assertEquals("Escaped in XML", "<String>"+xmlText+"</String>", xml.toXMLString());
    }
}
}
