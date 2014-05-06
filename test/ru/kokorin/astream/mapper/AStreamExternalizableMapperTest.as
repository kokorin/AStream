package ru.kokorin.astream.mapper {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.AStreamNoDeref;
import ru.kokorin.astream.ref.AStreamNoRef;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.valueobject.ExtVO;

public class AStreamExternalizableMapperTest {
    private const registry:AStreamRegistry = new AStreamRegistry();
    private const noRef:AStreamRef = new AStreamNoRef();
    private const noDeref:AStreamDeref = new AStreamNoDeref();

    [Test]
    public function test():void {
        const original:ExtVO = new ExtVO("Root");
        const complexMapper:AStreamExternalizableMapper = new AStreamExternalizableMapper(ClassInfo.forClass(ExtVO), registry);
        const xml:XML = complexMapper.toXML(original, noRef);
        const restored:ExtVO = complexMapper.fromXML(xml, noDeref) as ExtVO;

        assertNotNull("Restored complex object", restored);
        assertEquals("Restored complex object", original.describe(), restored.describe());
    }
}
}
