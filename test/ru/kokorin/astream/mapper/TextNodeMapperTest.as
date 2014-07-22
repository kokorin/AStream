package ru.kokorin.astream.mapper {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.ref.NoRef;
import ru.kokorin.astream.valueobject.TextVO;

public class TextNodeMapperTest {
    [Test]
    public function test():void {
        const TEXT_VO:ClassInfo = ClassInfo.forClass(TextVO);
        const registry:AStreamRegistry = new AStreamRegistry();
        const mapper:TextNodeMapper = new TextNodeMapper(TEXT_VO, "text");
        mapper.registry = registry;
        const ref:AStreamRef = new NoRef();

        const original:TextVO = new TextVO();
        original.id = 10;
        original.text = "Brown fox";
        const xml:XML = mapper.toXML(original, ref);
        const restored:TextVO = mapper.fromXML(xml, ref) as TextVO;

        assertEquals("attribute node", original.id, String(xml.@id));
        assertEquals("text node", original.text, String(xml.text()));
        assertNotNull("Restored object", restored);
        assertEquals("attribute node restored", original.id, restored.id);
        assertEquals("text node restored", original.text, restored.text);
    }
}
}
