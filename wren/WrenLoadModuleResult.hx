package wren;

import wren.WrenVM;
import cpp.ConstCharStar;
import cpp.Callable;
import cpp.RawPointer;

@:structAccess
@:native('WrenLoadModuleResult')
@:include('linc_wren.h')
extern class WrenLoadModuleResult {
	public var source:ConstCharStar;
	public var onComplete:WrenLoadModuleCompleteFn;
	public var userData:RawPointer<Void>;
	
	@:native('linc::wren::initLoadModuleResult')
	public static function init():WrenLoadModuleResult;
	
	@:native('linc::hxwren::makeLoadModuleResult')
	public static function make(obj:{source:String, ?onComplete:(name:String)->Void}):WrenLoadModuleResult;
}
