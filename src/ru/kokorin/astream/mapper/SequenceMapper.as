package ru.kokorin.astream.mapper {
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.util.TypeUtil;

public class SequenceMapper implements AStreamMapper {
    private var classInfo:ClassInfo;
    private var registry:AStreamRegistry;

    public function SequenceMapper(classInfo:ClassInfo, registry:AStreamRegistry) {
        this.classInfo = classInfo;
        this.registry = registry;
    }

    public function toXML(instance:Object, ref:AStreamRef):XML {
        const name:String = registry.getAlias(classInfo);
        const result:XML = <{name}/>;
        fillXML(instance, result, ref);
        return result;
    }

    public function fromXML(xml:XML, deref:AStreamDeref):Object {
        const attRef:XML = xml.attribute("reference")[0];
        if (attRef) {
            return deref.getValue(String(attRef), xml);
        }
        const result:Object = classInfo.newInstance([]);
        deref.addRef(result, xml);
        const sequence:Array = new Array();
        for each (var elementItemValue:XML in xml.children()) {
            var itemValueMapper:AStreamMapper = registry.getMapperForName(elementItemValue.name());
            var itemValue:Object = itemValueMapper.fromXML(elementItemValue, deref);
            sequence.push(itemValue);
        }
        setSequence(result, sequence);
        return result;
    }

    public function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
        if (ref.hasRef(instance)) {
            xml.attribute("reference")[0] = String(ref.getRef(instance, xml));
            return;
        }
        ref.addValue(instance, xml);
        const sequence:Object = getSequence(instance);

        //Use forEachInCollection() loop wrapper because ArrayList doesn't support for each() loop
        TypeUtil.forEachInCollection(sequence,
                function (itemValue:Object, i:int, collection:Object):void {
                    var itemValueType:ClassInfo;
                    if (itemValue != null) {
                        itemValueType = ClassInfo.forInstance(itemValue);
                    }
                    /* We have to add child tag to XML and only then fil that tag.
                    * Otherwise relative XPath cannot be constructed properly. */
                    const itemValueMapper:AStreamMapper = registry.getMapperForClass(itemValueType);
                    const itemName:String = registry.getAlias(itemValueType);
                    const itemResult:XML = <{itemName}/>;
                    xml.appendChild(itemResult);

                    itemValueMapper.fillXML(itemValue, itemResult, ref);
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
