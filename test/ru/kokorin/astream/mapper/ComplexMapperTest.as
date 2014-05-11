package ru.kokorin.astream.mapper {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.ref.NoDeref;
import ru.kokorin.astream.ref.NoRef;
import ru.kokorin.astream.valueobject.EnumVO;
import ru.kokorin.astream.valueobject.TestVO;

public class ComplexMapperTest {
    private var registry:AStreamRegistry;
    private var noRef:AStreamRef;
    private var noDeref:AStreamDeref;
    private var original:TestVO;

    [Before]
    public function setUp():void {
        registry = new AStreamRegistry();
        noRef = new NoRef();
        noDeref = new NoDeref();

        original = new TestVO("Root");
        original.enum = EnumVO.SECOND;
        original.value1 = 2.2;
        original.value2 = int.MAX_VALUE;
        original.value3 = 0xABCDEF;
        original.value4 = null;
    }

    [Test]
    public function test():void {
        const complexMapper:ComplexMapper = new ComplexMapper(ClassInfo.forClass(TestVO), registry);
        const xml:XML = complexMapper.toXML(original, noRef);
        const restored:TestVO = complexMapper.fromXML(xml, noDeref) as TestVO;

        assertNotNull("Restored complex object", restored);
        assertEquals("Restored complex object", original.describe(), restored.describe());
    }


    [Test]
    public function testImplicitCollection():void {
        const testInfo:ClassInfo = ClassInfo.forClass(TestVO)
        registry.implicitCollection(testInfo, "children", "child", testInfo);
        original.children = [new TestVO("First"), new TestVO("Second"), new TestVO("Third")]
        const complexMapper:ComplexMapper = new ComplexMapper(testInfo, registry);

        const xml:XML = complexMapper.toXML(original, noRef);
        const restored:TestVO = complexMapper.fromXML(xml, noDeref) as TestVO;

        assertNotNull("Restored complex object", restored);
        assertEquals("Xml/child", original.children.length, xml.elements("child").length());
        assertEquals("Restored complex object", original.describe(), restored.describe());
    }
}
}
