package ru.kokorin.astream.converter {
import as3.lang.Enum;

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;

public class EnumConverter implements AStreamConverter {
    private var classInfo:ClassInfo;

    public function EnumConverter(classInfo:ClassInfo) {
        this.classInfo = classInfo;
    }

    public function fromString(string:String):Object {
        const staticProperty:Property = classInfo.getStaticProperty(string);
        if (staticProperty) {
            return staticProperty.getValue(null);
        }
        return null;
    }

    public function toString(value:Object):String {
        const enum:Enum = value as Enum;
        if (enum) {
            return enum.name;
        }
        return null;
    }
}
}
