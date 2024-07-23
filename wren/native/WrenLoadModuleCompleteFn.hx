package wren.native;

import cpp.Star;
import cpp.ConstCharStar;
import cpp.Callable;

@:native('WrenLoadModuleCompleteFn')
@:include('linc_wren.h')
private extern class Native {}

private typedef Signature = (vm:Star<WrenVM>, name:ConstCharStar, result:WrenLoadModuleResult)->Void;

abstract WrenLoadModuleCompleteFn(Native) {
	@:from
	static inline function fromCallable(v:Callable<Signature>):WrenLoadModuleCompleteFn {
		return cast v;
	}
}
