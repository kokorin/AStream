package ru.kokorin.astream {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Metadata;
import org.spicefactory.lib.reflect.MetadataAware;
import org.spicefactory.lib.reflect.Property;

import ru.kokorin.astream.metadata.AStreamAlias;
import ru.kokorin.astream.metadata.AStreamAsAttribute;
import ru.kokorin.astream.metadata.AStreamImplicit;
import ru.kokorin.astream.metadata.AStreamOmitField;
import ru.kokorin.astream.metadata.AStreamOrder;
import ru.kokorin.astream.ref.AStreamDeref;
import ru.kokorin.astream.ref.IdDeref;
import ru.kokorin.astream.ref.IdRef;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.util.TypeUtil;

public class AStream {
    private const registry:AStreamRegistry = new AStreamRegistry();

    public function AStream() {
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
        const ref:AStreamRef = new IdRef();
        const result:XML = registry.getMapperForClass(classInfo).toXML(object, ref);
        ref.clear();
        return result;
    }

    public function fromXML(xml:XML):Object {
        const deref:AStreamDeref = new IdDeref();
        const result:Object = registry.getMapperForName(xml.name()).fromXML(xml, deref);
        deref.clear();
        return result;
    }
}
}
