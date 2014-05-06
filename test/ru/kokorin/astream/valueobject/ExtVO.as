package ru.kokorin.astream.valueobject {
import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import flash.utils.IExternalizable;

public class ExtVO extends TestVO implements IExternalizable {
    public function ExtVO(name:String = null) {
        super(name);
    }

    public function writeExternal(output:IDataOutput):void {
        output.writeUTF(name);
        output.writeFloat(value1);
        output.writeInt(value2);
        output.writeUnsignedInt(value3);
        output.writeObject(value4);
        output.writeBoolean(checked);
        output.writeObject(children);
    }

    public function readExternal(input:IDataInput):void {
        name = input.readUTF();
        value1 = input.readFloat();
        value2 = input.readInt();
        value3 = input.readUnsignedInt();
        value4 = input.readObject();
        checked = input.readBoolean();
        children = input.readObject() as Array;
    }
}
}
