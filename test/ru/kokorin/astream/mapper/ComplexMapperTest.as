package ru.kokorin.astream.mapper {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.NoDeref;
import ru.kokorin.astream.ref.NoRef;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.valueobject.EnumVO;
import ru.kokorin.astream.valueobject.TestVO;
import ru.kokorin.astream.valueobject.TestVO;

public class ComplexMapperTest {
    private const registry:AStreamRegistry = new AStreamRegistry();
    private const noRef:AStreamRef = new NoRef();
    private const noDeref:AStreamDeref = new NoDeref();

    [Test]
    public function test():void {
        const original:TestVO = new TestVO("Root");
        original.enum = EnumVO.SECOND;
        original.value1 = 2.2;
        original.value2 = int.MAX_VALUE;
        original.value3 = 0xABCDEF;
        original.value4 = null;

        const complexMapper:ComplexMapper = new ComplexMapper(ClassInfo.forClass(TestVO), registry);
        const xml:XML = complexMapper.toXML(original, noRef);
        const restored:TestVO = complexMapper.fromXML(xml, noDeref) as TestVO;

        assertNotNull("Restored complex object", restored);
        assertEquals("Restored complex object", original.describe(), restored.describe());
    }
}
}
