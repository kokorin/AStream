package as3.lang {
public class Enum {
    private var _name:String;

    public function Enum(name:String) {
        this._name = name;
    }

    public function get name():String {
        return _name;
    }

    public function toString():String {
        return name;
    }
}
}
