package wren;


@:structAccess
@:native('WrenForeignClassMethods')
@:include('linc_wren.h')
extern class WrenForeignClassMethods {
	public var allocate:WrenForeignMethodFn;
	public var finalize:WrenFinalizerFn;
	
	@:native('linc::wren::initForeignClassMethods')
	public static function init():WrenForeignClassMethods;
}