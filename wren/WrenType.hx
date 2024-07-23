package wren;

@:include('linc_wren.h')
@:native("WrenType")
private extern class NativeWrenType { }

// ref: https://github.com/HaxeFoundation/hxcpp/blob/8eeeee784cca9a271c023030d56e3f6db426076c/test/native/tests/TestNativeEnum.hx
@:native("cpp::Struct<WrenType, cpp::EnumHandler>")
private extern class NativeWrenType extends NativeWrenType { }

extern enum abstract WrenType(NativeWrenType) {
	@:native('WREN_TYPE_BOOL') var WREN_TYPE_BOOL;
	@:native('WREN_TYPE_NUM') var WREN_TYPE_NUM;
	@:native('WREN_TYPE_FOREIGN') var WREN_TYPE_FOREIGN;
	@:native('WREN_TYPE_LIST') var WREN_TYPE_LIST;
	@:native('WREN_TYPE_MAP') var WREN_TYPE_MAP;
	@:native('WREN_TYPE_NULL') var WREN_TYPE_NULL;
	@:native('WREN_TYPE_STRING') var WREN_TYPE_STRING;
	@:native('WREN_TYPE_UNKNOWN') var WREN_TYPE_UNKNOWN;
}
