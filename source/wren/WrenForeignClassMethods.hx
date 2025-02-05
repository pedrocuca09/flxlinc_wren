package wren;

typedef NativeWrenForeignClassMethods = wren.native.WrenForeignClassMethods;

// struct wrapper over native type to play nice with Dynamic
@:native('::cpp::Struct<WrenForeignClassMethods>')
extern class WrenForeignClassMethodsBase extends NativeWrenForeignClassMethods {
	@:native('linc::hxwren::wrapForeignClassMethods')
	static function wrap(v:NativeWrenForeignClassMethods):WrenForeignClassMethods;
}

// abstract wrapper over the struct wrapper for better ergonomics in Haxe
@:forward
abstract WrenForeignClassMethods(WrenForeignClassMethodsBase) from WrenForeignClassMethodsBase to WrenForeignClassMethodsBase {
	@:from
	static inline function fromNative(v:NativeWrenForeignClassMethods) {
		return WrenForeignClassMethodsBase.wrap(v);
	}
	
	public static inline function init():WrenForeignClassMethods {
		return NativeWrenForeignClassMethods.init();
	}
	
	public static inline function make(o:{allocate:WrenForeignMethodFn, finalize:WrenFinalizerFn}):WrenForeignClassMethods {
		final ret = init();
		ret.allocate = o.allocate;
		ret.finalize = o.finalize;
		return ret;
	}
}