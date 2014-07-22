package ru.kokorin.astream.converter {
import flash.geom.Point;

public class PointConverter implements Converter {

    public function fromString(string:String):Object {
        const coordinates:Array = string.split(",");
        const result:Point = new Point();
        result.x = parseFloat(String(coordinates[0]));
        result.y = parseFloat(String(coordinates[1]));
        return result;
    }

    public function toString(value:Object):String {
        const point:Point = value as Point;
        return point.x + "," + point.y;
    }
}
}
