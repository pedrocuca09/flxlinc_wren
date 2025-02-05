package wren.native;

@:unreflective
extern enum abstract WrenInterpretResult(NativeWrenInterpretResult) {
    @:native('WREN_RESULT_SUCCESS') var WREN_RESULT_SUCCESS;
	@:native('WREN_RESULT_COMPILE_ERROR') var WREN_RESULT_COMPILE_ERROR;
	@:native('WREN_RESULT_RUNTIME_ERROR') var WREN_RESULT_RUNTIME_ERROR;
}

@:unreflective
@:include('linc_wren.h')
@:native("WrenInterpretResult")
private extern class NativeWrenInterpretResult { }
