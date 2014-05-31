AStream
=======

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
