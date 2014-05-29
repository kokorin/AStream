package ru.kokorin.astream.mapper {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
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
        complexMapper = new ComplexMapper(TEST_VO, registry);

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

    [Test(expects="Error")]
    public function testNullInImplicitCollection():void {
        registry.implicitCollection(TEST_VO, "children", "child", TEST_VO);
        original.children = [new TestVO("First"), null, new TestVO("Third")];

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
        registry.implicitCollection(TEST_VO, "children", "child", TEST_VO);

        complexMapper.toXML(original, noRef);
    }


    [Test]
    public function testReset():void {
        original.children = [new TestVO("First"), new TestVO("Second"), new TestVO("Third")];
        const xmlBeforeAlias:XML = complexMapper.toXML(original, noRef);
        noRef.clear();

        registry.alias("test", TEST_VO);
        registry.implicitCollection(TEST_VO, "children", "child", TEST_VO);
        const xmlAfterAlias:XML = complexMapper.toXML(original, noRef);
        noRef.clear();

        complexMapper.reset();
        const xmlAfterReset:XML = complexMapper.toXML(original, noRef);

        assertEquals("Before alias and after", xmlBeforeAlias.toXMLString(), xmlAfterAlias.toXMLString());
        assertTrue("After alias still NO 'child' property", xmlAfterAlias.elements("child")[0] === undefined);
        assertTrue("After reset we do have 'child' property", xmlAfterReset.elements("child")[0] !== undefined);
    }
}
}
