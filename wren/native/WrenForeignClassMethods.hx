package wren.native;

@:structAccess
@:native('WrenForeignClassMethods')
@:include('linc_wren.h')
extern class WrenForeignClassMethods {
	var allocate:WrenForeignMethodFn;
	var finalize:WrenFinalizerFn;
	
	@:native('linc::wren::initForeignClassMethods')
	static function init():WrenForeignClassMethods;
}