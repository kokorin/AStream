package ru.kokorin.astream {
import as3.lang.Enum;

import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.converter.AStreamConverter;
import ru.kokorin.astream.converter.BooleanConverter;
import ru.kokorin.astream.converter.DateConverter;
import ru.kokorin.astream.converter.EnumConverter;
import ru.kokorin.astream.converter.NumberConverter;
import ru.kokorin.astream.converter.StringConverter;

public class AStreamConverterFactory {
    public function createConverter(classInfo:ClassInfo):AStreamConverter {
        if (classInfo.isType(Boolean)) {
            return new BooleanConverter();
        } else if (classInfo.isType(Date)) {
            return new DateConverter();
        } else if (classInfo.isType(Number) || classInfo.isType(int) ||classInfo.isType(uint)) {
            return new NumberConverter();
        } else if (classInfo.isType(String)) {
            return new StringConverter();
        } else if (classInfo.isType(Enum)) {
            return new EnumConverter(classInfo);
        }
        return null;
    }
}
}
