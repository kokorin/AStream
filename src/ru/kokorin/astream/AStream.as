package ru.kokorin.astream {
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.mapper.AStreamMapper;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.ref.NoRef;
import ru.kokorin.astream.ref.XPathRef;

public class AStream {
    private var ref:AStreamRef;
    private var needReset:Boolean = false;
    private const registry:AStreamRegistry = new AStreamRegistry();

    public function AStream() {
        mode = AStreamMode.XPATH_RELATIVE_REFERENCES;
    }

    public function set mode(value:AStreamMode):void {
        switch (value) {
            case AStreamMode.NO_REFERENCES: {
                ref = new NoRef();
                break;
            }
            case AStreamMode.ID_REFERENCES:
            case AStreamMode.SINGLE_NODE_XPATH_ABSOLUTE_REFERENCES: {
                ref = new XPathRef(true, false);
                break;
            }
            case AStreamMode.SINGLE_NODE_XPATH_RELATIVE_REFERENCES:{
                ref = new XPathRef(true, true);
                break;
            }
            case AStreamMode.XPATH_ABSOLUTE_REFERENCES: {
                ref = new XPathRef(false, false);
                break;
            }
            case AStreamMode.XPATH_RELATIVE_REFERENCES:
            default: {
                ref = new XPathRef(false, true);
                break;
            }
        }
    }

    public function processMetadata(clazz:Class):void {
        const classInfo:ClassInfo = ClassInfo.forClass(clazz);
        registry.processMetadata(classInfo);
        needReset = true;
    }

    public function alias(name:String, clazz:Class):void {
        registry.alias(name, ClassInfo.forClass(clazz));
        needReset = true;
    }

    public function aliasProperty(name:String, clazz:Class, propertyName:String):void {
        registry.aliasProperty(name, ClassInfo.forClass(clazz), propertyName);
        needReset = true;
    }

    public function useAttributeFor(clazz:Class, propertyName:String):void {
        registry.attribute(ClassInfo.forClass(clazz), propertyName);
        needReset = true;
    }

    public function aliasPackage(name:String, pckg:String):void {
        registry.aliasPackage(name, pckg);
        needReset = true;
    }

    public function implicitCollection(clazz:Class, propertyName:String, itemName:String, itemClazz:Class):void {
        registry.implicitCollection(ClassInfo.forClass(clazz), propertyName, itemName, ClassInfo.forClass(itemClazz));
        needReset = true;
    }

    public function autodetectMetadata(value:Boolean):void {
        registry.autodetectMetadata(value);
    }

    public function toXML(object:Object):XML {
        reset();
        var classInfo:ClassInfo = null;
        if (object != null) {
            classInfo = ClassInfo.forInstance(object);
        }
        const mapper:AStreamMapper = registry.getMapper(classInfo);
        try {
            return mapper.toXML(object, ref);
        } finally {
            ref.clear();
        }
        return null;
    }

    public function fromXML(xml:XML):Object {
        reset();
        const mapper:AStreamMapper = registry.getMapper(xml.localName());
        try {
            return mapper.fromXML(xml, ref);
        } finally {
            ref.clear();
        }
        return null;
    }

    private function reset():void {
        if (!needReset) {
            return;
        }
        registry.resetMappers();
        needReset = false;
    }
}
}
