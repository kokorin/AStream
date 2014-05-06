package ru.kokorin.astream.mapper {

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class MapperSuite {
    public var nullMapper:AStreamNullMapperTest;
    public var simpleMapper:AStreamSimpleMapperTest;
    public var byteArrayMapper:AStreamByteArrayMapperTest;
    public var collectionMapper:AStreamCollectionMapperTest;
    public var externalizableMapper:AStreamExternalizableMapperTest;
    public var complexMapperTest:AStreamComplexMapperTest;
}
}
