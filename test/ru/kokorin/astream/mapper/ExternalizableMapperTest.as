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
import ru.kokorin.astream.valueobject.ExtVO;

public class ExternalizableMapperTest {
    private const registry:AStreamRegistry = new AStreamRegistry();
    private const noRef:AStreamRef = new NoRef();
    private const noDeref:AStreamDeref = new NoDeref();

    [Test]
    public function test():void {
        const original:ExtVO = new ExtVO("Root");
        original.enum = EnumVO.SECOND;
        original.value1 = 2.2;
        original.value2 = int.MAX_VALUE;
        original.value3 = 0xABCDEF;
        original.value4 = null;

        const complexMapper:ExternalizableMapper = new ExternalizableMapper(ClassInfo.forClass(ExtVO), registry);
        const xml:XML = complexMapper.toXML(original, noRef);
        const restored:ExtVO = complexMapper.fromXML(xml, noDeref) as ExtVO;

        assertNotNull("Restored complex object", restored);
        assertEquals("Restored complex object", original.describe(), restored.describe());
    }
}
}
