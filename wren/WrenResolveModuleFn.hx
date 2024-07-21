package wren;

import wren.WrenVM;
import cpp.Callable;
import cpp.ConstCharStar;

@:native('WrenResolveModuleFn')
@:include('linc_wren.h')
extern class NativeWrenResolveModuleFn {}

typedef HaxeWrenResolveModuleFn = (vm:RawWrenVM, importer:ConstCharStar, name:ConstCharStar)->ConstCharStar;

abstract WrenResolveModuleFn(NativeWrenResolveModuleFn) {
	@:from
	static inline function fromCallable(f:Callable<HaxeWrenResolveModuleFn>) {
		return cast f;
	}
}