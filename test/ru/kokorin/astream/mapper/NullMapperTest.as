package ru.kokorin.astream.mapper {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNull;

public class NullMapperTest {
    private static const nullMapper:NullMapper = new NullMapper();

    [Test]
    public function testToXML():void {
        const xml:XML = nullMapper.toXML(null, null);
        assertEquals("NULL mapper toXML", "<null/>", xml.toXMLString());
    }

    [Test]
    public function testFromXML():void {
        assertNull("NULL mapper fromXML", nullMapper.fromXML(null, null));
    }
}
}
