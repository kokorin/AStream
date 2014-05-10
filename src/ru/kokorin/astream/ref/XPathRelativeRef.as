package ru.kokorin.astream.ref {
import ru.kokorin.astream.util.XmlUtil;

public class XPathRelativeRef extends BaseRef {
    private var forceSingleNode:Boolean;

    public function XPathRelativeRef(forceSingleNode:Boolean) {
        this.forceSingleNode = forceSingleNode;
    }

    override public function getRef(toValue:Object, fromNode:XML):String {
        const toPath:String = super.getRef(toValue, fromNode);
        const fromPath:String = getValueRef(fromNode);
        return XmlUtil.getRelativeXPath(toPath, fromPath);
    }

    override protected function getValueRef(xml:XML):String {
        return XmlUtil.getXPath(xml, forceSingleNode);
    }
}
}
