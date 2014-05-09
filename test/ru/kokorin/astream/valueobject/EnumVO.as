package ru.kokorin.astream.valueobject {
import as3.lang.Enum;

public class EnumVO extends Enum {
    public static const FIRST:EnumVO = new EnumVO("FIRST");
    public static const SECOND:EnumVO = new EnumVO("SECOND");
    public static const THIRD:EnumVO = new EnumVO("THIRD");

    public function EnumVO(name:String) {
        super(name);
    }
}
}
