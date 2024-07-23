package wren;


typedef NativeWrenConfiguration = wren.native.WrenConfiguration;

// struct wrapper over native type to play nice with Dynamic
@:native('::cpp::Struct<WrenConfiguration>')
extern class WrenConfigurationBase extends NativeWrenConfiguration {
	@:native('linc::hxwren::wrapConfiguration')
	static function wrap(v:NativeWrenConfiguration):WrenConfiguration;
}

// abstract wrapper over the struct wrapper for better ergonomics in Haxe
@:forward
abstract WrenConfiguration(WrenConfigurationBase) from WrenConfigurationBase to WrenConfigurationBase {
	@:from
	static inline function fromNative(v:NativeWrenConfiguration) {
		return WrenConfigurationBase.wrap(v);
	}
	
	public static inline function init():WrenConfiguration {
		return NativeWrenConfiguration.init();
	}
}