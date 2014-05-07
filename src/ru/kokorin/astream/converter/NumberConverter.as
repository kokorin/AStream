package ru.kokorin.astream.converter {
import flash.system.ApplicationDomain;

import org.spicefactory.lib.reflect.Converter;

public class NumberConverter implements Converter {
    public function convert(value:*, domain:ApplicationDomain = null):* {
        if (value is Number) {
            return value;
        }
        if (value == null) {
            return 0;
        }
        return parseFloat(String(value));
    }
}
}
