package ru.kokorin.astream.mapper {
import com.sociodox.utils.Base64;

import flash.utils.ByteArray;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;

public class ByteArrayMapperTest {
    private var byteArrayMapper:ByteArrayMapper;

    [Before]
    public function setUp():void {
        const registry:AStreamRegistry = new AStreamRegistry();
        byteArrayMapper = new ByteArrayMapper(ClassInfo.forClass(ByteArray), registry);
    }

    private static const TEXT:String = "The quick brown fox jumps over the lazy dog";
    private static const ENCODED:String = "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZw==";

    [Test]
    public function testBase64():void {
        const bytes:ByteArray = new ByteArray();
        bytes.writeUTFBytes(TEXT);
        const encoded:String = Base64.encode(bytes);
        const decoded:ByteArray = Base64.decode(ENCODED);
        const text:String = String(decoded);

        assertEquals("Encoded text doesn't match standard value", encoded, ENCODED);
        assertEquals("Decoded value doesn't match original text", text, TEXT);
    }

    [Test]
    public function test():void {
        const bytes:ByteArray = new ByteArray();
        bytes.writeUTFBytes(TEXT);
        const xml:XML = byteArrayMapper.toXML(bytes, null);
        const restored:ByteArray = byteArrayMapper.fromXML(xml, null) as ByteArray;

        assertEquals("Wrong Base64 encoding", String(xml), ENCODED);
        assertNotNull("Failed to restore ByteArray", restored);
        assertEquals("Wrong Base64 decoding", String(restored), TEXT);
    }
}
}
