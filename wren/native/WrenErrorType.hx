package wren.native;

@:unreflective
extern enum abstract WrenErrorType(NativeWrenErrorType) {
	@:native('WREN_ERROR_COMPILE') var WREN_ERROR_COMPILE;
	@:native('WREN_ERROR_RUNTIME') var WREN_ERROR_RUNTIME;
	@:native('WREN_ERROR_STACK_TRACE') var WREN_ERROR_STACK_TRACE;
}

@:unreflective
@:include('linc_wren.h')
@:native("WrenErrorType")
private extern class NativeWrenErrorType { }


