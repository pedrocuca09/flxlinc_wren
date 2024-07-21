import wren.Wren;
import wren.WrenVM;
import wren.WrenHandle;
import wren.WrenConfiguration;

class Test {
	function new() {
		
		var conf = WrenConfiguration.init();
		conf.writeFn = cpp.Callable.fromStaticFunction(globalWriteFn);
		var vm:WrenVM = Wren.newVM(conf);
	
		var file:String = sys.io.File.getContent("script.wren");
		Wren.interpret(vm, 'main',  file);
	
		Wren.ensureSlots(vm, 1);
		Wren.getVariable(vm, "main", "Call", 0);
		var callClass:WrenHandle = Wren.getSlotHandle(vm, 0);
	
		var noParams:WrenHandle = Wren.makeCallHandle(vm, "noParams");
		var zero:WrenHandle = Wren.makeCallHandle(vm, "zero()");
		var one:WrenHandle = Wren.makeCallHandle(vm, "one(_)");
	
		Wren.ensureSlots(vm, 1);
		Wren.setSlotHandle(vm, 0, callClass);
		Wren.call(vm, noParams);
		
		Wren.ensureSlots(vm, 1);
		Wren.setSlotHandle(vm, 0, callClass);
		Wren.call(vm, zero);
		
		Wren.ensureSlots(vm, 2);
		Wren.setSlotHandle(vm, 0, callClass);
		Wren.setSlotDouble(vm, 1, 1.0);
		Wren.call(vm, one);
	
		Wren.releaseHandle(vm, callClass);
		Wren.releaseHandle(vm, noParams);
		Wren.releaseHandle(vm, zero);
		Wren.releaseHandle(vm, one);
	
		Wren.freeVM(vm);
	}

	static function main() {
		
		var test = new Test();
		// test.writeFn((null:Any), (null:Any));
		
	}

	// function writeFn(vm:wren.RawWrenVM, text:cpp.ConstCharStar) {
	// 	Sys.print((text:String));
	// 	// trace(text);
	// }

}

function globalWriteFn(vm:wren.RawWrenVM, text:cpp.ConstCharStar) {
	trace(vm);
	trace(text);
	Sys.print((text:String));
	// trace(text);
}
// @:include('wren.h')
// class Statics {
// }