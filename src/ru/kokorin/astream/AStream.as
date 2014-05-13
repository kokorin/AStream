package ru.kokorin.astream {
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.mapper.AStreamMapper;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.ref.XPathRef;

public class AStream {
    private var ref:AStreamRef;
    private const registry:AStreamRegistry = new AStreamRegistry();

    public function AStream() {
        mode = AStreamMode.XPATH_RELATIVE_REFERENCES;
    }

    public function set mode(value:AStreamMode):void {
        switch (value) {
            case AStreamMode.NO_REFERENCES:
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
    }

    public function alias(name:String, clazz:Class):void {
        registry.alias(name, ClassInfo.forClass(clazz));
    }

    public function aliasProperty(name:String, clazz:Class, propertyName:String):void {
        registry.aliasProperty(name, ClassInfo.forClass(clazz), propertyName);
    }

    public function useAttributeFor(clazz:Class, propertyName:String):void {
        registry.attribute(ClassInfo.forClass(clazz), propertyName);
    }

    public function aliasPackage(name:String, pckg:String):void {
        registry.aliasPackage(name, pckg);
    }

    public function implicitCollection(clazz:Class, propertyName:String, itemName:String, itemClazz:Class):void {
        registry.implicitCollection(ClassInfo.forClass(clazz), propertyName, itemName, ClassInfo.forClass(itemClazz));
    }

    public function autodetectMetadata(value:Boolean):void {
        registry.autodetectMetadata(value);
    }

    public function toXML(object:Object):XML {
        var classInfo:ClassInfo = null;
        if (object != null) {
            classInfo = ClassInfo.forInstance(object);
        }
        const mapper:AStreamMapper = registry.getMapper(classInfo);
        const result:XML = mapper.toXML(object, ref);
        ref.clear();
        return result;
    }

    public function fromXML(xml:XML):Object {
        const mapper:AStreamMapper = registry.getMapper(xml.localName());
        const result:Object = mapper.fromXML(xml, ref);
        ref.clear();
        return result;
    }
}
}
