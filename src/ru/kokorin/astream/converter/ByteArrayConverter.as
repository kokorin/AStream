package ru.kokorin.astream.converter {
import com.sociodox.utils.Base64;

import flash.utils.ByteArray;

public class ByteArrayConverter implements AStreamConverter {
    public function fromString(string:String):Object {
        if (string && string != "") {
            return Base64.decode(string);
        }
        return null;
    }

    public function toString(value:Object):String {
        const bytes:ByteArray = value as ByteArray;
        if (bytes) {
            return Base64.encode(bytes);
        }
        return "";
    }
}
}
