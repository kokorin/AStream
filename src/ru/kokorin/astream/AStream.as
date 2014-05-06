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
import ru.kokorin.astream.ref.AStreamIdDeref;
import ru.kokorin.astream.ref.AStreamIdRef;
import ru.kokorin.astream.ref.AStreamRef;
import ru.kokorin.astream.util.TypeUtil;

public class AStream {
    private var _autodetectMetadata:Boolean = false;
    private const registry:AStreamRegistry = new AStreamRegistry();
    private const processedClasses:Array = new Array();

    private static var metadataRegistered:Boolean = false;
    private static const metadataClasses:Array = [AStreamAlias, AStreamAsAttribute, AStreamOmitField, AStreamImplicit,
                                                    AStreamOrder];

    private static function registerMetadata():void {
        if (metadataRegistered) {
            return;
        }
        for each (var metadataClass:Class in metadataClasses) {
            Metadata.registerMetadataClass(metadataClass);
        }
        metadataRegistered = true;
    }

    //TODO NaN
    //TODO enhance Date
    //TODO IExternalizable
    //TODO cross-reference and cycle mods
    public function AStream() {
        registerMetadata();
    }

    public function processMetadata(clazz:Class):void {
        const classInfo:ClassInfo = ClassInfo.forClass(clazz);
        processClassMetadata(classInfo);
        autodetectMetadata(false);
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
        //TODO Implement me
    }

    public function implicitCollection(clazz:Class, propertyName:String, itemName:String, itemClazz:Class):void {
        registry.implicitCollection(ClassInfo.forClass(clazz), propertyName, itemName, ClassInfo.forClass(itemClazz));
    }

    public function autodetectMetadata(value:Boolean):void {
        _autodetectMetadata = value;
    }

    public function toXML(object:Object):XML {
        if (_autodetectMetadata) {
            processInstanceMetadata(object);
        }
        var classInfo:ClassInfo = null;
        if (object != null && !isNaN(object as Number)) {
            classInfo = ClassInfo.forInstance(object);
        }
        const ref:AStreamRef = new AStreamIdRef();
        const result:XML = registry.getMapperForClass(classInfo).toXML(object, ref);
        ref.clear();
        return result;
    }

    public function fromXML(xml:XML):Object {
        const deref:AStreamDeref = new AStreamIdDeref();
        const result:Object = registry.getMapperForName(xml.name()).fromXML(xml, deref);
        deref.clear();
        return result;
    }

    private function processClassMetadata(classInfo:ClassInfo):void {
        const objectInfo:ClassInfo = ClassInfo.forClass(Object);
        while (classInfo && classInfo != objectInfo) {
            if (processedClasses.indexOf(classInfo) != -1) {
                break;
            }
            var alias:String = getAlias(classInfo);
            if (alias) {
                registry.alias(alias, classInfo);
            }
            processedClasses.push(classInfo);

            for each (var property:Property in classInfo.getProperties()) {
                if (getMetadata(property, AStreamOmitField)) {
                    registry.omit(classInfo, property.name);
                    continue;
                }
                processClassMetadata(property.type);
                var propertyAlias:String = getAlias(property);
                if (propertyAlias) {
                    registry.aliasProperty(propertyAlias, classInfo, property.name);
                }
                if (getMetadata(property, AStreamAsAttribute)) {
                    registry.attribute(classInfo, property.name);
                }
                var orderMeta:AStreamOrder = getMetadata(property, AStreamOrder) as AStreamOrder;
                if (orderMeta) {
                    registry.order(orderMeta.order, classInfo, property.name);
                }
                var implicitMeta:AStreamImplicit = getMetadata(property, AStreamImplicit) as AStreamImplicit;
                if (implicitMeta) {
                    registry.implicitCollection(classInfo, property.name, implicitMeta.itemName, ClassInfo.forName(implicitMeta.itemType));
                }
            }

            classInfo = ClassInfo.forClass(classInfo.getSuperClass());
        }
    }

    private function processInstanceMetadata(instance:Object):void {
        //TODO возможны циклические ссылки
        const classInfo:ClassInfo = ClassInfo.forInstance(instance);
        processClassMetadata(classInfo);
        for each (var property:Property in classInfo.getProperties()) {
            var value:Object = property.getValue(instance);
            var valueInfo:ClassInfo = ClassInfo.forInstance(value);
            if (TypeUtil.isCollection(valueInfo)) {
                for each (var item:Object in value) {
                    processInstanceMetadata(item);
                }
            } else if (!TypeUtil.isSimple(valueInfo)) {
                processInstanceMetadata(value);
            }
        }
    }

    private static function getMetadata(metadataAware:MetadataAware, metadata:Class):Object {
        const metaArray:Array = metadataAware.getMetadata(metadata);
        if (metaArray && metaArray.length > 0) {
            return metaArray[0];
        }
        return null;
    }

    private static function getAlias(metadataAware:MetadataAware):String {
        const aliasMeta:AStreamAlias = getMetadata(metadataAware, AStreamAlias) as AStreamAlias;
        if (aliasMeta) {
            return aliasMeta.name;
        }
        return null;
    }
}
}
