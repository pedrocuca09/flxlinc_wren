package wren;


import wren.WrenVM;
import wren.WrenHandle;


@:keep
@:include('linc_wren.h')
#if !display
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('wren'))
#end
extern class Wren {


	@:native('linc::wren::newVM')
	// @:native('wrenNewVM')
	static function newVM(config:WrenConfiguration) : WrenVM;

	@:native('wrenFreeVM')
	static function freeVM(vm:WrenVM) : Void;

	@:native('wrenCollectGarbage')
	static function collectGarbage(vm:WrenVM) : Void;

	@:native('wrenInterpret')
	static function interpret(vm:WrenVM, module:String, source:String) : WrenInterpretResult;

	@:native('wrenMakeCallHandle')
	static function makeCallHandle(vm:WrenVM, signature:String) : WrenHandle;

	@:native('wrenCall')
	static function call(vm:WrenVM, method:WrenHandle) : WrenInterpretResult;

	@:native('wrenReleaseHandle')
	static function releaseHandle(vm:WrenVM, value:WrenHandle) : Void;

	@:native('wrenGetSlotCount')
	static function getSlotCount(vm:WrenVM) : Int;

	@:native('wrenEnsureSlots')
	static function ensureSlots(vm:WrenVM, numSlots:Int) : Void;

	@:native('wrenGetSlotType')
	static function getSlotType(vm:WrenVM, slot:Int) : WrenType;

	@:native('wrenGetSlotBool')
	static function getSlotBool(vm:WrenVM, slot:Int) : Bool;

	@:native('wrenGetSlotBytes')
	static function getSlotBytes(vm:WrenVM, slot:Int, length:Int) : Bool;

	@:native('wrenGetSlotDouble')
	static function getSlotDouble(vm:WrenVM, slot:Int) : Float;

	@:native('wrenGetSlotForeign')
	static function getSlotForeign(vm:WrenVM, slot:Int) : Void;

	@:native('linc::wren::getSlotString')
	static function getSlotString(vm:WrenVM, slot:Int) : String;

	@:native('wrenGetSlotHandle')
	static function getSlotHandle(vm:WrenVM, slot:Int) : WrenHandle;

	@:native('wrenSetSlotBool')
	static function setSlotBool(vm:WrenVM, slot:Int, value:Bool) : Void;

	@:native('wrenSetSlotBytes')
	static function setSlotBytes(vm:WrenVM, slot:Int, bytes:String, length:UInt) : Void;

	@:native('wrenSetSlotDouble')
	static function setSlotDouble(vm:WrenVM, slot:Int, value:Float) : Void;

	@:native('wrenSetSlotNewForeign')
	static function setSlotNewForeign(vm:WrenVM, slot:Int, classSlot:Int, size:UInt) : Void;

	@:native('wrenSetSlotNewList')
	static function setSlotNewList(vm:WrenVM, slot:Int) : Void;

	@:native('wrenSetSlotNull')
	static function setSlotNull(vm:WrenVM, slot:Int) : Void;

	@:native('wrenSetSlotString')
	static function setSlotString(vm:WrenVM, slot:Int, text:String) : Void;

	@:native('wrenSetSlotHandle')
	static function setSlotHandle(vm:WrenVM, slot:Int, value:WrenHandle) : Void;

	@:native('wrenGetListCount')
	static function getListCount(vm:WrenVM, slot:Int) : Int;

	@:native('wrenGetListElement')
	static function getListElement(vm:WrenVM, listSlot:Int, index:Int, elementSlot:Int) : Void;

	@:native('wrenInsertInList')
	static function insertInList(vm:WrenVM, listSlot:Int, index:Int, elementSlot:Int) : Void;

	@:native('wrenGetVariable')
	static function getVariable(vm:WrenVM, module:String, name:String, slot:Int) : Void;

	@:native('wrenAbortFiber')
	static function abortFiber(vm:WrenVM, slot:Int) : Void;
	

} //Wren


// typedef WrenConfiguration = {
// 	// final ?writeFn : Callable<(vm:WrenVM, text:String) -> Void>;
// 	final ?initialHeapSize : UInt;
// 	final ?minHeapSize : UInt;
// 	final ?heapGrowthPercent : Int;
// } //WrenConfiguration


@:unreflective
@:native('WrenInterpretResult')
extern class WrenInterpretResultNative {}

@:include('linc_wren.h')
extern enum abstract WrenInterpretResult(WrenInterpretResultNative) {
	@:native('WREN_RESULT_SUCCESS') var WREN_RESULT_SUCCESS;
	@:native('WREN_RESULT_COMPILE_ERROR') var WREN_RESULT_COMPILE_ERROR;
	@:native('WREN_RESULT_RUNTIME_ERROR') var WREN_RESULT_RUNTIME_ERROR;
}

@:unreflective
@:native('WrenErrorType')
extern class WrenErrorTypeNative {}

@:include('linc_wren.h')
extern enum abstract WrenErrorType(WrenErrorTypeNative) {
	@:native('WREN_ERROR_COMPILE') var WREN_ERROR_COMPILE;
	@:native('WREN_ERROR_RUNTIME') var WREN_ERROR_RUNTIME;
	@:native('WREN_ERROR_STACK_TRACE') var WREN_ERROR_STACK_TRACE;
}


@:unreflective
@:native('WrenType')
extern class WrenTypeNative {}

@:include('linc_wren.h')
extern enum abstract WrenType(WrenTypeNative) {
	@:native('WREN_TYPE_BOOL') var WREN_TYPE_BOOL;
	@:native('WREN_TYPE_NUM') var WREN_TYPE_NUM;
	@:native('WREN_TYPE_FOREIGN') var WREN_TYPE_FOREIGN;
	@:native('WREN_TYPE_LIST') var WREN_TYPE_LIST;
	@:native('WREN_TYPE_MAP') var WREN_TYPE_MAP;
	@:native('WREN_TYPE_NULL') var WREN_TYPE_NULL;
	@:native('WREN_TYPE_STRING') var WREN_TYPE_STRING;
	@:native('WREN_TYPE_UNKNOWN') var WREN_TYPE_UNKNOWN;
}
