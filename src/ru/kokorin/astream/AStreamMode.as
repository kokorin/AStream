package ru.kokorin.astream {
import as3.lang.Enum;

public class AStreamMode extends Enum {
    public static const NO_REFERENCES:AStreamMode = new AStreamMode("NO_REFERENCES");
    public static const ID_REFERENCES:AStreamMode = new AStreamMode("ID_REFERENCES");
    public static const XPATH_ABSOLUTE_REFERENCES:AStreamMode = new AStreamMode("XPATH_ABSOLUTE_REFERENCES");
    public static const XPATH_RELATIVE_REFERENCES:AStreamMode = new AStreamMode("XPATH_RELATIVE_REFERENCES");
    public static const SINGLE_NODE_XPATH_ABSOLUTE_REFERENCES:AStreamMode = new AStreamMode("SINGLE_NODE_XPATH_ABSOLUTE_REFERENCES");
    public static const SINGLE_NODE_XPATH_RELATIVE_REFERENCES:AStreamMode = new AStreamMode("SINGLE_NODE_XPATH_RELATIVE_REFERENCES");

    public function AStreamMode(name:String) {
        super(name);
    }
}
}
