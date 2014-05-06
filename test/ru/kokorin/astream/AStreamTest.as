package ru.kokorin.astream {
import org.flexunit.assertThat;
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.hamcrest.collection.arrayWithSize;

import ru.kokorin.astream.valueobject.TestVO;

public class AStreamTest {
    private var aStream:AStream;

    [Before]
    public function setUp():void {
        aStream = new AStream();
    }

    [Test]
    public function testNull() {
        assertEquals("aStream.toXML(null)", "<null/>", aStream.toXML(null).toXMLString());
        assertNull("aStream.fromXML(<null/>)", aStream.fromXML(XML("<null/>")));
    }

    [Test]
    public function testSingleReference():void {
        const original:TestVO = new TestVO("Root");
        original.children = [original];
        original.value4 = original;

        const xml:XML = aStream.toXML(original);
        const restored:TestVO = aStream.fromXML(xml) as TestVO;

        assertNotNull("Restored object from XML", restored);
        assertEquals("Restored contains self in child array", restored, restored.children[0]);
        assertEquals("Restored contains self in value4", restored, restored.value4);
    }

    [Test]
    public function testCollectionReference():void {
        const original:TestVO = new TestVO("Root");
        original.children = [new TestVO("First"), new TestVO("Second"), new TestVO("Third")];
        original.value4 = original.children;

        const xml:XML = aStream.toXML(original);
        const restored:TestVO = aStream.fromXML(xml) as TestVO;

        assertNotNull("Restored object from XML", restored);
        assertEquals("Restored.value4 equals Restored.children", restored.value4, restored.children);
        assertThat("Restored children length", restored.children, arrayWithSize(original.children.length));
    }
}
}
