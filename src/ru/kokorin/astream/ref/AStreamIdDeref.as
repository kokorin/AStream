package ru.kokorin.astream.ref {
public class AStreamIdDeref extends AStreamBaseDeref {
    override protected function getValueRef(xml:XML):String {
        return String(xml.attribute("id"));
    }
}
}
