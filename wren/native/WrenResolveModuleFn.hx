package wren.native;

import cpp.ConstCharStar;
import cpp.Star;
import cpp.Callable;

@:native('WrenResolveModuleFn')
@:include('linc_wren.h')
private extern class Native {}

private typedef Signature = (vm:Star<WrenVM>, importer:ConstCharStar, name:ConstCharStar)->ConstCharStar;

abstract WrenResolveModuleFn(Native) {
	@:from
	static inline function fromCallable(v:Callable<Signature>):WrenResolveModuleFn {
		return cast v;
	}
}
