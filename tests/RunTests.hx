package ;

import wren.Wren;
import wren.WrenVM;
import wren.WrenHandle;
import wren.WrenConfiguration;
import wren.WrenForeignMethodFn;
import wren.WrenForeignClassMethods;
import wren.WrenLoadModuleResult;

import tink.unit.*;
import tink.testrunner.*;

using tink.CoreApi;

@:asserts
class RunTests {

	static function main() {
		Runner.run(TestBatch.make([
			new RunTests(),
		])).handle(Runner.exit);
	}
	
	
	function new() {}
	
	public function test() {
		final conf = WrenConfiguration.init();
		conf.writeFn = cpp.Callable.fromStaticFunction(writeFn);
		conf.errorFn = cpp.Callable.fromStaticFunction(errorFn);
		conf.bindForeignMethodFn = cpp.Callable.fromStaticFunction(bindForeignMethodFn);
		conf.bindForeignClassFn = cpp.Callable.fromStaticFunction(bindForeignClassFn);
		conf.loadModuleFn = cpp.Callable.fromStaticFunction(loadModuleFn);
		final vm = Wren.newVM(conf);
	
		final file:String = sys.io.File.getContent("tests/script.wren");
		final result = Wren.interpret(vm, 'main', file);
		
		switch result {
			case WREN_RESULT_SUCCESS: trace('WREN_RESULT_SUCCESS');
			case WREN_RESULT_COMPILE_ERROR: trace('WREN_RESULT_COMPILE_ERROR');
			case WREN_RESULT_RUNTIME_ERROR: trace('WREN_RESULT_RUNTIME_ERROR');
		}
	
		Wren.ensureSlots(vm, 1);
		Wren.getVariable(vm, "main", "Call", 0);
		final callClass = Wren.getSlotHandle(vm, 0);
	
		final noParams = Wren.makeCallHandle(vm, "noParams");
		final zero = Wren.makeCallHandle(vm, "zero()");
		final one = Wren.makeCallHandle(vm, "one(_)");
		final add = Wren.makeCallHandle(vm, "add(_,_)");
		final point = Wren.makeCallHandle(vm, "point()");
		final stress = Wren.makeCallHandle(vm, "stress()");
		final module = Wren.makeCallHandle(vm, "module()");
	
		Wren.ensureSlots(vm, 1);
		Wren.setSlotHandle(vm, 0, callClass);
		asserts.assert(Wren.call(vm, noParams) == WREN_RESULT_SUCCESS);
		
		Wren.ensureSlots(vm, 1);
		Wren.setSlotHandle(vm, 0, callClass);
		asserts.assert(Wren.call(vm, zero) == WREN_RESULT_SUCCESS);
		
		Wren.ensureSlots(vm, 2);
		Wren.setSlotHandle(vm, 0, callClass);
		Wren.setSlotDouble(vm, 1, 1.0);
		asserts.assert(Wren.call(vm, one) == WREN_RESULT_SUCCESS);
		
		Wren.ensureSlots(vm, 2);
		Wren.setSlotHandle(vm, 0, callClass);
		Wren.setSlotDouble(vm, 1, 42);
		Wren.setSlotDouble(vm, 2, 58);
		asserts.assert(Wren.call(vm, add) == WREN_RESULT_SUCCESS);
		asserts.assert(Wren.getSlotDouble(vm, 0) == 100);
		
		
		Wren.ensureSlots(vm, 1);
		Wren.setSlotHandle(vm, 0, callClass);
		asserts.assert(Wren.call(vm, point) == WREN_RESULT_SUCCESS);
		
		Wren.ensureSlots(vm, 1);
		Wren.setSlotHandle(vm, 0, callClass);
		asserts.assert(Wren.call(vm, module) == WREN_RESULT_SUCCESS);
		asserts.assert(Wren.getSlotString(vm, 0) == 'Module: another');
		
		// for(i in 0...100) {
		// 	Wren.ensureSlots(vm, 1);
		// 	Wren.setSlotHandle(vm, 0, callClass);
		// 	final result = Wren.call(vm, stress);
		// 	Wren.collectGarbage(vm);
		// 	debug();
		// }
	
		Wren.releaseHandle(vm, callClass);
		Wren.releaseHandle(vm, noParams);
		Wren.releaseHandle(vm, zero);
		Wren.releaseHandle(vm, one);
		Wren.releaseHandle(vm, add);
		Wren.releaseHandle(vm, point);
		Wren.releaseHandle(vm, stress);
	
		Wren.freeVM(vm);
		
		return asserts.done();
	}
	
	static function debug() {
		// trace('run gc'); cpp.vm.Gc.run(false);
		// trace('compact'); cpp.vm.Gc.compact();
		trace('MEM_INFO_USAGE', (cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_USAGE):UInt));
		trace('MEM_INFO_RESERVED', (cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_RESERVED):UInt));
		trace('MEM_INFO_CURRENT', (cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_CURRENT):UInt));
		trace('MEM_INFO_LARGE', (cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_LARGE):UInt));
	}

	// function writeFn(vm:wren.RawWrenVM, text:cpp.ConstCharStar) {
	// 	Sys.print((text:String));
	// 	// trace(text);
	// }

}

function writeFn(vm:RawWrenVM, text:cpp.ConstCharStar) {
	trace((text:String));
}
function errorFn(vm:RawWrenVM, type:WrenErrorType, module:cpp.ConstCharStar, line:Int, message:cpp.ConstCharStar) {
	trace(type, (module:String), line, (message:String));
}

function bindForeignMethodFn(
	vm:RawWrenVM,
	module:cpp.ConstCharStar,
	className:cpp.ConstCharStar,
	isStatic:Bool,
	signature:cpp.ConstCharStar
):WrenForeignMethodFn {
	if(module == 'main' && className == 'Call' && isStatic && signature == 'add(_,_)') {
		return cpp.Callable.fromStaticFunction(add);
	}
	if(module == 'main' && className == 'Point' && signature == 'print()') {
		return cpp.Callable.fromStaticFunction(instance);
	}
	return null;
}

function bindForeignClassFn(
	vm:RawWrenVM,
	module:cpp.ConstCharStar,
	className:cpp.ConstCharStar
):WrenForeignClassMethods {
	trace('bindForeignClass', (module:String), (className:String));
	final methods = WrenForeignClassMethods.init();
	
	if(module == 'main' && className == 'Point') {
		methods.allocate = cpp.Callable.fromStaticFunction(allocatePoint);
		methods.finalize = cpp.Callable.fromStaticFunction(finalizePoint);
	}
	
	return methods;
}

function loadModuleFn(
	vm:RawWrenVM,
	name:cpp.ConstCharStar
):WrenLoadModuleResult {
	final name:String = name; // cast to haxe string
	
	return WrenLoadModuleResult.make({
		source: 'class ${capitalCase(name)} { static name { "Module: $name" } }',
		onComplete: (name:String) -> trace('load module complete: $name'),
	});
	
	// final result = WrenLoadModuleResult.init();
	// result.source = 'class ${capitalCase(name)} { static name { "Module: $name" } }';
	// // cpp.Native.set((cast result.userData:cpp.Star<String>), name);
	// // TODO: may need to retain the source string in GC and free it in the onComplete callback
	// return result;
}

inline function capitalCase(v:String) {
	return v.charAt(0).toUpperCase() + v.substr(1);
}

function add(vm:RawWrenVM) {
	final a = Wren.getSlotDouble(vm, 1);
	final b = Wren.getSlotDouble(vm, 2);
	Wren.setSlotDouble(vm, 0, a + b);
}

function instance(vm:RawWrenVM) {
	final ptr = Wren.getSlotForeign(vm, 0);
	final point = cpp.Native.get((cast ptr:cpp.Star<Point>));
	if(point == null) {
		throw 'invalid instance';
	} else {
		// point.print();
	}

}

var allocated = 0;
var finalized = 0;

// var point:Point;

function allocatePoint(vm:RawWrenVM) {
	var point = new Point();
	Wren.setSlotNewForeignDynamic(vm, 0, 0, point);
	if(allocated % 1000 == 0) {
		trace('allocated', allocated);
	}
	allocated++;
	
}

function finalizePoint(ptr:cpp.RawPointer<Void>) {
	Wren.unroot(ptr);
	if(finalized % 1000 == 0) {
		trace('finalized', finalized);
		
	}
	finalized++;
}

class Point {
	@:keep
	final data = [for(i in 0...100) i];
	public function new() {
		// trace('new Point');
	}
	public function print() {
		trace('My Point');
	}
}


// @:include('wren.h')
// class Statics {
// }