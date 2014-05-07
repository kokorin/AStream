package ru.kokorin.astream.ref {
public class IdRef extends BaseRef {
    private var nextId:int = 1;

    override public function clear():void {
        super.clear();
        nextId = 1;
    }

    override protected function getValueRef(xml:XML):String {
        const ref:int = nextId++;
        xml.attribute("id")[0] = String(ref);
        return String(ref);
    }
}
}
