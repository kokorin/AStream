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
import ru.kokorin.astream.util.TypeUtil;

public class AStreamMetadataProcessor {
    private var registry:AStreamRegistry;
    private const processedClasses:Array = new Array();

    private static var metadataRegistered:Boolean = false;
    private static const metadataClasses:Array = [
        AStreamAlias,
        AStreamAsAttribute,
        AStreamOmitField,
        AStreamImplicit,
        AStreamOrder
    ];

    public function AStreamMetadataProcessor(registry:AStreamRegistry) {
        this.registry = registry;
        registerMetadata();
    }

    private static function registerMetadata():void {
        if (metadataRegistered) {
            return;
        }
        for each (var metadataClass:Class in metadataClasses) {
            Metadata.registerMetadataClass(metadataClass);
        }
        metadataRegistered = true;
    }

    private static const OBJECT_INFO:ClassInfo = ClassInfo.forClass(Object);
    public function processMetadata(classInfo:ClassInfo):void {
        while (classInfo && classInfo != OBJECT_INFO) {
            if (TypeUtil.isCollection(classInfo)) {
                if (TypeUtil.isVector(classInfo)) {
                    processMetadata(TypeUtil.getVectorItemType(classInfo));
                }
                break;
            }
            if (TypeUtil.isSimple(classInfo) || processedClasses.indexOf(classInfo) != -1) {
                break;
            }
            var alias:String = getAlias(classInfo);
            if (alias) {
                registry.alias(alias, classInfo);
            }
            processedClasses.push(classInfo);

            for each (var property:Property in classInfo.getProperties()) {
                processMetadata(property.type);

                if (hasMetadata(property, AStreamOmitField)) {
                    registry.omit(classInfo, property.name);
                    continue;
                }

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

                var collectionItemType:ClassInfo = null;
                if (TypeUtil.isCollection(property.type)) {
                    if (TypeUtil.isVector(property.type)) {
                        collectionItemType = TypeUtil.getVectorItemType(property.type);
                    }
                }
                if (collectionItemType) {
                    processMetadata(collectionItemType);
                }

                var implicitMeta:AStreamImplicit = getMetadata(property, AStreamImplicit) as AStreamImplicit;
                if (implicitMeta) {
                    var implicitItemType:ClassInfo = null;
                    if (implicitMeta.itemType) {
                        implicitItemType = ClassInfo.forName(implicitMeta.itemType);
                        processMetadata(implicitItemType);
                    } else if (collectionItemType) {
                        implicitItemType = collectionItemType;
                    }
                    registry.implicitCollection(classInfo, property.name, implicitMeta.itemName, implicitItemType);
                }

            }

            classInfo = ClassInfo.forClass(classInfo.getSuperClass());
        }
    }

    private static function hasMetadata(metadataAware:MetadataAware, metadata:Class):Object {
        return getMetadata(metadataAware, metadata) != null;
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