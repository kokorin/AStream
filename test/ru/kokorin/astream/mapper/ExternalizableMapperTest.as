package ru.kokorin.astream.mapper {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.ref.NoRef;
import ru.kokorin.astream.valueobject.EnumVO;
import ru.kokorin.astream.valueobject.ExtVO;
import ru.kokorin.astream.valueobject.TestVO;

public class ExternalizableMapperTest {
    private const registry:AStreamRegistry = new AStreamRegistry();
    private const noRef:AStreamRef = new NoRef();

    [Test]
    public function test():void {
        const original:ExtVO = new ExtVO("Root");
        original.enum = EnumVO.SECOND;
        original.value1 = 2.2;
        original.value2 = int.MAX_VALUE;
        original.value3 = 0xABCDEF;
        original.value4 = null;
        original.testVO = new TestVO("Child");

        const complexMapper:ExternalizableMapper = new ExternalizableMapper(ClassInfo.forClass(ExtVO));
        complexMapper.registry = registry;
        const xml:XML = complexMapper.toXML(original, noRef);
        const restored:ExtVO = complexMapper.fromXML(xml, noRef) as ExtVO;

        assertNotNull("Restored complex object", restored);
        assertEquals("Restored complex object", original.describe(), restored.describe());
    }
}
}
