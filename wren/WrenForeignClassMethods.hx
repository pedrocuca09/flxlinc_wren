package wren;


@:structAccess
@:native('WrenForeignClassMethods')
@:include('linc_wren.h')
extern class WrenForeignClassMethods {
	public var allocate:WrenForeignMethodFn;
	public var finalize:WrenFinalizerFn;
	
	@:native('linc::wren::initForeignClassMethods')
	public static function init():WrenForeignClassMethods;
	
	@:native('linc::hxwren::wrapForeignClassMethods')
	public static function wrap(v:WrenForeignClassMethods):WrenForeignClassMethodsObject;
}

@:native('::cpp::Struct<WrenForeignClassMethods>')
extern class WrenForeignClassMethodsObjectBase extends WrenForeignClassMethods {}

abstract WrenForeignClassMethodsObject(WrenForeignClassMethodsObjectBase) from WrenForeignClassMethodsObjectBase to WrenForeignClassMethodsObjectBase {
	@:from
	static inline function fromNative(v:WrenForeignClassMethods) {
		return WrenForeignClassMethods.wrap(v);
	}
}