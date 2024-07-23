package wren;

@:include('linc_wren.h')
@:native("WrenInterpretResult")
private extern class NativeWrenInterpretResult { }

// ref: https://github.com/HaxeFoundation/hxcpp/blob/8eeeee784cca9a271c023030d56e3f6db426076c/test/native/tests/TestNativeEnum.hx
@:native("cpp::Struct<WrenInterpretResult, cpp::EnumHandler>")
private extern class WrenInterpretResultStruct extends NativeWrenInterpretResult { }

extern enum abstract WrenInterpretResult(WrenInterpretResultStruct) from WrenInterpretResultStruct to WrenInterpretResultStruct {
	@:native('WREN_RESULT_SUCCESS') var WREN_RESULT_SUCCESS;
	@:native('WREN_RESULT_COMPILE_ERROR') var WREN_RESULT_COMPILE_ERROR;
	@:native('WREN_RESULT_RUNTIME_ERROR') var WREN_RESULT_RUNTIME_ERROR;
	
	@:from
	static inline function fromNative(v:wren.native.WrenInterpretResult):WrenInterpretResult {
		return cast v;
	}
	
	@:to
	inline function toNative():wren.native.WrenInterpretResult {
		return cast this;
	}
}