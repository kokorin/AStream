package ru.kokorin.astream.valueobject {
[AStreamMapper("ru.kokorin.astream.converter.SomeMapper", params="class-level")]
public class MapperMetaVO {
    [AStreamMapper("ru.kokorin.astream.converter.SomeMapper", params="field-level")]
    public var field:Object;

    public function MapperMetaVO() {
    }
}
}
