package ru.kokorin.astream.util {
public class XmlUtil {
    public static function getXPath(xml:XML, forceSingleNode:Boolean):String {
        var result:String = "";
        while (xml != null) {
            var name:String = String(xml.name());
            var index:int = 0;
            var parentXML:XML = xml.parent();
            if (parentXML) {
                var siblingXMLList:XMLList = parentXML.child(name);
                for (var i:int = 0; i < siblingXMLList.length(); i++) {
                    if (siblingXMLList[i] == xml) {
                        index = i;
                        break;
                    }
                }
            }
            var singleNodeSelector:String;
            if (index != 0 || forceSingleNode) {
                singleNodeSelector = "[" + (index+1) + "]";
            } else {
                singleNodeSelector = "";
            }
            result = "/" + name + singleNodeSelector + result;
            xml = parentXML;
        }
        return result;
    }

    public static function getAbsoluteXPath(basePath:String, relativePath:String):String {
        const result:Array = basePath.split("/");
        const relativeSplit:Array = relativePath.split("/");
        while (relativeSplit.length > 0) {
            var part:String = relativeSplit.shift() as String;
            if (part == "..") {
                result.pop();
            } else if (part != ".") {
                result.push(part);
            }
        }
        return result.join("/");
    }

    public static function getRelativeXPath(toPath:String, fromPath:String):String {
        const toSplit:Array = toPath.split("/");
        const fromSplit:Array = fromPath.split("/");

        while (toSplit.length > 0 && fromSplit.length > 0) {
            if (toSplit[0] != fromSplit[0]) {
                break;
            }
            toSplit.shift();
            fromSplit.shift();
        }

        const result:Array = new Array();
        while (result.length < fromSplit.length) {
            result.push("..");
        }
        if (result.length == 0) {
            result.push(".");
        }
        while (toSplit.length > 0) {
            result.push(toSplit.shift());
        }
        return result.join("/");
    }
}
}
