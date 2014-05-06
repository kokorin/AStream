package ru.kokorin.astream.mapper {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.AStreamNoDeref;
import ru.kokorin.astream.ref.AStreamNoRef;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.valueobject.TestVO;
import ru.kokorin.astream.valueobject.TestVO;

public class AStreamComplexMapperTest {
    private const registry:AStreamRegistry = new AStreamRegistry();
    private const noRef:AStreamRef = new AStreamNoRef();
    private const noDeref:AStreamDeref = new AStreamNoDeref();

    [Test]
    public function test():void {
        const original:TestVO = new TestVO("Root");
        const complexMapper:AStreamComplexMapper = new AStreamComplexMapper(ClassInfo.forClass(TestVO), registry);
        const xml:XML = complexMapper.toXML(original, noRef);
        const restored:TestVO = complexMapper.fromXML(xml, noDeref) as TestVO;

        assertNotNull("Restored complex object", restored);
        assertEquals("Restored complex object", original.describe(), restored.describe());
    }
}
}
