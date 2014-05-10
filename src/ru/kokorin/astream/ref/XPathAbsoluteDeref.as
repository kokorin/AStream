package ru.kokorin.astream.ref {
import ru.kokorin.astream.util.XmlUtil;

public class XPathAbsoluteDeref extends BaseDeref {
    private var forceSingleNode:Boolean;

    public function XPathAbsoluteDeref(forceSingleNode:Boolean) {
        this.forceSingleNode = forceSingleNode;
    }

    override protected function getValueRef(xml:XML):String {
        return XmlUtil.getXPath(xml, forceSingleNode);
    }
}
}
