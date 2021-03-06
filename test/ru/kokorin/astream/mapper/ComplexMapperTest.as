package ru.kokorin.astream.mapper {
import flash.geom.Point;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.converter.DateConverter;
import ru.kokorin.astream.converter.PointConverter;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.ref.NoRef;
import ru.kokorin.astream.valueobject.EnumVO;
import ru.kokorin.astream.valueobject.TestVO;

public class ComplexMapperTest {
    private var registry:AStreamRegistry;
    private var noRef:AStreamRef;
    private var complexMapper:ComplexMapper;
    private var original:TestVO;
    private static const TEST_VO:ClassInfo = ClassInfo.forClass(TestVO);

    [Before]
    public function setUp():void {
        registry = new AStreamRegistry();
        noRef = new NoRef();
        complexMapper = new ComplexMapper(TEST_VO);
        complexMapper.registry = registry;

        original = new TestVO("Root");
        original.enum = EnumVO.SECOND;
        original.value1 = 2.2;
        original.value2 = int.MAX_VALUE;
        original.value3 = 0xABCDEF;
        original.value4 = null;
    }

    [Test]
    public function test():void {
        const xml:XML = complexMapper.toXML(original, noRef);
        const restored:TestVO = complexMapper.fromXML(xml, noRef) as TestVO;

        assertNotNull("Restored complex object", restored);
        assertEquals("Restored complex object", original.describe(), restored.describe());
    }

    [Test]
    public function testImplicit():void {
        registry.implicit(TEST_VO, "children", "child", TEST_VO, null);
        registry.implicit(TEST_VO, "value4", "mapValue", TEST_VO, "name");

        original.children = [new TestVO("First"), new TestVO("Second"), new TestVO("Third")];
        original.value4 = {"First":new TestVO("First"), "Second":new TestVO("Second"), "Third":new TestVO("Third")};

        const xml:XML = complexMapper.toXML(original, noRef);
        const restored:TestVO = complexMapper.fromXML(xml, noRef) as TestVO;

        for (var i:int = 0; i < original.children.length; i++) {
            var originalChild:TestVO = original.children[i] as TestVO;
            var restoredChild:TestVO = restored.children[i] as TestVO;
            assertEquals("Restored and original child", originalChild.describe(), restoredChild.describe());
        }

        for (var key:Object in original.value4) {
            var originalValue:TestVO = original.value4[key] as TestVO;
            var restoredValue:TestVO = restored.value4[key] as TestVO;
            assertEquals("Restored and original child", originalValue.describe(), restoredValue.describe());
        }
    }

    [Test(expects="Error")]
    public function testNullInImplicitCollection():void {
        registry.implicit(TEST_VO, "children", "child", TEST_VO, null);
        original.children = [new TestVO("First"), null, new TestVO("Third")];

        complexMapper.toXML(original, noRef);
    }

    [Test(expects="Error")]
    public function testNullInImplicitMap():void {
        registry.implicit(TEST_VO, "value4", "mapValue", TEST_VO, "name");
        original.value4 = {"First":new TestVO("First"), "Second":null, "Third":new TestVO("Third")};

        complexMapper.toXML(original, noRef);
    }

    [Test(expects="Error")]
    public function testAmbiguousAttributes():void {
        registry.attribute(TEST_VO, "value1");
        registry.attribute(TEST_VO, "value2");
        registry.aliasProperty("value1", TEST_VO, "value2");

        complexMapper.toXML(original, noRef);
    }

    [Test(expects="Error")]
    public function testAmbiguousElements():void {
        registry.aliasProperty("child", TEST_VO, "value1");
        registry.implicit(TEST_VO, "children", "child", TEST_VO, null);

        complexMapper.toXML(original, noRef);
    }

    [Test]
    public function testReset():void {
        original.children = [new TestVO("First"), new TestVO("Second"), new TestVO("Third")];
        const xmlBefore:XML = complexMapper.toXML(original, noRef);

        registry.alias("test", TEST_VO);
        registry.implicit(TEST_VO, "children", "child", TEST_VO, null);
        noRef.clear();
        complexMapper.reset();

        const xmlAfter:XML = complexMapper.toXML(original, noRef);

        assertEquals("Before alias name", "ru.kokorin.astream.valueobject.TestVO", String(xmlBefore.name()));
        assertEquals("After alias name", "test", String(xmlAfter.name()));
        assertTrue("Before reset we have NO 'child' property", xmlBefore.elements("child")[0] === undefined);
        assertTrue("After reset we do have 'child' property", xmlAfter.elements("child")[0] !== undefined);
    }

    [Test]
    public function testConverter():void {
        registry.attribute(TEST_VO, "date");
        registry.registerConverterForProperty(new DateConverter("yyyy-MM-dd"), TEST_VO, "date");
        registry.registerConverterForProperty(new DateConverter("yyyy-MM-dd"), TEST_VO, "date2");
        original.date = original.date2 = new Date(2013, 10, 13, 0, 0, 0, 0);
        original.value4 = new Date(2013, 10, 13, 14, 30, 10, 20);

        const xml:XML = complexMapper.toXML(original, noRef);
        const restored:TestVO = complexMapper.fromXML(xml, noRef) as TestVO;

        assertEquals("Date in XML attribute", "2013-11-13", String(xml.@date));
        assertEquals("Date in XML element", "2013-11-13", String(xml.date2));
        assertEquals("Date", String(original.date), String(restored.date));
        assertEquals("Date and time", String(original.value4), String(restored.value4));
    }

    [Test]
    public function testNotSimplePropertyAsAttribute():void {
        registry.registerConverterForProperty(new PointConverter(), TEST_VO, "point");
        registry.attribute(TEST_VO, "point");
        registry.attribute(TEST_VO, "point2");

        original.point = new Point(10, 10);
        original.point2 = new Point(-10, -10);

        const xml:XML = complexMapper.toXML(original, noRef);
        const restored:TestVO = complexMapper.fromXML(xml, noRef) as TestVO;

        assertEquals("Point in XML attribute", "10,10", String(xml.@point));
        assertEquals("Point as attribute", String(original.point), String(restored.point));
        assertEquals("Point as element", String(original.point2), String(restored.point2));
    }
}
}
