package ru.kokorin.astream.valueobject {
[AStreamConverter("ru.kokorin.astream.converter.SomeConverter", params="class-level")]
public class ConverterMetaVO {
    [AStreamConverter("ru.kokorin.astream.converter.SomeConverter", params="field-level")]
    public var field:Object;

    public function ConverterMetaVO() {
    }
}
}
