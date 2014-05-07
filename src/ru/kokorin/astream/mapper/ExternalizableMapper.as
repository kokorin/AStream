package ru.kokorin.astream.mapper {
import flash.utils.IExternalizable;

import org.spicefactory.lib.reflect.ClassInfo;

import ru.kokorin.astream.AStreamRegistry;

public class ExternalizableMapper extends SequenceMapper {

    public function ExternalizableMapper(classInfo:ClassInfo, registry:AStreamRegistry) {
        super(classInfo, registry);
    }

    override protected function setSequence(instance:Object, sequence:Array):void {
        const externalizable:IExternalizable = instance as IExternalizable;
        const data:ArrayInput = new ArrayInput(sequence);
        externalizable.readExternal(data);
    }

    override protected function getSequence(instance:Object):Object {
        const externalizable:IExternalizable = instance as IExternalizable;
        const data:ArrayOutput = new ArrayOutput();
        externalizable.writeExternal(data);
        return data.getData();
    }
}
}

import flash.utils.ByteArray;
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

class ArrayInput implements IDataInput {
    private var data:Array;

    public function ArrayInput(data:Array) {
        this.data = data;
    }

    public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {
        throw new Error("Unsupported operation");
    }

    public function readBoolean():Boolean {
        return readObject() as Boolean;
    }

    public function readByte():int {
        return readObject() as int;
    }

    public function readUnsignedByte():uint {
        return readObject() as uint;
    }

    public function readShort():int {
        return readObject() as int;
    }

    public function readUnsignedShort():uint {
        return readObject() as uint;
    }

    public function readInt():int {
        return readObject() as int;
    }

    public function readUnsignedInt():uint {
        return readObject() as uint;
    }

    public function readFloat():Number {
        return readObject() as Number;
    }

    public function readDouble():Number {
        return readObject() as Number;
    }

    public function readMultiByte(length:uint, charSet:String):String {
        throw new Error("Unsupported operation");
    }

    public function readUTF():String {
        return readObject() as String;
    }

    public function readUTFBytes(length:uint):String {
        throw new Error("Unsupported operation");
    }

    public function get bytesAvailable():uint {
        throw new Error("Unsupported operation");
    }

    public function readObject():* {
        if (data && data.length) {
            return data.shift();
        }
        return null;
    }

    public function get objectEncoding():uint {
        throw new Error("Unsupported operation");
    }

    public function set objectEncoding(version:uint):void {
        throw new Error("Unsupported operation");
    }

    public function get endian():String {
        throw new Error("Unsupported operation");
    }

    public function set endian(type:String):void {
        throw new Error("Unsupported operation");
    }
}

class ArrayOutput implements IDataOutput {
    private const data:Array = new Array();

    public function getData():Array {
        return data.concat();
    }

    public function writeBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {
        throw new Error("Unsupported operation");
    }

    public function writeBoolean(value:Boolean):void {
        writeObject(value);
    }

    public function writeByte(value:int):void {
        writeObject(value);
    }

    public function writeShort(value:int):void {
        writeObject(value);
    }

    public function writeInt(value:int):void {
        writeObject(value);
    }

    public function writeUnsignedInt(value:uint):void {
        writeObject(value);
    }

    public function writeFloat(value:Number):void {
        writeObject(value);
    }

    public function writeDouble(value:Number):void {
        writeObject(value);
    }

    public function writeMultiByte(value:String, charSet:String):void {
        throw new Error("Unsupported operation");
    }

    public function writeUTF(value:String):void {
        writeObject(value);
    }

    public function writeUTFBytes(value:String):void {
        throw new Error("Unsupported operation");
    }

    public function writeObject(object:*):void {
        data.push(object);
    }

    public function get objectEncoding():uint {
        throw new Error("Unsupported operation");
    }

    public function set objectEncoding(version:uint):void {
        throw new Error("Unsupported operation");
    }

    public function get endian():String {
        throw new Error("Unsupported operation");
    }

    public function set endian(type:String):void {
        throw new Error("Unsupported operation");
    }
}
