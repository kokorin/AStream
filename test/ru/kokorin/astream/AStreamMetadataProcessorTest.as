package ru.kokorin.astream {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.converter.SomeConverter;
import ru.kokorin.astream.converter.SomeMapper;
import ru.kokorin.astream.valueobject.ConverterMetaVO;
import ru.kokorin.astream.valueobject.MapperMetaVO;

import ru.kokorin.astream.valueobject.MetaVO;

public class AStreamMetadataProcessorTest {
    private var registry:AStreamRegistry;
    private var metadataProcessor:AStreamMetadataProcessor;

    [Before]
    public function setUp():void {
        registry = new AStreamRegistry();
        metadataProcessor = new AStreamMetadataProcessor(registry);
    }

    [Test]
    public function test():void {
        const metaInfo:ClassInfo = ClassInfo.forClass(MetaVO);
        metadataProcessor.processMetadata(metaInfo);

        assertTrue("Omit", registry.getOmit(metaInfo, "omit"));
        assertTrue("AsAttribute", registry.getAttribute(metaInfo, "attribute"));
        assertEquals("Class Alias", registry.getAlias(metaInfo), "AliasMetaVO");
        assertEquals("Property Alias", registry.getPropertyAlias(metaInfo, "name"), "AliasName");

        assertEquals("Implicit list's item name", registry.getImplicitItemName(metaInfo, "list"), "listItem");
        assertEquals("Implicit list's item type", registry.getImplicitItemType(metaInfo, "list").getClass(), String);
        assertEquals("Implicit list's item name", registry.getImplicitItemName(metaInfo, "list2"), "list2Item");
        assertEquals("Implicit list's item type", registry.getImplicitItemType(metaInfo, "list2").getClass(), String);
        assertEquals("Implicit vector's item name", registry.getImplicitItemName(metaInfo, "vector"), "vectorItem");
        assertEquals("Implicit vector's item type", registry.getImplicitItemType(metaInfo, "vector").getClass(), String);

        assertEquals("Property order (name)", registry.getOrder(metaInfo, "name"), 10);
        assertEquals("Property order (list)", registry.getOrder(metaInfo, "list"), 20);
        assertEquals("Property order (vector)", registry.getOrder(metaInfo, "vector"), 30);

        const someConverter:SomeConverter = registry.getConverterForProperty(metaInfo, "some") as SomeConverter;
        assertNotNull("Converter is set", someConverter);
        assertEquals("Converter param", "someParam", someConverter.param);
    }

    [Test]
    public function testConverterMetadata():void {
        const metaInfo:ClassInfo = ClassInfo.forClass(ConverterMetaVO);
        metadataProcessor.processMetadata(metaInfo);

        const classLevelConverter:SomeConverter = registry.getConverter(metaInfo) as SomeConverter;
        assertNotNull("Class-level converter is set", classLevelConverter);
        assertEquals("Class-level converter param", "class-level", classLevelConverter.param);

        const fieldLevelConverter:SomeConverter = registry.getConverterForProperty(metaInfo, "field") as SomeConverter;
        assertNotNull("Field-level converter is set", fieldLevelConverter);
        assertEquals("Field-level converter param", "field-level", fieldLevelConverter.param);
    }

    [Test]
    public function testMapperMetadata():void {
        const metaInfo:ClassInfo = ClassInfo.forClass(MapperMetaVO);
        metadataProcessor.processMetadata(metaInfo);

        const classLevelMapper:SomeMapper = registry.getMapper(metaInfo) as SomeMapper;
        assertNotNull("Class-level converter is set", classLevelMapper);
        assertEquals("Class-level converter param", "class-level", classLevelMapper.param);

        const fieldLevelMapper:SomeMapper = registry.getMapperForProperty(metaInfo, "field") as SomeMapper;
        assertNotNull("Field-level converter is set", fieldLevelMapper);
        assertEquals("Field-level converter param", "field-level", fieldLevelMapper.param);
    }
}
}
