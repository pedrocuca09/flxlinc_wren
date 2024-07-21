package wren;

// @:native('WrenWriteFn')
// extern class WrenWriteFn {}


@:native('WrenVM*')
@:headerInclude('linc_wren.h')
@:include('linc_wren.h')
extern class RawWrenVM {}

@:structAccess
@:native('WrenConfiguration')
extern class WrenConfiguration {
	public var writeFn:cpp.Callable<(vm:RawWrenVM, text:cpp.ConstCharStar)->Void>;
	
	@:native('linc::wren::initConfiguration')
	public static function init():WrenConfiguration;
	
	// @:native('linc::wren::wrapConfiguration')
	// public static function makeWrapped():WrappedWrenConfiguration;
	
	// public inline function wrap():WrappedWrenConfiguration {
	// 	return makeWrapped(this);
	// }
}

// @:native("cpp::Struct<WrenConfiguration>")
// extern class WrappedWrenConfiguration extends WrenConfiguration { }