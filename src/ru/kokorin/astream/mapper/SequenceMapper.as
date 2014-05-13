package ru.kokorin.astream.mapper {
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.util.TypeUtil;

public class SequenceMapper extends BaseMapper {
    public function SequenceMapper(classInfo:ClassInfo, registry:AStreamRegistry) {
        super(classInfo, registry);
    }

    override protected function fillObject(instance:Object, xml:XML, deref:AStreamRef):void {
        super.fillObject(instance, xml, deref);
        const sequence:Array = new Array();
        for each (var elementItemValue:XML in xml.children()) {
            var itemValueMapper:AStreamMapper = registry.getMapper(elementItemValue.localName());
            var itemValue:Object = itemValueMapper.fromXML(elementItemValue, deref);
            sequence.push(itemValue);
        }
        setSequence(instance, sequence);
    }

    override protected function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
        super.fillXML(instance, xml, ref);
        const sequence:Object = getSequence(instance);
        //Use forEachInCollection() loop wrapper because ArrayList doesn't support for each() loop
        TypeUtil.forEachInCollection(sequence,
                function (itemValue:Object, i:int, collection:Object):void {
                    var itemValueType:ClassInfo;
                    if (itemValue != null) {
                        itemValueType = ClassInfo.forInstance(itemValue);
                    }
                    const itemValueMapper:AStreamMapper = registry.getMapper(itemValueType);
                    const itemResult:XML = itemValueMapper.toXML(itemValue, ref);
                    xml.appendChild(itemResult);
                }
        );
    }

    protected function setSequence(instance:Object, sequence:Array):void {

    }
    protected function getSequence(instance:Object):Object {
        return null;
    }
}
}
