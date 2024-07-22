package wren;

import cpp.RawPointer;
import cpp.Reference;

/** Reference form, mostly used for holding the reference in Haxe code **/
@:native('::cpp::Reference<WrenVM>')
@:include('linc_wren.h')
extern class WrenVM {
	@:native('linc::hxwren::makeVM')
	static function make():WrenVM;
}

/** The real value type in C **/
@:structAccess
@:native('WrenVM')
@:include('linc_wren.h')
extern class NativeWrenVM {}

/** Raw pointer form, mainly used for callback argument **/
abstract RawWrenVM(RawPointer<NativeWrenVM>) from RawPointer<NativeWrenVM> to RawPointer<NativeWrenVM> {
	@:to
	inline function toReference():WrenVM {
		return cast (cast this : Reference<NativeWrenVM>);
	}
}