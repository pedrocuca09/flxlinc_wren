package wren;

import cpp.Star;
import cpp.Pointer;

typedef NativeWrenHandle = wren.native.WrenHandle;

@:forward
abstract WrenHandle(Pointer<NativeWrenHandle>) from Pointer<NativeWrenHandle> to Pointer<NativeWrenHandle> {
	@:from
	static inline function fromNativeStar(v:Star<NativeWrenHandle>):WrenHandle {
		return Pointer.fromStar(v);
	}
	
	@:to
	inline function toNativeStar():Star<NativeWrenHandle> {
		return this.ptr;
	}
}
