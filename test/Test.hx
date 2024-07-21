import wren.Wren;
import wren.WrenVM;
import wren.WrenHandle;
import wren.WrenConfiguration;

class Test {
	function new() {
		
		var conf = WrenConfiguration.init();
		conf.writeFn = cpp.Callable.fromStaticFunction(writeFn);
		conf.errorFn = cpp.Callable.fromStaticFunction(errorFn);
		conf.bindForeignMethodFn = cpp.Callable.fromStaticFunction(bindForeignMethodFn);
		var vm:WrenVM = Wren.newVM(conf);
	
		var file:String = sys.io.File.getContent("test/script.wren");
		var result = Wren.interpret(vm, 'main',  file);
		
		switch result {
			case WREN_RESULT_SUCCESS: trace('WREN_RESULT_SUCCESS');
			case WREN_RESULT_COMPILE_ERROR: trace('WREN_RESULT_COMPILE_ERROR');
			case WREN_RESULT_RUNTIME_ERROR: trace('WREN_RESULT_RUNTIME_ERROR');
		}
	
		Wren.ensureSlots(vm, 1);
		Wren.getVariable(vm, "main", "Call", 0);
		var callClass:WrenHandle = Wren.getSlotHandle(vm, 0);
	
		var noParams:WrenHandle = Wren.makeCallHandle(vm, "noParams");
		var zero:WrenHandle = Wren.makeCallHandle(vm, "zero()");
		var one:WrenHandle = Wren.makeCallHandle(vm, "one(_)");
		var add:WrenHandle = Wren.makeCallHandle(vm, "add(_,_)");
	
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
		
		Wren.ensureSlots(vm, 2);
		Wren.setSlotHandle(vm, 0, callClass);
		Wren.setSlotDouble(vm, 1, 42);
		Wren.setSlotDouble(vm, 2, 58);
		Wren.call(vm, add);
		trace('add result: ${Wren.getSlotDouble(vm, 0)} (should be 100)');
	
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

function writeFn(vm:cpp.RawPointer<wren.RawWrenVM>, text:cpp.ConstCharStar) {
	trace((text:String));
}
function errorFn(vm:cpp.RawPointer<wren.RawWrenVM>, type:WrenErrorType, module:cpp.ConstCharStar, line:Int, message:cpp.ConstCharStar) {
	trace(type, (module:String), line, (message:String));
}

function bindForeignMethodFn(
	vm:cpp.RawPointer<RawWrenVM>,
	module:cpp.ConstCharStar,
	className:cpp.ConstCharStar,
	isStatic:Bool,
	signature:cpp.ConstCharStar
):WrenForeignMethodFn {
	trace('bindForeignMethodFn', (module:String), (className:String), isStatic, (signature:String));
	
	if(module == 'main' && className == 'Call' && isStatic && signature == 'add(_,_)') {
		return cpp.Callable.fromStaticFunction(add);
	}
	return null;
}

function add(vm:cpp.RawPointer<RawWrenVM>) {
	var a = Wren.getSlotDouble(cast vm, 1);
	var b = Wren.getSlotDouble(cast vm, 2);
	Wren.setSlotDouble(cast vm, 0, a + b);
}


// @:include('wren.h')
// class Statics {
// }