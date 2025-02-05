package wren;

@:include('linc_wren.h')
@:native("WrenErrorType")
private extern class NativeWrenErrorType { }

// ref: https://github.com/HaxeFoundation/hxcpp/blob/8eeeee784cca9a271c023030d56e3f6db426076c/test/native/tests/TestNativeEnum.hx
@:native("cpp::Struct<WrenErrorType, cpp::EnumHandler>")
private extern class WrenErrorTypeStruct extends NativeWrenErrorType { }

extern enum abstract WrenErrorType(WrenErrorTypeStruct) from WrenErrorTypeStruct to WrenErrorTypeStruct{
	@:native('WREN_ERROR_COMPILE') var WREN_ERROR_COMPILE;
	@:native('WREN_ERROR_RUNTIME') var WREN_ERROR_RUNTIME;
	@:native('WREN_ERROR_STACK_TRACE') var WREN_ERROR_STACK_TRACE;
	
	@:from
	static inline function fromNative(v:wren.native.WrenErrorType):WrenErrorType {
		return cast v;
	}
	
	@:to
	inline function toNative():wren.native.WrenErrorType {
		return cast this;
	}
}
