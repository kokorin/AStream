package ru.kokorin.astream.ref {
import ru.kokorin.astream.util.XmlUtil;

public class XPathRelativeDeref extends BaseDeref {
    private var forceSingleNode:Boolean;

    public function XPathRelativeDeref(forceSingleNode:Boolean) {
        this.forceSingleNode = forceSingleNode;
    }

    override public function getValue(ref:String, atNode:XML):Object {
        const basePath:String = getValueRef(atNode);
        ref = XmlUtil.getAbsoluteXPath(basePath, ref);
        return super.getValue(ref, atNode);
    }

    override protected function getValueRef(xml:XML):String {
        return XmlUtil.getXPath(xml, forceSingleNode);
    }
}
}
