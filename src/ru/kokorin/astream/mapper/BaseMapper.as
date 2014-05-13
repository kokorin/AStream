package ru.kokorin.astream.mapper {
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;
import ru.kokorin.astream.ref.AStreamRef;

public class BaseMapper implements AStreamMapper {
    private var _classInfo:ClassInfo;
    private var _registry:AStreamRegistry;
    private var nodeName:String;

    public function BaseMapper(classInfo:ClassInfo, registry:AStreamRegistry) {
        this._classInfo = classInfo;
        this._registry = registry;
        reset();
    }

    public final function toXML(instance:Object, ref:AStreamRef, nodeName:String = null):XML {
        if (nodeName == null) {
            nodeName = this.nodeName;
        }
        const result:XML = <{nodeName}/>;

        ref.beginNode(nodeName);
        if (ref.hasRef(instance)) {
            result.attribute("reference")[0] = ref.getRef(instance);
        } else if (instance!= null && classInfo != null) {
            fillXML(instance, result, ref);
        }
        ref.endNode();

        return result;
    }

    public final function fromXML(xml:XML, ref:AStreamRef):Object {
        var result:Object = null;

        ref.beginNode(xml.localName());
        const attRef:XML = xml.attribute("reference")[0];
        if (attRef) {
            result = ref.getValue(String(attRef));
        } else if (xml!= null && classInfo != null) {
            result = classInfo.newInstance([]);
            fillObject(result, xml, ref);
        }
        ref.endNode();

        return result;
    }

    protected function fillXML(instance:Object, xml:XML, ref:AStreamRef):void {
        ref.addValue(instance);
    }

    protected function fillObject(instance:Object, xml:XML, ref:AStreamRef):void {
        ref.addValue(instance);
    }

    public function get classInfo():ClassInfo {
        return _classInfo;
    }

    protected function get registry():AStreamRegistry {
        return _registry;
    }

    public function reset():void {
        nodeName = registry.getAlias(classInfo);
    }
}
}
