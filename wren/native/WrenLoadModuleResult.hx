package wren.native;

import cpp.ConstCharStar;
import cpp.Callable;
import cpp.Star;

@:structAccess
@:native('WrenLoadModuleResult')
@:include('linc_wren.h')
extern class WrenLoadModuleResult {
	public var source:ConstCharStar;
	public var onComplete:WrenLoadModuleCompleteFn;
	public var userData:Star<cpp.Void>;
	
	@:native('linc::wren::initLoadModuleResult')
	public static function init():WrenLoadModuleResult;
	
	@:native('linc::wren::makeLoadModuleResult')
	public static function make(source:String):wren.native.WrenLoadModuleResult;
}
