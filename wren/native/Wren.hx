package wren.native;

typedef WrenVMStar = cpp.Star<WrenVM>;
typedef WrenHandleStar = cpp.Star<WrenHandle>;


@:keep
@:include('linc_wren.h')
#if !display
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('wren', '../../'))
#end
extern class Wren {


	@:native('linc::wren::newVM')
	// @:native('wrenNewVM')
	static function newVM(config:WrenConfiguration) : WrenVMStar;

	@:native('wrenFreeVM')
	static function freeVM(vm:WrenVMStar) : Void;

	@:native('wrenCollectGarbage')
	static function collectGarbage(vm:WrenVMStar) : Void;

	@:native('wrenInterpret')
	static function interpret(vm:WrenVMStar, module:String, source:String) : WrenInterpretResult;

	@:native('wrenMakeCallHandle')
	static function makeCallHandle(vm:WrenVMStar, signature:String) : WrenHandleStar;

	@:native('wrenCall')
	static function call(vm:WrenVMStar, method:WrenHandleStar) : WrenInterpretResult;

	@:native('wrenReleaseHandle')
	static function releaseHandle(vm:WrenVMStar, value:WrenHandleStar) : Void;

	@:native('wrenGetSlotCount')
	static function getSlotCount(vm:WrenVMStar) : Int;

	@:native('wrenEnsureSlots')
	static function ensureSlots(vm:WrenVMStar, numSlots:Int) : Void;

	@:native('wrenGetSlotType')
	static function getSlotType(vm:WrenVMStar, slot:Int) : WrenType;

	@:native('wrenGetSlotBool')
	static function getSlotBool(vm:WrenVMStar, slot:Int) : Bool;

	@:native('wrenGetSlotBytes')
	static function getSlotBytes(vm:WrenVMStar, slot:Int, length:Int) : Bool;

	@:native('wrenGetSlotDouble')
	static function getSlotDouble(vm:WrenVMStar, slot:Int) : Float;

	@:native('wrenGetSlotForeign')
	static function getSlotForeign(vm:WrenVMStar, slot:Int) : cpp.Star<cpp.Void>;

	@:native('linc::wren::getSlotString')
	static function getSlotString(vm:WrenVMStar, slot:Int) : String;

	@:native('wrenGetSlotHandle')
	static function getSlotHandle(vm:WrenVMStar, slot:Int) : WrenHandleStar;

	@:native('wrenSetSlotBool')
	static function setSlotBool(vm:WrenVMStar, slot:Int, value:Bool) : Void;

	@:native('wrenSetSlotBytes')
	static function setSlotBytes(vm:WrenVMStar, slot:Int, bytes:String, length:UInt) : Void;

	@:native('wrenSetSlotDouble')
	static function setSlotDouble(vm:WrenVMStar, slot:Int, value:Float) : Void;

	@:native('wrenSetSlotNewForeign')
	static function setSlotNewForeign(vm:WrenVMStar, slot:Int, classSlot:Int, size:UInt) : cpp.Star<cpp.Void>;

	@:native('wrenSetSlotNewList')
	static function setSlotNewList(vm:WrenVMStar, slot:Int) : Void;

	@:native('wrenSetSlotNull')
	static function setSlotNull(vm:WrenVMStar, slot:Int) : Void;

	@:native('wrenSetSlotString')
	static function setSlotString(vm:WrenVMStar, slot:Int, text:String) : Void;

	@:native('wrenSetSlotHandle')
	static function setSlotHandle(vm:WrenVMStar, slot:Int, value:WrenHandleStar) : Void;

	@:native('wrenGetListCount')
	static function getListCount(vm:WrenVMStar, slot:Int) : Int;

	@:native('wrenGetListElement')
	static function getListElement(vm:WrenVMStar, listSlot:Int, index:Int, elementSlot:Int) : Void;

	@:native('wrenInsertInList')
	static function insertInList(vm:WrenVMStar, listSlot:Int, index:Int, elementSlot:Int) : Void;

	@:native('wrenGetVariable')
	static function getVariable(vm:WrenVMStar, module:String, name:String, slot:Int) : Void;

	@:native('wrenAbortFiber')
	static function abortFiber(vm:WrenVMStar, slot:Int) : Void;
	
	@:native('wrenGetUserData')
	static function getUserData(vm:WrenVMStar) : cpp.Star<cpp.Void>;
	
	/**
		Allocate memory via wrenSetSlotNewForeign and then store the given Haxe obj to it
		Also add the Haxe obj to GC root to retain it. Call `unroot` on the pointer when done.
	**/
	@:native('linc::hxwren::setSlotNewForeignDynamic')
	static function setSlotNewForeignDynamic<T>(vm:WrenVMStar, slot:Int, classSlot:Int, obj:Dynamic) : Void;
	
	/**
		Remove GC root for the given pointer
	**/
	@:native('linc::hxwren::unroot')
	static function unroot<T>(ptr:cpp.Star<cpp.Void>) : Void;
	

} //Wren


