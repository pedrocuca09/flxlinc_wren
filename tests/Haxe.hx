package;


import wren.native.Wren;
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
		final result = Wren.interpret(vm, 'main', file);
		
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
		// }
	
		Wren.releaseHandle(vm, callClass);
		Wren.releaseHandle(vm, noParams);
		Wren.releaseHandle(vm, zero);
		Wren.releaseHandle(vm, one);
		Wren.releaseHandle(vm, add);
		Wren.releaseHandle(vm, point);
		Wren.releaseHandle(vm, stress);
		Wren.releaseHandle(vm, module);
	
		// TODO: free the retained config object from makeVM
		Wren.freeVM(vm);
		
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
	final a = Wren.getSlotDouble(vm, 1);
	final b = Wren.getSlotDouble(vm, 2);
	Wren.setSlotDouble(vm, 0, a + b);
}

function instance(vm:cpp.Star<wren.native.WrenVM>) {
	final ptr = Wren.getSlotForeign(vm, 0);
	final point = cpp.Native.get((cast ptr:cpp.Star<Point>));
	if(point == null) {
		throw 'invalid instance';
	} else {
		// point.print();
	}

}

function allocatePoint(vm:cpp.Star<wren.native.WrenVM>) {
	var point = new Point();
	Wren.setSlotNewForeignDynamic(vm, 0, 0, point);
	
}

function finalizePoint(ptr:cpp.Star<cpp.Void>) {
	Wren.unroot(ptr);
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
