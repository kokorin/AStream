/*
 * Copyright 2014 Kokorin Denis
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ru.kokorin.astream.converter {
public class DateConverter implements AStreamConverter {
    private static const UTC_REGEXP:RegExp = /(\d{4})-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d).(\d{1,3}) UTC/;
    public function fromString(string:String):Object {
        var result:Date = null;
        if (string != null) {
            const utcMatch:Array = string.match(UTC_REGEXP);
            if (utcMatch != null && utcMatch.length == 8) {
                result = new Date(0);
                result.setUTCFullYear(parseInt(utcMatch[1]), parseInt(utcMatch[2])-1, parseInt(utcMatch[3]));
                result.setUTCHours(parseInt(utcMatch[4]), parseInt(utcMatch[5]), parseInt(utcMatch[6]), parseInt(utcMatch[7]));
            }
        }
        return result;
    }

    public function toString(value:Object):String {
        const date:Date = value as Date;
        if (date != null) {
            return pol(date.getUTCFullYear(), 4) + "-" +
                    pol(date.getUTCMonth()+1) + "-" +
                    pol(date.getUTCDate()) + " " +
                    pol(date.getUTCHours()) + ":" +
                    pol(date.getUTCMinutes()) + ":" +
                    pol(date.getUTCSeconds()) + "." +
                    date.getUTCMilliseconds() + " UTC";
        }
        return null;
    }

    private static function pol(value:int, length:int = 2):String {
        var result:String = String(value);
        while (result.length < length) {
            result = "0" + result;
        }
        return result;
    }
}
}
