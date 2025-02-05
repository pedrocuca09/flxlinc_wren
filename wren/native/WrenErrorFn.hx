package wren.native;

import cpp.ConstCharStar;
import cpp.Star;
import cpp.Callable;

@:native('WrenErrorFn')
@:include('linc_wren.h')
private extern class Native {}

private typedef Signature = (vm:Star<WrenVM>,  type:WrenErrorType, module:ConstCharStar, line:Int,  message:ConstCharStar)->Void;

abstract WrenErrorFn(Native) {
	@:from
	static inline function fromCallable(v:Callable<Signature>):WrenErrorFn {
		return cast v;
	}
}
