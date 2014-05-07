package ru.kokorin.astream.mapper {

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class MapperSuite {
    public var nullMapper:NullMapperTest;
    public var simpleMapper:SimpleMapperTest;
    public var byteArrayMapper:ByteArrayMapperTest;
    public var collectionMapper:CollectionMapperTest;
    public var externalizableMapper:ExternalizableMapperTest;
    public var complexMapperTest:ComplexMapperTest;
}
}
