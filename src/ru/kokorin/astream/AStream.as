package ru.kokorin.astream {
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.mapper.AStreamMapper;
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.ref.IdDeref;
import ru.kokorin.astream.ref.IdRef;
import ru.kokorin.astream.ref.NoDeref;
import ru.kokorin.astream.ref.NoRef;
import ru.kokorin.astream.ref.XPathAbsoluteDeref;
import ru.kokorin.astream.ref.XPathAbsoluteRef;
import ru.kokorin.astream.ref.XPathRelativeDeref;
import ru.kokorin.astream.ref.XPathRelativeRef;

public class AStream {
    private var ref:AStreamRef;
    private var deref:AStreamDeref;
    private const registry:AStreamRegistry = new AStreamRegistry();

    public function AStream() {
        mode = AStreamMode.XPATH_RELATIVE_REFERENCES;
    }

    public function set mode(value:AStreamMode):void {
        switch (value) {
            case AStreamMode.NO_REFERENCES: {
                ref = new NoRef();
                deref = new NoDeref();
                break;
            }
            case AStreamMode.ID_REFERENCES: {
                ref = new IdRef();
                deref = new IdDeref();
                break;
            }
            case AStreamMode.SINGLE_NODE_XPATH_ABSOLUTE_REFERENCES: {
                ref = new XPathAbsoluteRef(true);
                deref = new XPathAbsoluteDeref(true);
                break;
            }
            case AStreamMode.SINGLE_NODE_XPATH_RELATIVE_REFERENCES:{
                ref = new XPathRelativeRef(true);
                deref = new XPathRelativeDeref(true);
                break;
            }
            case AStreamMode.XPATH_ABSOLUTE_REFERENCES: {
                ref = new XPathAbsoluteRef(false);
                deref = new XPathAbsoluteDeref(false);
                break;
            }
            case AStreamMode.XPATH_RELATIVE_REFERENCES:
            default: {
                ref = new XPathRelativeRef(false);
                deref = new XPathRelativeDeref(false);
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
        if (object != null && !isNaN(object as Number)) {
            classInfo = ClassInfo.forInstance(object);
        }
        const mapper:AStreamMapper = registry.getMapperForClass(classInfo);
        const result:XML = mapper.toXML(object, ref);
        ref.clear();
        return result;
    }

    public function fromXML(xml:XML):Object {
        const mapper:AStreamMapper = registry.getMapperForName(xml.name());
        const result:Object = mapper.fromXML(xml, deref);
        deref.clear();
        return result;
    }
}
}
