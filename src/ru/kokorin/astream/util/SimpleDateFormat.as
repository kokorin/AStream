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

package ru.kokorin.astream.util {
/**
 * Date and Time Patterns
 * <p>
 * Date and time formats are specified by date and time pattern
 * strings.
 * Within date and time pattern strings, unquoted letters from
 * <code>'A'</code> to <code>'Z'</code> and from <code>'a'</code> to
 * <code>'z'</code> are interpreted as pattern letters representing the
 * components of a date or time string.
 * Text can be quoted using single quotes (<code>'</code>) to avoid
 * interpretation.
 * <code>''</code> represents a single quote.
 * All other characters are not interpreted; they're simply copied into the
 * output string during formatting or matched against the input string
 * during parsing.
 * <p>
 * The following pattern letters are defined (all other characters from
 * <code>'A'</code> to <code>'Z'</code> and from <code>'a'</code> to
 * <code>'z'</code> are reserved):
 * <table border=0 cellspacing=3 cellpadding=0 summary="Chart shows pattern letters, date/time component, presentation, and examples.">
 *     <tr bgcolor="#ccccff">
 *         <th align=left>Letter
 *         <th align=left>Date or Time Component
 *         <th align=left>Presentation
 *         <th align=left>Examples
 *     <tr>
 *         <td><code>G</code>
 *         <td>Era designator
 *         <td>Text
 *         <td><code>AD</code>
 *     <tr bgcolor="#eeeeff">
 *         <td><code>y</code>
 *         <td>Year
 *         <td>Year
 *         <td><code>1996</code>; <code>96</code>
 *     <tr>
 *         <td><code>M</code>
 *         <td>Month in year
 *         <td>Month
 *         <td><code>July</code>; <code>Jul</code>; <code>07</code>
 *     <tr bgcolor="#eeeeff">
 *         <td><code>w</code>
 *         <td>Week in year
 *         <td>UNSUPPORTED
 *         <td><code>27</code>
 *     <tr>
 *         <td><code>W</code>
 *         <td>Week in month
 *         <td>UNSUPPORTED
 *         <td><code>2</code>
 *     <tr bgcolor="#eeeeff">
 *         <td><code>D</code>
 *         <td>Day in year
 *         <td>UNSUPPORTED
 *         <td><code>189</code>
 *     <tr>
 *         <td><code>d</code>
 *         <td>Day in month
 *         <td>Number
 *         <td><code>10</code>
 *     <tr bgcolor="#eeeeff">
 *         <td><code>F</code>
 *         <td>Day of week in month
 *         <td>UNSUPPORTED
 *         <td><code>2</code>
 *     <tr>
 *         <td><code>E</code>
 *         <td>Day in week
 *         <td>Text
 *         <td><code>Tuesday</code>; <code>Tue</code>
 *     <tr bgcolor="#eeeeff">
 *         <td><code>a</code>
 *         <td>Am/pm marker
 *         <td>Text
 *         <td><code>PM</code>
 *     <tr>
 *         <td><code>H</code>
 *         <td>Hour in day (0-23)
 *         <td>Number
 *         <td><code>0</code>
 *     <tr bgcolor="#eeeeff">
 *         <td><code>k</code>
 *         <td>Hour in day (1-24)
 *         <td>Number
 *         <td><code>24</code>
 *     <tr>
 *         <td><code>K</code>
 *         <td>Hour in am/pm (0-11)
 *         <td>Number
 *         <td><code>0</code>
 *     <tr bgcolor="#eeeeff">
 *         <td><code>h</code>
 *         <td>Hour in am/pm (1-12)
 *         <td>Number
 *         <td><code>12</code>
 *     <tr>
 *         <td><code>m</code>
 *         <td>Minute in hour
 *         <td>Number
 *         <td><code>30</code>
 *     <tr bgcolor="#eeeeff">
 *         <td><code>s</code>
 *         <td>Second in minute
 *         <td>Number
 *         <td><code>55</code>
 *     <tr>
 *         <td><code>S</code>
 *         <td>Millisecond
 *         <td>Number
 *         <td><code>978</code>
 *     <tr bgcolor="#eeeeff">
 *         <td><code>z</code>
 *         <td>Time zone
 *         <td>General time zone
 *         <td><code>Pacific Standard Time</code>; <code>PST</code>; <code>GMT-08:00</code>
 *     <tr>
 *         <td><code>Z</code>
 *         <td>Time zone
 *         <td>RFC 822 time zone
 *         <td><code>-0800</code>
 * </table>
 */
public class SimpleDateFormat {
    private static const QUOTE_CHAR:String = "\'";
    private static const PATTERN_CHARS:String = "GyMdkHmsSEDFwWahKzZYuX";

    private static const PATTERN_ERA:String = "G";
    private static const PATTERN_YEAR:String = "y";
    private static const PATTERN_MONTH:String = "M";
    private static const PATTERN_DAY_OF_MONTH:String = "d";
    private static const PATTERN_HOUR_OF_DAY1:String = "k";
    private static const PATTERN_HOUR_OF_DAY0:String = "H";
    private static const PATTERN_MINUTE:String = "m";
    private static const PATTERN_SECOND:String = "s";
    private static const PATTERN_MILLISECOND:String = "S";
    private static const PATTERN_DAY_OF_WEEK:String = "E";
    private static const PATTERN_DAY_OF_YEAR:String = "D";
    private static const PATTERN_DAY_OF_WEEK_IN_MONTH:String = "F";
    private static const PATTERN_WEEK_OF_YEAR:String = "w";
    private static const PATTERN_WEEK_OF_MONTH:String = "W";
    private static const PATTERN_AM_PM:String = "a";
    private static const PATTERN_HOUR1:String = "h";
    private static const PATTERN_HOUR0:String = "K";
    private static const PATTERN_ZONE_NAME:String = "z";
    private static const PATTERN_ZONE_VALUE:String = "Z";
    private static const PATTERN_WEEK_YEAR:String = "Y";
    private static const PATTERN_ISO_DAY_OF_WEEK:String = "u";
    private static const PATTERN_ISO_ZONE:String = "X";
    /* This constants only used in formatting. We have to designate that our format
     * has ERA symbol, so that negative years (BC) are printed without minus sign
     * Example: "d MMM y G" corresponds to "1 Jan 7 BC" and NOT to "1 Jan -7 BC"
     * This format string will never be produced by compile function.
     * PATTERN_WEEK_YEAR, PATTERN_YEAR and PATTERN_ERA will be processed separately */
    private static const PATTERN_YEAR_WITH_ERA:String = PATTERN_YEAR + PATTERN_ERA;
    private static const PATTERN_WEEK_YEAR_WITH_ERA:String = PATTERN_WEEK_YEAR + PATTERN_ERA;


    private static const CENTURY_START_YEAR:int = (new Date()).fullYear - 80;

    //TODO try to use ResourceManager.getInstance().getStringArray("SharedResources", "monthNames");
    private static const ERAS:Array = ["BC", "AD"];
    private static const AM_PM:Array = ["AM", "PM"];
    private static const MONTHS:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    private static const SHORT_MONTHS:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    private static const DAYS:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    private static const SHORT_DAYS:Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    private static const TIMEZONE_INFO:Array = [
        ["Alpha Time Zone", "A", "+0100"],
        ["Australian Central Daylight Time", "ACDT", "+1030"],
        ["Australian Central Standard Time", "ACST", "+0930"],
        ["Atlantic Daylight Time", "ADT", "-0300"],
        ["Atlantic Daylight Time", "ADT", "-0300"],
        ["Australian Eastern Daylight Time", "AEDT", "+1100"],
        ["Australian Eastern Standard Time", "AEST", "+1000"],
        ["Afghanistan Time", "AFT", "+0430"],
        ["Alaska Daylight Time", "AKDT", "-0800"],
        ["Alaska Standard Time", "AKST", "-0900"],
        ["Alma-Ata Time", "ALMT", "+0600"],
        ["Armenia Summer Time", "AMST", "+0500"],
        ["Amazon Summer Time", "AMST", "-0300"],
        ["Armenia Time", "AMT", "+0400"],
        ["Amazon Time", "AMT", "-0400"],
        ["Anadyr Summer Time", "ANAST", "+1200"],
        ["Anadyr Time", "ANAT", "+1200"],
        ["Aqtobe Time", "AQTT", "+0500"],
        ["Argentina Time", "ART", "-0300"],
        ["Arabia Standard Time", "AST", "+0300"],
        ["Atlantic Standard Time", "AST", "-0400"],
        ["Atlantic Standard Time", "AST", "-0400"],
        ["Atlantic Standard Time", "AST", "-0400"],
        ["Australian Western Daylight Time", "AWDT", "+0900"],
        ["Australian Western Standard Time", "AWST", "+0800"],
        ["Azores Summer Time", "AZOST", "+0000"],
        ["Azores Time", "AZOT", "-0100"],
        ["Azerbaijan Summer Time", "AZST", "+0500"],
        ["Azerbaijan Time", "AZT", "+0400"],
        ["Bravo Time Zone", "B", "+0200"],
        ["Brunei Darussalam Time", "BNT", "+0800"],
        ["Bolivia Time", "BOT", "-0400"],
        ["Brasilia Summer Time", "BRST", "-0200"],
        ["Brasília time", "BRT", "-0300"],
        ["Bangladesh Standard Time", "BST", "+0600"],
        ["British Summer Time", "BST", "+0100"],
        ["Bhutan Time", "BTT", "+0600"],
        ["Charlie Time Zone", "C", "+0300"],
        ["Casey Time", "CAST", "+0800"],
        ["Central Africa Time", "CAT", "+0200"],
        ["Cocos Islands Time", "CCT", "+0630"],
        ["Cuba Daylight Time", "CDT", "-0400"],
        ["Central Daylight Time", "CDT", "-0500"],
        ["Central European Summer Time", "CEST", "+0200"],
        ["Central European Time", "CET", "+0100"],
        ["Chatham Island Daylight Time", "CHADT", "+1345"],
        ["Chatham Island Standard Time", "CHAST", "+1245"],
        ["Cook Island Time", "CKT", "-1000"],
        ["Chile Summer Time", "CLST", "-0300"],
        ["Chile Standard Time", "CLT", "-0400"],
        ["Colombia Time", "COT", "-0500"],
        ["China Standard Time", "CST", "+0800"],
        ["Central Standard Time", "CST", "-0600"],
        ["Cuba Standard Time", "CST", "-0500"],
        ["Central Standard Time", "CST", "-0600"],
        ["Cape Verde Time", "CVT", "-0100"],
        ["Christmas Island Time", "CXT", "+0700"],
        ["Chamorro Standard Time", "ChST", "+1000"],
        ["Delta Time Zone", "D", "+0400"],
        ["Davis Time", "DAVT", "+0700"],
        ["Echo Time Zone", "E", "+0500"],
        ["Easter Island Summer Time", "EASST", "-0500"],
        ["Easter Island Standard Time", "EAST", "-0600"],
        ["Eastern Africa Time", "EAT", "+0300"],
        ["East Africa Time", "EAT", "+0300"],
        ["Ecuador Time", "ECT", "-0500"],
        ["Eastern Daylight Time", "EDT", "-0400"],
        ["Eastern European Summer Time", "EEST", "+0300"],
        ["Eastern European Time", "EET", "+0200"],
        ["Eastern Greenland Summer Time", "EGST", "+0000"],
        ["East Greenland Time", "EGT", "-0100"],
        ["Eastern Standard Time", "EST", "-0500"],
        ["Tiempo del Este", "ET", "-0500"],
        ["Tiempo Del Este ", "ET", "-0500"],
        ["Foxtrot Time Zone", "F", "+0600"],
        ["Fiji Summer Time", "FJST", "+1300"],
        ["Fiji Time", "FJT", "+1200"],
        ["Falkland Islands Summer Time", "FKST", "-0300"],
        ["Falkland Island Time", "FKT", "-0400"],
        ["Fernando de Noronha Time", "FNT", "-0200"],
        ["Golf Time Zone", "G", "+0700"],
        ["Galapagos Time", "GALT", "-0600"],
        ["Gambier Time", "GAMT", "-0900"],
        ["Georgia Standard Time", "GET", "+0400"],
        ["French Guiana Time", "GFT", "-0300"],
        ["Gilbert Island Time", "GILT", "+1200"],
        ["Greenwich Mean Time", "GMT", "+0000"],
        ["Gulf Standard Time", "GST", "+0400"],
        ["Guyana Time", "GYT", "-0400"],
        ["Hotel Time Zone", "H", "+0800"],
        ["Heure Avancée de l'Atlantique", "HAA", "-0300"],
        ["Heure Avancée du Centre", "HAC", "-0500"],
        ["Hawaii-Aleutian Daylight Time", "HADT", "-0900"],
        ["Heure Avancée de l'Est ", "HAE", "-0400"],
        ["Heure Avancée du Pacifique", "HAP", "-0700"],
        ["Heure Avancée des Rocheuses", "HAR", "-0600"],
        ["Hawaii-Aleutian Standard Time", "HAST", "-1000"],
        ["Heure Avancée de Terre-Neuve", "HAT", "-0230"],
        ["Heure Avancée du Yukon", "HAY", "-0800"],
        ["Hong Kong Time", "HKT", "+0800"],
        ["Hora Legal de Venezuela", "HLV", "-0430"],
        ["Heure Normale de l'Atlantique", "HNA", "-0400"],
        ["Heure Normale du Centre", "HNC", "-0600"],
        ["Heure Normale de l'Est", "HNE", "-0500"],
        ["Heure Normale du Pacifique", "HNP", "-0800"],
        ["Heure Normale des Rocheuses", "HNR", "-0700"],
        ["Heure Normale de Terre-Neuve", "HNT", "-0330"],
        ["Heure Normale du Yukon", "HNY", "-0900"],
        ["Hovd Time", "HOVT", "+0700"],
        ["India Time Zone", "I", "+0900"],
        ["Indochina Time", "ICT", "+0700"],
        ["Israel Daylight Time", "IDT", "+0300"],
        ["Indian Chagos Time", "IOT", "+0600"],
        ["Iran Daylight Time", "IRDT", "+0430"],
        ["Irkutsk Summer Time", "IRKST", "+0900"],
        ["Irkutsk Time", "IRKT", "+0900"],
        ["Iran Standard Time", "IRST", "+0330"],
        ["Israel Standard Time", "IST", "+0200"],
        ["India Standard Time", "IST", "+0530"],
        ["Irish Standard Time", "IST", "+0100"],
        ["Japan Standard Time", "JST", "+0900"],
        ["Kilo Time Zone", "K", "+1000"],
        ["Kyrgyzstan Time", "KGT", "+0600"],
        ["Krasnoyarsk Summer Time", "KRAST", "+0800"],
        ["Krasnoyarsk Time", "KRAT", "+0800"],
        ["Korea Standard Time", "KST", "+0900"],
        ["Kuybyshev Time", "KUYT", "+0400"],
        ["Lima Time Zone", "L", "+1100"],
        ["Lord Howe Daylight Time", "LHDT", "+1100"],
        ["Lord Howe Standard Time", "LHST", "+1030"],
        ["Line Islands Time", "LINT", "+1400"],
        ["Mike Time Zone", "M", "+1200"],
        ["Magadan Summer Time", "MAGST", "+1200"],
        ["Magadan Time", "MAGT", "+1200"],
        ["Marquesas Time", "MART", "-0930"],
        ["Mawson Time", "MAWT", "+0500"],
        ["Mountain Daylight Time", "MDT", "-0600"],
        ["Mitteleuropäische Sommerzeit", "MESZ", "+0200"],
        ["Mitteleuropäische Zeit", "MEZ", "+0100"],
        ["Marshall Islands Time", "MHT", "+1200"],
        ["Myanmar Time", "MMT", "+0630"],
        ["Moscow Daylight Time", "MSD", "+0400"],
        ["Moscow Standard Time", "MSK", "+0400"],
        ["Mountain Standard Time", "MST", "-0700"],
        ["Mauritius Time", "MUT", "+0400"],
        ["Maldives Time", "MVT", "+0500"],
        ["Malaysia Time", "MYT", "+0800"],
        ["November Time Zone", "N", "-0100"],
        ["New Caledonia Time", "NCT", "+1100"],
        ["Newfoundland Daylight Time", "NDT", "-0230"],
        ["Norfolk Time", "NFT", "+1130"],
        ["Novosibirsk Summer Time", "NOVST", "+0700"],
        ["Novosibirsk Time", "NOVT", "+0600"],
        ["Nepal Time ", "NPT", "+0545"],
        ["Newfoundland Standard Time", "NST", "-0330"],
        ["Niue Time", "NUT", "-1100"],
        ["New Zealand Daylight Time", "NZDT", "+1300"],
        ["New Zealand Standard Time", "NZST", "+1200"],
        ["Oscar Time Zone", "O", "-0200"],
        ["Omsk Summer Time", "OMSST", "+0700"],
        ["Omsk Standard Time", "OMST", "+0700"],
        ["Papa Time Zone", "P", "-0300"],
        ["Pacific Daylight Time", "PDT", "-0700"],
        ["Peru Time", "PET", "-0500"],
        ["Kamchatka Summer Time", "PETST", "+1200"],
        ["Kamchatka Time", "PETT", "+1200"],
        ["Papua New Guinea Time", "PGT", "+1000"],
        ["Phoenix Island Time", "PHOT", "+1300"],
        ["Philippine Time", "PHT", "+0800"],
        ["Pakistan Standard Time", "PKT", "+0500"],
        ["Pierre & Miquelon Daylight Time", "PMDT", "-0200"],
        ["Pierre & Miquelon Standard Time", "PMST", "-0300"],
        ["Pohnpei Standard Time", "PONT", "+1100"],
        ["Pacific Standard Time", "PST", "-0800"],
        ["Pitcairn Standard Time", "PST", "-0800"],
        ["Tiempo del Pacífico", "PT", "-0800"],
        ["Palau Time", "PWT", "+0900"],
        ["Paraguay Summer Time", "PYST", "-0300"],
        ["Paraguay Time", "PYT", "-0400"],
        ["Quebec Time Zone", "Q", "-0400"],
        ["Romeo Time Zone", "R", "-0500"],
        ["Reunion Time", "RET", "+0400"],
        ["Sierra Time Zone", "S", "-0600"],
        ["Samara Time", "SAMT", "+0400"],
        ["South Africa Standard Time", "SAST", "+0200"],
        ["Solomon IslandsTime", "SBT", "+1100"],
        ["Seychelles Time", "SCT", "+0400"],
        ["Singapore Time", "SGT", "+0800"],
        ["Suriname Time", "SRT", "-0300"],
        ["Samoa Standard Time", "SST", "-1100"],
        ["Tango Time Zone", "T", "-0700"],
        ["Tahiti Time", "TAHT", "-1000"],
        ["French Southern and Antarctic Time", "TFT", "+0500"],
        ["Tajikistan Time", "TJT", "+0500"],
        ["Tokelau Time", "TKT", "+1300"],
        ["East Timor Time", "TLT", "+0900"],
        ["Turkmenistan Time", "TMT", "+0500"],
        ["Tuvalu Time", "TVT", "+1200"],
        ["Uniform Time Zone", "U", "-0800"],
        ["Ulaanbaatar Time", "ULAT", "+0800"],
        ["Universal Time Coordinated", "UTC", "+0000"],
        ["Uruguay Summer Time", "UYST", "-0200"],
        ["Uruguay Time", "UYT", "-0300"],
        ["Uzbekistan Time", "UZT", "+0500"],
        ["Victor Time Zone", "V", "-0900"],
        ["Venezuelan Standard Time", "VET", "-0430"],
        ["Vladivostok Summer Time", "VLAST", "+1100"],
        ["Vladivostok Time", "VLAT", "+1100"],
        ["Vanuatu Time", "VUT", "+1100"],
        ["Whiskey Time Zone", "W", "-1000"],
        ["West Africa Summer Time", "WAST", "+0200"],
        ["West Africa Time", "WAT", "+0100"],
        ["Western European Summer Time", "WEST", "+0100"],
        ["Westeuropäische Sommerzeit", "WESZ", "+0100"],
        ["Western European Time", "WET", "+0000"],
        ["Westeuropäische Zeit", "WEZ", "+0000"],
        ["Wallis and Futuna Time", "WFT", "+1200"],
        ["Western Greenland Summer Time", "WGST", "-0200"],
        ["West Greenland Time", "WGT", "-0300"],
        ["Western Indonesian Time", "WIB", "+0700"],
        ["Eastern Indonesian Time", "WIT", "+0900"],
        ["Central Indonesian Time", "WITA", "+0800"],
        ["Western Sahara Summer Time", "WST", "+0100"],
        ["West Samoa Time", "WST", "+1300"],
        ["Western Sahara Standard Time", "WT", "+0000"],
        ["X-ray Time Zone", "X", "-1100"],
        ["Yankee Time Zone", "Y", "-1200"],
        ["Yakutsk Summer Time", "YAKST", "+1000"],
        ["Yakutsk Time", "YAKT", "+1000"],
        ["Yap Time", "YAPT", "+1000"],
        ["Yekaterinburg Summer Time", "YEKST", "+0600"],
        ["Yekaterinburg Time", "YEKT", "+0600"],
        ["Zulu Time Zone", "Z", "+0000"]
    ];

    private static const TIMEZONES:Array = extractArray(TIMEZONE_INFO, 0);
    private static const SHORT_TIMEZONES:Array = extractArray(TIMEZONE_INFO, 1);
    private static const TIMEZONE_OFFSETS:Array = extractArray(TIMEZONE_INFO, 2);
    private static const GMT_INDEX:int = SHORT_TIMEZONES.indexOf("GMT");

    private var compiledPattern:Array;

    public function SimpleDateFormat(pattern:String) {
        compiledPattern = compile(pattern);
    }

    public function parse(text:String):Date {
        const dateBuilder:DateBuilder = new DateBuilder();
        var start:int = 0;

        for (var i:int = 0; i < compiledPattern.length; i++) {
            var char:String = compiledPattern[i] as String;
            if (char != null) {
                if (start >= text.length || char != text.charAt(start)) {
                    return null;
                }
                start++;
            }

            var part:CompiledPart = compiledPattern[i] as CompiledPart;
            if (part != null) {
                var obeyCount:Boolean = false;
                //If the next part comes without delimiter we should obey digit count
                if ((i + 1) < compiledPattern.length &&
                        compiledPattern[i + 1] is CompiledPart) {
                    obeyCount = true;
                }
                start = subParse(text, start, part.char, part.count, obeyCount, dateBuilder);
                if (start < 0) {
                    return null;
                }
            }
        }
        return dateBuilder.build();
    }

    private static function subParse(text:String, start:int, formatChar:String, count:int, obeyCount:Boolean, dateBuilder:DateBuilder):int {
        var value:Number = NaN;
        var finish:int = -1;
        var digits:int = 0;
        var char:String;

        if (obeyCount) {
            digits = count;
        } else {
            while (true) {
                char = text.charAt(start + digits);
                if (char >= "0" && char <= "9" ||
                        (char == "-" || char == "+") && digits == 0) {
                    digits++;
                } else {
                    break;
                }
            }
        }
        if (digits > 0) {
            value = parseInt(text.substr(start, digits));
            finish = start + digits;
        }

        var newStart:int;
        switch (formatChar) {
            case PATTERN_ERA:
            {
                newStart = matchString(text, start, ERAS,
                        function (value:String, index:int):void {
                            dateBuilder.setEra(value);
                        });
                if (newStart > 0) {
                    finish = newStart;
                }
                break;
            }
            case PATTERN_WEEK_YEAR_WITH_ERA:
            case PATTERN_YEAR_WITH_ERA:
            {
                //If format contains Era we can't convert two digit years to this century
                dateBuilder.setYear(value);
                break;
            }
            case PATTERN_WEEK_YEAR:
            case PATTERN_YEAR:
            {
                if (count <= 2 && digits == 2) {
                    var ambiguousTwoDigitYear:int = CENTURY_START_YEAR % 100;
                    value += int(CENTURY_START_YEAR / 100) * 100 +
                            (value < ambiguousTwoDigitYear ? 100 : 0);
                }
                dateBuilder.setYear(value);
                break;
            }
            case PATTERN_MONTH:
            {
                if (count <= 2) {
                    dateBuilder.setMonth(value - 1);
                } else {
                    newStart = matchString(text, start, MONTHS, setMonth);
                    if (newStart < 0) {
                        newStart = matchString(text, start, SHORT_MONTHS, setMonth);
                    }
                    if (newStart > 0) {
                        finish = newStart;
                    }
                    function setMonth(name:String, index:int):void {
                        dateBuilder.setMonth(index);
                    }
                }
                break;
            }
            case PATTERN_DAY_OF_MONTH:
            {
                dateBuilder.setDay(value);
                break;
            }
            case PATTERN_HOUR1:
            {              // 'K' 0-based.  eg, 11PM + 1 hour =>> 0 AM
                if (value == 12) {
                    value = 0;
                }
                dateBuilder.setHour(value);
                break;
            }
            case PATTERN_HOUR_OF_DAY1:
            {       // 'H' 0-based.  eg, 23:59 + 1 hour =>> 00:59
                if (value == 24) {
                    value = 0;
                }
                dateBuilder.setHour(value);
                break;
            }
            case PATTERN_HOUR_OF_DAY0:
            case PATTERN_HOUR0:
            {
                dateBuilder.setHour(value);
                break;
            }
            case PATTERN_AM_PM:
            {
                newStart = matchString(text, start, AM_PM,
                        function (value:String, index:int):void {
                            dateBuilder.setAmPm(value);
                        }
                );
                if (newStart > 0) {
                    finish = newStart;
                }
                break;
            }
            case PATTERN_MINUTE:
            {
                dateBuilder.setMinute(value);
                break;
            }
            case PATTERN_SECOND:
            {
                dateBuilder.setSecond(value);
                break;
            }
            case PATTERN_MILLISECOND:
            {
                dateBuilder.setMilliSecond(value);
                break;
            }
            case PATTERN_DAY_OF_WEEK:
            {
                //Ignore day of week. Parse it to find next start.
                newStart = matchString(text, start, DAYS, null);
                if (newStart < 0) {
                    newStart = matchString(text, start, SHORT_DAYS, null);
                }
                if (newStart > 0) {
                    finish = newStart;
                }
                break;
            }
            case PATTERN_ZONE_NAME:
            {
                var isGMT:Boolean = false;
                newStart = matchString(text, start, TIMEZONES, setTimezoneOffset);
                if (newStart < 0) {
                    newStart = matchString(text, start, SHORT_TIMEZONES, setTimezoneOffset);
                }
                if (newStart > 0) {
                    if (isGMT && ((newStart + 5) < text.length)) {
                        char = text.charAt(newStart);
                        var delim:String = text.charAt(newStart + 3);
                        if ((char == "+" || char == "-") && delim == ":") {
                            value = parseFloat(text.substr(newStart, 3) + text.substr(newStart + 4, 2));
                            newStart += 5;
                        }
                    }
                    finish = newStart;
                }
                function setTimezoneOffset(name:String, index:int):void {
                    isGMT = GMT_INDEX == index;
                    value = parseInt(TIMEZONE_OFFSETS[index] as String);
                }

                //Intentionally fall through to the next case PATTERN_ZONE_VALUE
            }
            case PATTERN_ZONE_VALUE:
            {
                var sign:int = 0;
                if (value < 0) {
                    sign = -1;
                    value = -value;
                } else if (value > 0) {
                    sign = 1;
                }
                var hours:int = value / 100;
                var minutes:int = value % 100;
                dateBuilder.setTimezoneOffset(sign * (hours * 60 + minutes));
                break;
            }
            case PATTERN_ISO_ZONE:
            {
                break;
            }
            //UNSUPPORTED
            case PATTERN_DAY_OF_YEAR:
            case PATTERN_DAY_OF_WEEK_IN_MONTH:
            case PATTERN_WEEK_OF_YEAR:
            case PATTERN_WEEK_OF_MONTH:
            case PATTERN_ISO_DAY_OF_WEEK:
            {
                finish = -1;
            }
        }

        return finish;
    }

    private static function matchString(text:String, start:int, values:Array, callback:Function):int {
        var match:String;
        var matchIndex:int;
        //Look for longest matching string
        for (var i:int = 0; i < values.length; i++) {
            var value:String = values[i] as String;
            if (match != null && match.length >= value.length) {
                continue;
            }
            if (text.substr(start, value.length) == value) {
                match = value;
                matchIndex = i;
            }
        }
        if (match != null) {
            if (callback != null) {
                callback(match, matchIndex);
            }
            return start + match.length;
        }
        return -1;
    }

    public function format(value:Date):String {
        var result:String = "";

        for (var i:int = 0; i < compiledPattern.length; i++) {
            var char:String = compiledPattern[i] as String;
            if (char != null) {
                result += char;
            }

            var part:CompiledPart = compiledPattern[i] as CompiledPart;
            if (part != null) {
                result += subFormat(value, part.char, part.count);
            }
        }
        return result;
    }

    private static function subFormat(date:Date, formatChar:String, count:int):String {
        var result:String = "";
        switch (formatChar) {
            case PATTERN_ERA:
            {
                result = ERAS[date.fullYear > 0 ? 1 : 0];
                break;
            }
            case PATTERN_WEEK_YEAR_WITH_ERA:
            case PATTERN_YEAR_WITH_ERA:{
                var year:int = date.fullYear;
                if (year < 0) {
                    year = -year;
                }
                result = pol(year, count);
                break;
            }
            case PATTERN_WEEK_YEAR:
            case PATTERN_YEAR:
            {
                year = date.fullYear;
                if (count == 2) {
                    year = year % 100;
                }
                result = pol(year, count);
                break;
            }
            case PATTERN_MONTH:
            {
                var month:int = date.month;
                if (count <= 2) {
                    result = pol(month + 1, count);
                } else if (count == 3) {
                    result = SHORT_MONTHS[month];
                } else {
                    result = MONTHS[month];
                }
                break;
            }
            case PATTERN_DAY_OF_MONTH:
            {
                result = pol(date.date, count);
                break;
            }
            case PATTERN_HOUR_OF_DAY0:
            {       // 'H' 0-based.  eg, 23:59 + 1 hour =>> 00:59
                result = pol(date.hours, count);
                break;
            }
            case PATTERN_HOUR0:
            {              // 'K' 0-based.  eg, 11PM + 1 hour =>> 0 AM
                result = pol(date.hours % 12, count);
                break;
            }
            case PATTERN_HOUR_OF_DAY1:
            {
                var hours:int = date.hours;
                if (hours == 0) {
                    hours = 24;
                }
                result = pol(hours, count);
                break;
            }
            case PATTERN_HOUR1:
            {
                hours = date.hours % 12;
                if (hours == 0) {
                    hours = 12;
                }
                result = pol(hours, count);
                break;
            }
            case PATTERN_AM_PM:
            {
                result = AM_PM[date.hours < 12 ? 0 : 1];
                break;
            }
            case PATTERN_MINUTE:
            {
                result = pol(date.minutes, count);
                break;
            }
            case PATTERN_SECOND:
            {
                result = pol(date.seconds, count);
                break;
            }
            case PATTERN_MILLISECOND:
            {
                result = pol(date.milliseconds, count);
                break;
            }
            case PATTERN_DAY_OF_WEEK:
            {
                if (count >= 4) {
                    result = DAYS[date.day];
                } else {
                    result = SHORT_DAYS[date.day];
                }
                break;
            }
            case PATTERN_ZONE_NAME:
            {
                result = SHORT_TIMEZONES[GMT_INDEX] + formatTimezoneOffset(date.timezoneOffset, ":");
                break;
            }
            case PATTERN_ZONE_VALUE:
            {
                result = formatTimezoneOffset(date.timezoneOffset);
                break;
            }
            case PATTERN_ISO_ZONE:
            {
                break;
            }
            //UNSUPPORTED
            case PATTERN_DAY_OF_YEAR:
            case PATTERN_DAY_OF_WEEK_IN_MONTH:
            case PATTERN_WEEK_OF_YEAR:
            case PATTERN_WEEK_OF_MONTH:
            case PATTERN_ISO_DAY_OF_WEEK:
            {
            }
        }
        return result;
    }

    private static function compile(pattern:String):Array {
        const result:Array = new Array();

        var inQuote:Boolean = false;
        var count:int = 0;
        var lastChar:String = null;

        for (var i:int = 0; i < pattern.length; i++) {
            var char:String = pattern.charAt(i);
            if (char == QUOTE_CHAR) {
                // '' is treated as a single quote regardless of being
                // in a quoted section.
                if ((i + 1) < pattern.length) {
                    char = pattern.charAt(i + 1);
                    if (char == QUOTE_CHAR) {
                        i++;
                        if (count != 0) {
                            result.push(new CompiledPart(lastChar, count));
                            lastChar = null;
                            count = 0;
                        }
                        result.push(QUOTE_CHAR);
                        continue;
                    }
                }

                if (!inQuote) {
                    if (count != 0) {
                        result.push(new CompiledPart(lastChar, count));
                        lastChar = null;
                        count = 0;
                    }
                }
                inQuote = !inQuote;
                continue;
            }

            if (inQuote) {
                result.push(char);
                continue;
            }

            //Not a letter
            if (!(char >= "a" && char <= "z" || char >= "A" && char <= "Z")) {
                if (count != 0) {
                    result.push(new CompiledPart(lastChar, count));
                    lastChar = null;
                    count = 0;
                }
                result.push(char);
                continue;
            }

            if (PATTERN_CHARS.indexOf(char) == -1) {
                throw new Error("Illegal pattern character '" + char + "'");
            }

            if (lastChar == null || lastChar == char) {
                lastChar = char;
                count++;
                continue;
            }

            result.push(new CompiledPart(lastChar, count));
            lastChar = char;
            count = 1;
        }

        if (inQuote) {
            throw new Error("Unterminated quote");
        }

        if (count != 0) {
            result.push(new CompiledPart(lastChar, count));
        }

        var formatContainsPatternEra:Boolean = false;
        //Additional handling of ERA
        for (var i:int = 0; i < result.length; i++) {
            var part:CompiledPart = result[i] as CompiledPart;
            if (part != null && part.char == PATTERN_ERA) {
                formatContainsPatternEra = true;
                break;
            }
        }
        if (formatContainsPatternEra) {
            for (var i:int = 0; i < result.length; i++) {
                var part:CompiledPart = result[i] as CompiledPart;
                if (part != null) {
                    if (part.char == PATTERN_YEAR) {
                        part.char = PATTERN_YEAR_WITH_ERA;
                    } else if (part.char == PATTERN_WEEK_YEAR) {
                        part.char = PATTERN_WEEK_YEAR_WITH_ERA;
                    }
                }
            }
        }

        return result;
    }

    private static function pol(value:int, count:int):String {
        var prefix:String = "";
        if (value < 0) {
            prefix = "-";
            value = -value;
        }
        var result:String = String(value);
        while (result.length < count) {
            result = "0" + result;
        }
        return prefix + result;
    }

    private static function formatTimezoneOffset(offset:int, delim:String = ""):String {
        var sign:String = "-";
        if (offset < 0) {
            sign = "+";
            offset = -offset;
        }
        var hours:int = offset / 60;
        var minutes:int = offset % 60;

        return sign + pol(hours, 2) + delim + pol(minutes, 2);
    }

    private static function extractArray(values:Array, index:int):Array {
        const result:Array = new Array();
        for each (var value:Array in values) {
            result.push(value[index]);
        }
        return result;
    }
}
}

class CompiledPart {
    public var char:String;
    public var count:int;

    public function CompiledPart(char:String, count:int) {
        this.char = char;
        this.count = count;
    }
}

class DateBuilder {
    private var year:int;
    private var month:int;
    private var day:int;
    private var hour:int = 0;
    private var minute:int = 0;
    private var second:int = 0;
    private var milliSecond:int = 0;
    private var era:String;
    private var ampm:String = null;
    private var timezoneOffset:Number = NaN;

    public function setYear(value:int):void {
        year = value;
    }

    public function setMonth(value:int):void {
        month = value;
    }

    public function setDay(value:int):void {
        day = value;
    }

    public function setHour(value:int):void {
        hour = value;
    }

    public function setMinute(value:int):void {
        minute = value;
    }

    public function setSecond(value:int):void {
        second = value;
    }

    public function setMilliSecond(value:int):void {
        milliSecond = value;
    }

    public function setEra(value:String):void {
        era = value;
    }

    public function setAmPm(value:String):void {
        ampm = value;
    }

    public function setTimezoneOffset(value:int):void {
        timezoneOffset = value;
    }

    public function build():Date {
        const result:Date = new Date();
        var year:int = this.year;
        if (era == "BC") {
            year = -year;
        }

        var hour:int = this.hour;
        if (ampm == "PM" && hour < 12) {
            hour += 12;
        }

        //Timezone wasn't specified, will set local date and time
        if (isNaN(timezoneOffset)) {
            result.setFullYear(year, month, day);
            result.setHours(hour, minute, second, milliSecond);
        } else {
            result.setUTCFullYear(year, month, day);
            result.setUTCHours(hour, minute - timezoneOffset, second, milliSecond);
        }

        return result;
    }
}
