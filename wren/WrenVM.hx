package wren;

import wren.WrenForeignMethodFn;
import wren.WrenForeignClassMethods;
import cpp.Star;
import cpp.Pointer;

/** The real value type in C **/
private typedef Native = wren.native.WrenVM;
extern abstract WrenVM(Pointer<Native>) from Pointer<Native> to Pointer<Native> {
	@:from
	static inline function fromStar(v:Star<Native>):WrenVM {
		return Pointer.fromStar(v);
	}
	
	@:to
	inline function toStar():Star<Native> {
		return this.ptr;
	}

	@:native('linc::hxwren::makeVM')
	private static function _make(config:{
		writeFn:(vm:WrenVM, text:String)->Void,
		errorFn:(vm:WrenVM, type:WrenErrorType, module:String, line:Int, message:String)->Void,
		loadModuleFn:(vm:WrenVM, module:String)->String,
		bindForeignMethodFn:(vm:WrenVM, module:String, className:String, isStatic:Bool, signature:String)->WrenForeignMethodFn,
		bindForeignClassFn:(vm:WrenVM, module:String, className:String)->WrenForeignClassMethods,
	}):Star<Native>;
	
	@:native('linc::hxwren::destroyVM')
	static function destroyVM(vm:WrenVM):Void;
	
	static inline function make(config):WrenVM {
		return _make(config);
	}

	inline function collectGarbage():Void 
		return wren.native.Wren.collectGarbage(this.ptr);

	inline function interpret(module:String, source:String):WrenInterpretResult 
		return wren.native.Wren.interpret(this.ptr, module, source);

	inline function makeCallHandle(signature:String):WrenHandle 
		return wren.native.Wren.makeCallHandle(this.ptr, signature);

	inline function call(method:WrenHandle):WrenInterpretResult 
		return wren.native.Wren.call(this.ptr, method);

	inline function releaseHandle(value:WrenHandle):Void 
		return wren.native.Wren.releaseHandle(this.ptr, value);

	inline function getSlotCount():Int 
		return wren.native.Wren.getSlotCount(this.ptr);

	inline function ensureSlots(numSlots:Int):Void 
		return wren.native.Wren.ensureSlots(this.ptr, numSlots);

	inline function getSlotType(slot:Int):WrenType 
		return wren.native.Wren.getSlotType(this.ptr, slot);

	inline function getSlotBool(slot:Int):Bool 
		return wren.native.Wren.getSlotBool(this.ptr, slot);

	inline function getSlotBytes(slot:Int, length:Int):Bool 
		return wren.native.Wren.getSlotBytes(this.ptr, slot, length);

	inline function getSlotDouble(slot:Int):Float 
		return wren.native.Wren.getSlotDouble(this.ptr, slot);

	inline function getSlotForeign(slot:Int):cpp.Star<cpp.Void> 
		return wren.native.Wren.getSlotForeign(this.ptr, slot);

	inline function getSlotString(slot:Int):String 
		return wren.native.Wren.getSlotString(this.ptr, slot);

	inline function getSlotHandle(slot:Int):WrenHandle 
		return wren.native.Wren.getSlotHandle(this.ptr, slot);

	inline function setSlotBool(slot:Int, value:Bool):Void 
		return wren.native.Wren.setSlotBool(this.ptr, slot, value);

	inline function setSlotBytes(slot:Int, bytes:String, length:UInt):Void 
		return wren.native.Wren.setSlotBytes(this.ptr, slot, bytes, length);

	inline function setSlotDouble(slot:Int, value:Float):Void 
		return wren.native.Wren.setSlotDouble(this.ptr, slot, value);

	inline function setSlotNewForeign(slot:Int, classSlot:Int, size:UInt):cpp.Star<cpp.Void> 
		return wren.native.Wren.setSlotNewForeign(this.ptr, slot, classSlot, size);

	inline function setSlotNewForeignDynamic(slot:Int, classSlot:Int, obj:Dynamic):Void
		return wren.native.Wren.setSlotNewForeignDynamic(this.ptr, slot, classSlot, obj);

	inline function setSlotNewList(slot:Int):Void 
		return wren.native.Wren.setSlotNewList(this.ptr, slot);

	inline function setSlotNull(slot:Int):Void 
		return wren.native.Wren.setSlotNull(this.ptr, slot);

	inline function setSlotString(slot:Int, text:String):Void 
		return wren.native.Wren.setSlotString(this.ptr, slot, text);

	inline function setSlotHandle(slot:Int, value:WrenHandle):Void 
		return wren.native.Wren.setSlotHandle(this.ptr, slot, value);

	inline function getListCount(slot:Int):Int 
		return wren.native.Wren.getListCount(this.ptr, slot);

	inline function getListElement(listSlot:Int, index:Int, elementSlot:Int):Void 
		return wren.native.Wren.getListElement(this.ptr, listSlot, index, elementSlot);

	inline function setListElement(listSlot:Int, index:Int, elementSlot:Int):Void
		return wren.native.Wren.setListElement(this.ptr, listSlot, index, elementSlot);

	inline function insertInList(listSlot:Int, index:Int, elementSlot:Int):Void 
		return wren.native.Wren.insertInList(this.ptr, listSlot, index, elementSlot);

	inline function getMapCount(slot:Int):Int
		return wren.native.Wren.getMapCount(this.ptr, slot);

	inline function getMapContainsKey(mapSlot:Int, keySlot:Int):Bool
		return wren.native.Wren.getMapContainsKey(this.ptr, mapSlot, keySlot);

	inline function getMapValue(mapSlot:Int, keySlot:Int, valueSlot:Int):Void
		return wren.native.Wren.getMapValue(this.ptr, mapSlot, keySlot, valueSlot);

	inline function setMapValue(mapSlot:Int, keySlot:Int, valueSlot:Int):Void
		return wren.native.Wren.setMapValue(this.ptr, mapSlot, keySlot, valueSlot);

	inline function removeMapValue(mapSlot:Int, keySlot:Int, removedValueSlot:Int):Void
		return wren.native.Wren.removeMapValue(this.ptr, mapSlot, keySlot, removedValueSlot);

	inline function getVariable(module:String, name:String, slot:Int):Void 
		return wren.native.Wren.getVariable(this.ptr, module, name, slot);

	inline function hasVariable(module:String, name:String):Bool
		return wren.native.Wren.hasVariable(this.ptr, module, name);

	inline function hasModule(module:String):Bool
		return wren.native.Wren.hasModule(this.ptr, module);

	inline function abortFiber(slot:Int):Void 
		return wren.native.Wren.abortFiber(this.ptr, slot);

	inline function free():Void
		return destroyVM(this);
}
