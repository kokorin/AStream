package ru.kokorin.astream.converter {
import flash.system.ApplicationDomain;

import org.spicefactory.lib.reflect.Converter;

public class DateConverter implements Converter {

    public function convert(value:*, domain:ApplicationDomain = null):* {
        if (value is Date) {
            return value;
        }
        return new Date(value);
    }
}
}
