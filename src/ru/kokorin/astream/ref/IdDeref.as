package ru.kokorin.astream.ref {
public class IdDeref extends BaseDeref {
    override protected function getValueRef(xml:XML):String {
        return String(xml.attribute("id"));
    }
}
}
