package ru.kokorin.astream.ref {
import ru.kokorin.astream.util.XmlUtil;

public class XPathAbsoluteRef extends BaseRef {
    private var forceSingleNode:Boolean;

    public function XPathAbsoluteRef(forceSingleNode:Boolean) {
        this.forceSingleNode = forceSingleNode;
    }

    override protected function getValueRef(xml:XML):String {
        return XmlUtil.getXPath(xml, forceSingleNode);
    }
}
}
