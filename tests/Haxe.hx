package;

import wren.WrenVM;
import wren.WrenHandle;
import wren.WrenConfiguration;
import wren.WrenForeignMethodFn;
import wren.WrenForeignClassMethods;
import wren.WrenLoadModuleResult;
import wren.WrenInterpretResult;

@:asserts
class Haxe {
	public function new() {}
	
	public function test() {
		final vm = create();
		
		final file:String = sys.io.File.getContent("tests/script.wren");
		final result = vm.interpret('main', file);
		
		vm.ensureSlots(1);
		vm.getVariable("main", "Call", 0);
		final callClass = vm.getSlotHandle(0);
	
		final noParams = vm.makeCallHandle("noParams");
		final zero = vm.makeCallHandle("zero()");
		final one = vm.makeCallHandle("one(_)");
		final add = vm.makeCallHandle("add(_,_)");
		final point = vm.makeCallHandle("point()");
		final stress = vm.makeCallHandle("stress()");
		final module = vm.makeCallHandle("module()");
	
		vm.ensureSlots(1);
		vm.setSlotHandle(0, callClass);
		asserts.assert(vm.call(noParams) == WREN_RESULT_SUCCESS);
		
		vm.ensureSlots(1);
		vm.setSlotHandle(0, callClass);
		asserts.assert(vm.call(zero) == WREN_RESULT_SUCCESS);
		
		vm.ensureSlots(2);
		vm.setSlotHandle(0, callClass);
		vm.setSlotDouble(1, 1.0);
		asserts.assert(vm.call(one) == WREN_RESULT_SUCCESS);
		
		vm.ensureSlots(2);
		vm.setSlotHandle(0, callClass);
		vm.setSlotDouble(1, 42);
		vm.setSlotDouble(2, 58);
		asserts.assert(vm.call(add) == WREN_RESULT_SUCCESS);
		asserts.assert(vm.getSlotDouble(0) == 100);
		
		
		vm.ensureSlots(1);
		vm.setSlotHandle(0, callClass);
		asserts.assert(vm.call(point) == WREN_RESULT_SUCCESS);
		
		vm.ensureSlots(1);
		vm.setSlotHandle(0, callClass);
		asserts.assert(vm.call(module) == WREN_RESULT_SUCCESS);
		asserts.assert(vm.getSlotString(0) == 'Module: another');
		
		// for(i in 0...100) {
		// 	vm.ensureSlots(1);
		// 	vm.setSlotHandle(0, callClass);
		// 	final result = vm.call(stress);
		// 	vm.collectGarbage(
		// }
	
		vm.releaseHandle(callClass);
		vm.releaseHandle(noParams);
		vm.releaseHandle(zero);
		vm.releaseHandle(one);
		vm.releaseHandle(add);
		vm.releaseHandle(point);
		vm.releaseHandle(stress);
		vm.releaseHandle(module);
	
		// TODO: free the retained config object from makeVM
		vm.free();
		
		return asserts.done();
	}
	
	function create() {
		return WrenVM.make({
			writeFn: (_, v) -> Sys.print(v),
			errorFn: (_, type, module, line, message) -> Sys.println('Error: $type $module $line $message'),
			loadModuleFn: (_, name) -> 'class ${capitalCase(name)} { static name { "Module: $name" } }',
			bindForeignMethodFn: (vm, module, className, isStatic, signature) -> {
				return switch [module, className, isStatic, signature] {
					case ['main', 'Call', true, 'add(_,_)']: cpp.Callable.fromStaticFunction(add);
					case ['main', 'Point', false, 'print()']: cpp.Callable.fromStaticFunction(instance);
					case _: null;
				}
			},
			bindForeignClassFn:(vm, module, className) -> {
				switch [module, className] {
					case ['main', 'Point']:
						return WrenForeignClassMethods.make({
							allocate: cpp.Callable.fromStaticFunction(allocatePoint),
							finalize: cpp.Callable.fromStaticFunction(finalizePoint),
						});
						case _: /* no-op */
							return WrenForeignClassMethods.init();
					}
			}
		});
	}
}


function add(vm:cpp.Star<wren.native.WrenVM>) {
	final vm:WrenVM = vm;
	final a = vm.getSlotDouble(1);
	final b = vm.getSlotDouble(2);
	vm.setSlotDouble(0, a + b);
}

function instance(vm:cpp.Star<wren.native.WrenVM>) {
	final vm:WrenVM = vm;
	final ptr = vm.getSlotForeign(0);
	final point = cpp.Native.get((cast ptr:cpp.Star<Point>));
	if(point == null) {
		throw 'invalid instance';
	} else {
		// point.print();
	}

}

function allocatePoint(vm:cpp.Star<wren.native.WrenVM>) {
	final vm:WrenVM = vm;
	final point = new Point();
	vm.setSlotNewForeignDynamic(0, 0, point);
	
}

function finalizePoint(ptr:cpp.Star<cpp.Void>) {
	wren.native.Wren.unroot(ptr);
}


inline function capitalCase(v:String) {
	return v.charAt(0).toUpperCase() + v.substr(1);
}

private class Point {
	@:keep
	final data = [for(i in 0...100) i];
	public function new() {
		// trace('new Point');
	}
	public function print() {
		trace('My Point');
	}
}
