package ru.kokorin.astream {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertTrue;
import org.spicefactory.lib.reflect.ClassInfo;

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
        assertEquals("Property Alias", registry.getAliasProperty(metaInfo, "name"), "AliasName");

        assertEquals("Implicit list's item name", registry.getImplicitItemName(metaInfo, "list"), "listItem");
        assertEquals("Implicit list's item type", registry.getImplicitItemType(metaInfo, "list").getClass(), String);
        assertEquals("Implicit vector's item name", registry.getImplicitItemName(metaInfo, "vector"), "vectorItem");
        assertEquals("Implicit vector's item type", registry.getImplicitItemType(metaInfo, "vector").getClass(), String);

        assertEquals("Property order (name)", registry.getOrder(metaInfo, "name"), 10);
        assertEquals("Property order (list)", registry.getOrder(metaInfo, "list"), 20);
        assertEquals("Property order (vector)", registry.getOrder(metaInfo, "vector"), 30);
    }
}
}
