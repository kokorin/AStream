package ru.kokorin.astream {
import flash.utils.Dictionary;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertTrue;
import org.hamcrest.collection.arrayWithSize;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.valueobject.EnumVO;
import ru.kokorin.astream.valueobject.ExtVO;
import ru.kokorin.astream.valueobject.TestVO;

[RunWith("org.flexunit.runners.Parameterized")]
public class AStreamTest {
    private var aStream:AStream;

    [Before]
    public function setUp():void {
        aStream = new AStream();
    }

    [Test]
    public function testNull():void {
        assertEquals("aStream.toXML(null)", "<null/>", aStream.toXML(null).toXMLString());
        assertNull("aStream.fromXML(<null/>)", aStream.fromXML(XML("<null/>")));
    }

    [Test]
    public function testNullAlias():void {
        aStream.alias("NullAlias", null);
        assertEquals("aStream.toXML(null)", "<NullAlias/>", aStream.toXML(null).toXMLString());
        assertNull("aStream.fromXML(<null/>)", aStream.fromXML(XML("<NullAlias/>")));
    }

    [Test]
    public function testNumeric():void {
        const infoNaN:ClassInfo = ClassInfo.forInstance(Number.NaN);

        assertTrue("NaN", isNaN(NaN));
        assertTrue("NaN", isNaN(Number.NaN));

        assertTrue("NaN is Number", infoNaN.isType(Number));

        assertTrue("5 is int", 5 is int);
        assertTrue("5 is Number", 5 is Number);
        assertTrue("0.5 is Number", 0.5 is Number);

        assertTrue("ClassInfo.forInstance(5).isType(Number)", ClassInfo.forInstance(5).isType(Number));
        assertTrue("ClassInfo.forClass(int).isType(Number)", ClassInfo.forClass(int).isType(Number));
        assertTrue("ClassInfo.forClass(uint).isType(Number)", ClassInfo.forClass(uint).isType(Number));
        assertTrue("ClassInfo.forInstance(0.5).isType(Number)", ClassInfo.forInstance(0.5).isType(Number));
    }

    [Test]
    public function testAttribute():void {
        aStream.useAttributeFor(TestVO, "name");
        aStream.useAttributeFor(TestVO, "value1");
        aStream.useAttributeFor(TestVO, "value2");
        aStream.useAttributeFor(TestVO, "value3");

        const original:TestVO = new TestVO("Root");
        const xml:XML = aStream.toXML(original);
        const restored:TestVO = aStream.fromXML(xml) as TestVO;

        assertNotNull("Restored object from XML", restored);
        assertEquals("xml/@value1", String(original.name), String(xml.attribute("name")));
        assertEquals("xml/@value1", String(original.value1), String(xml.attribute("value1")));
        assertEquals("xml/@value2", String(original.value2), String(xml.attribute("value2")));
        assertEquals("xml/@value3", String(original.value3), String(xml.attribute("value3")));
        assertEquals("Restored and original", original.describe(), restored.describe());
    }

    public static var REFERENCE_MODES:Array = [
        [AStreamMode.ID_REFERENCES],
        [AStreamMode.SINGLE_NODE_XPATH_ABSOLUTE_REFERENCES],
        [AStreamMode.SINGLE_NODE_XPATH_RELATIVE_REFERENCES],
        [AStreamMode.XPATH_ABSOLUTE_REFERENCES],
        [AStreamMode.XPATH_RELATIVE_REFERENCES]
    ];

    [Test(dataProvider="REFERENCE_MODES")]
    public function testCircularReference(mode:AStreamMode):void {
        const original:TestVO = new TestVO("Root");
        original.children = [original];
        original.value4 = original;

        aStream.mode = mode;
        const xml:XML = aStream.toXML(original);
        const restored:TestVO = aStream.fromXML(xml) as TestVO;

        assertNotNull("Restored object from XML", restored);
        assertEquals("Restored contains self in value4", restored, restored.value4);
        assertEquals("Restored contains self in child array", restored, restored.children[0]);
    }

    [Test(dataProvider="REFERENCE_MODES")]
    public function testCollectionReference(mode:AStreamMode):void {
        const original:TestVO = new TestVO("Root");
        original.children = [new TestVO("First"), new TestVO("Second"), new TestVO("Third")];
        original.value4 = original.children;

        aStream.mode = mode;
        const xml:XML = aStream.toXML(original);
        const restored:TestVO = aStream.fromXML(xml) as TestVO;

        assertNotNull("Restored object from XML", restored);
        assertEquals("Restored.value4 equals Restored.children", restored.value4, restored.children);
        assertThat("Restored children length", restored.children, arrayWithSize(original.children.length));
    }

    [Test(dataProvider="REFERENCE_MODES")]
    public function testMapReference(mode:AStreamMode):void {
        const original:TestVO = new TestVO("Root");
        original.children = [new TestVO("First"), new TestVO("Second"), new TestVO("Third")];
        original.value4 = new Dictionary();
        original.value4[EnumVO.FIRST] = original.children[0];
        original.value4[EnumVO.SECOND] = original.children[1];
        original.value4[EnumVO.THIRD] = original.children[2];

        aStream.mode = mode;
        const xml:XML = aStream.toXML(original);
        const restored:TestVO = aStream.fromXML(xml) as TestVO;

        assertNotNull("Restored object from XML", restored);
        assertEquals(restored.value4[EnumVO.FIRST], restored.children[0]);
        assertEquals(restored.value4[EnumVO.SECOND], restored.children[1]);
        assertEquals(restored.value4[EnumVO.THIRD], restored.children[2]);
    }

    [Test(expects="Error")]
    public function testCircularReferenceError():void {
        const original:TestVO = new TestVO("Root");
        original.value4 = original;

        aStream.mode = AStreamMode.NO_REFERENCES;
        aStream.toXML(original);
    }

    [Test]
    public function testMultipleReferences():void {
        const original:TestVO = new TestVO("Root");
        original.children = [new TestVO("First"), new TestVO("Second"), new TestVO("Third")];
        original.value4 = original.children;

        aStream.mode = AStreamMode.NO_REFERENCES;
        const xml:XML = aStream.toXML(original);
        const restored:TestVO = aStream.fromXML(xml) as TestVO;

        assertNotNull("Restored object from XML", restored);
        assertEquals("Restored.value4 like Restored.children", String(restored.value4), String(restored.children));
        assertThat("Restored children length", restored.children, arrayWithSize(original.children.length));
    }

    [Test]
    public function testExplicitConverter():void {
        aStream.registerConverterForProperty(new ExplicitConverter(), TestVO, "testVO");
        const original:TestVO = new TestVO("Root");
        original.testVO = new ExtVO();
        const xml:XML = aStream.toXML(original);

        assertEquals("Explicit property converter should be used even for subtypes",
                "ExplicitConverter", String(xml.testVO));
    }

    [Test]
    public function testExplicitMapper():void {
        aStream.registerMapperForProperty(new ExplicitMapper(), TestVO, "testVO");
        const original:TestVO = new TestVO("Root");
        original.testVO = new ExtVO();
        const xml:XML = aStream.toXML(original);

        assertEquals("Explicit property mapper should be used even for subtypes",
                "ExplicitMapper", String(xml.testVO));
    }
}
}

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.converter.Converter;
import ru.kokorin.astream.mapper.Mapper;
import ru.kokorin.astream.ref.AStreamRef;

class ExplicitConverter implements Converter {

    public function fromString(string:String):Object {
        return null;
    }
    public function toString(value:Object):String {
        return "ExplicitConverter";
    }
}

class ExplicitMapper implements Mapper {

    public function toXML(instance:Object, ref:AStreamRef, nodeName:String = null):XML {
        return <{nodeName}>ExplicitMapper</{nodeName}>;
    }

    public function fromXML(xml:XML, ref:AStreamRef):Object {
        return null;
    }

    public function get registry():AStreamRegistry {
        return null;
    }

    public function set registry(value:AStreamRegistry):void {
    }

    public function reset():void {
    }
}
