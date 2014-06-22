package ru.kokorin.astream.util {
import org.flexunit.asserts.assertEquals;

[RunWith("org.flexunit.runners.Parameterized")]
public class SimpleDateFormatterTest {
    private static const DATE:Date = new Date(1986, 8, 24);
    private static const DATETIME:Date = new Date(2014, 5, 21, 9, 10, 59, 34);

    public static var DATE_DATA:Array = [
        ["YYYY-MM-dd",  DATE, "1986-09-24"],
        ["YYYYMMdd",    DATE, "19860924"],
        ["YY-MM-dd",    DATE, "86-09-24"],
        ["YYMMdd",      DATE, "860924"],
        ["dd MMM YYYY", DATE, "24 Sep 1986"],
        ["dd MMM YYYY", DATE, "24 Sep 1986"],

        ["yyyy.MM.dd G 'at' HH:mm:ss", DATETIME, "2014.06.21 AD at 09:10:59"],
        ["yyyy.MM.dd KK 'o''clock' a",  new Date(2014, 5, 21, 21),  "2014.06.21 09 o'clock PM"],
        ["yyyy.MM.dd KK 'o''clock' a",  new Date(2014, 5, 21, 9),   "2014.06.21 09 o'clock AM"],
        ["yyyy.MM.dd hh 'o''clock' a",  new Date(2014, 5, 21,  21), "2014.06.21 09 o'clock PM"],
        ["yyyy.MM.dd hh 'o''clock' a",  new Date(2014, 5, 21,  9),  "2014.06.21 09 o'clock AM"],
        ["yyyy.MM.dd hh 'o''clock' a",  new Date(2014, 5, 21,  0),  "2014.06.21 12 o'clock AM"],
        ["yyyy.MM.dd HH 'o''clock'",    new Date(2014, 5, 21, 21),  "2014.06.21 21 o'clock"],
        ["yyyy.MM.dd kk 'o''clock'",    new Date(2014, 5, 21, 0),   "2014.06.21 24 o'clock"]
    ];

    [Test(dataProvider="DATE_DATA")]
    public function testParseAndFormat(pattern:String, date:Date, text:String):void {
        const format:SimpleDateFormat = new SimpleDateFormat(pattern);

        assertEquals("Parsed date: ", String(date), String(format.parse(text)));
        assertEquals("Formatted date: ", text, format.format(date));
    }

    public static var TIMEZONE_DATA:Array = [
        ["2014-06-21 13:20:05.24 UTC", 2014, 5, 21, 13, 20, 5, 24],
        ["2014-06-21 13:20:05.24 GMT+03:00", 2014, 5, 21, 10, 20, 5, 24],
        ["2014-06-21 13:20:05.24 GMT+03:30", 2014, 5, 21, 9, 50, 5, 24],
        ["2014-06-21 13:20:05.24 GMT-03:00", 2014, 5, 21, 16, 20, 5, 24],
        ["2014-06-21 13:20:05.24 GMT-03:30", 2014, 5, 21, 16, 50, 5, 24],
        ["2014-06-21 13:20:05.24 MSK", 2014, 5, 21, 9, 20, 5, 24],
        ["2014-06-21 13:20:05.24 Moscow Standard Time", 2014, 5, 21, 9, 20, 5, 24]
    ];

    [Test(dataProvider="TIMEZONE_DATA")]
    public function testTimezoneParse(text:String, fullYearUTC:int, monthUTC:int = 0, dateUTC:int = 0,
                                            hoursUTC:int = 0, minutesUTC:int = 0, secondsUTC:int = 0, millisecondsUTC:int = 0):void
    {
        const format:SimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S z");
        const date:Date = format.parse(text);

        assertEquals("Year ", fullYearUTC, date.fullYearUTC);
        assertEquals("Month ", monthUTC, date.monthUTC);
        assertEquals("Date ", dateUTC, date.dateUTC);
        assertEquals("Hours ", hoursUTC, date.hoursUTC);
        assertEquals("Minutes ", minutesUTC, date.minutesUTC);
        assertEquals("Seconds ", secondsUTC, date.secondsUTC);
        assertEquals("MilliSeconds ", millisecondsUTC, date.millisecondsUTC);
    }
}
}
