package ru.kokorin.astream {
import org.flexunit.asserts.assertEquals;
import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.valueobject.ExtVO;

import ru.kokorin.astream.valueobject.TestVO;

[RunWith("org.flexunit.runners.Parameterized")]
public class AStreamRegistryTest {
    private var registry:AStreamRegistry;

    [Before]
    public function setUp():void {
        registry = new AStreamRegistry();
    }

    public static var PACKAGE_ALIAS_DATA:Array = [
        [{}, "String", String],
        [{}, "ru.kokorin.astream.valueobject.TestVO", TestVO],
        [{"su":"ru"}, "su.kokorin.astream.valueobject.TestVO", TestVO],
        [{"su":"ru", "sukokorin":"ru.kokorin"}, "sukokorin.astream.valueobject.TestVO", TestVO],
        [{"su":"ru", "sukokorin":"ru.kokorin"}, "sukokorin.astream.valueobject.TestVO", TestVO],
        [{"su":"ru", "sukokorin":"ru.kokorin", "sukokorinastream":"ru.kokorin.astream"}, "sukokorinastream.valueobject.TestVO", TestVO],
        [{"":"ru.kokorin.astream.valueobject"}, "TestVO", TestVO],
        [{"as3.lang":""}, "as3.lang.String", String]
    ];
    [Test(dataProvider="PACKAGE_ALIAS_DATA")]
    public function testAliasPackage(aliases:Object, alias:String, clazz:Class):void {
        const classInfo:ClassInfo = ClassInfo.forClass(clazz);
        for (var name:String in aliases) {
            var pckg:String = aliases[name] as String;
            registry.aliasPackage(name, pckg);
        }

        assertEquals("getAlias("+clazz+")", alias, registry.getAlias(classInfo));
        assertEquals("getClass("+alias+")", classInfo, registry.getClass(alias));
    }

    public static var ALIAS_DATA:Array = [
        [Vector.<Object>, "Object-array"],
        [Vector.<TestVO>, "ru.kokorin.astream.valueobject.TestVO-array"],
        [Vector.<int>, "int-array"]
    ];
    [Test(dataProvider="ALIAS_DATA")]
    public function testVectorAlias(type:Class, alias:String):void {
        const info:ClassInfo = ClassInfo.forClass(type);
        assertEquals("Alias by class", registry.getAlias(info), alias);
        assertEquals("Class by alias", registry.getClass(alias), info);
    }
}
}
