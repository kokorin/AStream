AStream
=======

AStream can handle enums. Enum's name passed to super() and static property name must coincide.
```as3
package com.example.domain {
import as3.lang.Enum;

public class UserRole extends Enum {
    public static const ADMINISTRATOR:UserRole = new UserRole("ADMINISTRATOR");
    public static const OPERATOR:UserRole = new UserRole("OPERATOR");

    public function UserRole(name:String) {
        super(name);
    }
}
}
```

**There is no guarantee in flash that you will get class' properies in order they were declared!**

You can add AStreamOrder metadata to enforce tag order in xml.
```as3
package com.example.domain {
[AStreamAlias("User")]
public class User {
    private var _name:String;

    [AStreamOrder(10)]
    public var id:Number;
    [AStreamOrder(30)]
    public var role:UserRole;

    public function User() {
    }

    [AStreamOrder(20)]
    public function get name():String {
        return _name;
    }

    public function set name(value:String):void {
        _name = value;
    }

    public function toString():String {
        return "User{_name=" + String(_name) + ",id=" + String(id) + ",role=" + String(role) + "}";
    }
}
}
```

**Use AStream's metadata autodetection with caution!**

If metadata autodetection is on, every time AStream converts an object it will  first process the object's type and all the types related. Therefore it is no problem to serialize an object graph into XML, since AStream will know of all types in advance.

This is no longer true at deserialization time. AStream has to know the alias to turn it into the proper type, but it can find the annotation for the alias only if it has processed the type in advance. Therefore deserialization will fail if the type has not already been processed either by having called AStream's processMetadata method or by already having serialized this type. However, AStreamAlias is the only metadata that may fail in this case.
```as3
const aStream:AStream = new AStream();
aStream.processMetadata(User);
//or aStream.autodetectMetadata(true);

const user:User = new User();
user.id = 1;
user.name = "Ivanov Ivan";
user.role = UserRole.ADMINISTRATOR;

const xml:XML = aStream.toXML(user);
/* xml.toXMLString()
 <User>
    <id>1</id>
    <name>Ivanov Ivan</name>
    <role>ADMINISTRATOR</role>
 </User> */

const restoredUser:User = aStream.fromXML(xml) as User;
/* restoredUser.toString()
User{_name=Ivanov Ivan,id=1,role=ADMINISTRATOR} */
```        

**Сorresponding types (by default)**

         Java        |         XML         |                AS3       
---------------------|---------------------|------------------------------------
       byte[]        |      byte-array     |              ByteArray
       Type[]        |      Type-array     |         Vector.&lt;Type&gt;
 java.util.ArrayList |        list         | org.spicefactory.lib.collection.List
  java.util.HashMap  |         map         | org.spicefactory.lib.collection.Map
    Float, float     |        float        |               Number                  
    Integer, int     |         int         |                int                  
   java.util.Date    |         date        |                Date
      String         |        string       |               String                 
      
      
