package ru.kokorin.astream.converter {
public class DateConverter implements AStreamConverter {
    private static const UTC_REGEXP:RegExp = /(\d{4})-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d).(\d{3}) UTC/;
    public function fromString(string:String):Object {
        var result:Date = null;
        if (string) {
            const utcMatch:Array = string.match(UTC_REGEXP);
            if (utcMatch && utcMatch.length) {
                result = new Date(0);
                result.setUTCFullYear(parseInt(utcMatch[1]), parseInt(utcMatch[2])-1, parseInt(utcMatch[3]));
                result.setUTCHours(parseInt(utcMatch[4]), parseInt(utcMatch[5]), parseInt(utcMatch[6]), parseInt(utcMatch[7]));
            }
        }
        return result;
    }

    public function toString(value:Object):String {
        const date:Date = value as Date;
        if (date) {
            return pol(date.getUTCFullYear(), 4) + "-" +
                    pol(date.getUTCMonth()+1) + "-" +
                    pol(date.getUTCDate()) + " " +
                    pol(date.getUTCHours()) + ":" +
                    pol(date.getUTCMinutes()) + ":" +
                    pol(date.getUTCSeconds()) + "." +
                    pol(date.getUTCMilliseconds(), 3) + " UTC";
        }
        return null;
    }

    private static function pol(value:int, length:int = 2):String {
        var result:String = String(value);
        while (result.length < length) {
            result = "0"+result;
        }
        return result;
    }
}
}
