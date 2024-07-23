package ;

import wren.native.Wren;
import wren.native.WrenVM;
import wren.native.WrenHandle;
import wren.native.WrenConfiguration;
import wren.native.WrenForeignMethodFn;
import wren.native.WrenForeignClassMethods;
import wren.native.WrenLoadModuleResult;
import wren.native.WrenInterpretResult;

@:asserts
class Native {
	public function new() {}
	
	public function test() {
		final vm = create();
		
		final file:String = sys.io.File.getContent("tests/script.wren");
		final result = Wren.interpret(vm, 'main', file);
		
		switch result {
			case WREN_RESULT_COMPILE_ERROR: trace('WREN_RESULT_COMPILE_ERROR');
			case WREN_RESULT_RUNTIME_ERROR: trace('WREN_RESULT_RUNTIME_ERROR');
			case WREN_RESULT_SUCCESS: trace('WREN_RESULT_SUCCESS');
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
		asserts.assert(Wren.getSlotType(vm, 0) == WREN_TYPE_NUM);
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
		final conf = WrenConfiguration.init();
		conf.writeFn = cpp.Callable.fromStaticFunction(writeFn);
		conf.errorFn = cpp.Callable.fromStaticFunction(errorFn);
		conf.bindForeignMethodFn = cpp.Callable.fromStaticFunction(bindForeignMethodFn);
		conf.bindForeignClassFn = cpp.Callable.fromStaticFunction(bindForeignClassFn);
		conf.loadModuleFn = cpp.Callable.fromStaticFunction(loadModuleFn);
		return Wren.newVM(conf);
	}
}


function writeFn(vm:cpp.Star<wren.native.WrenVM>, text:cpp.ConstCharStar) {
	Sys.print((text:String));
}

function errorFn(vm:cpp.Star<wren.native.WrenVM>, type:wren.native.WrenErrorType, module:cpp.ConstCharStar, line:Int, message:cpp.ConstCharStar) {
	Sys.println('$type, ${(module:String)}, $line, ${(message:String)}');
}

function bindForeignMethodFn(
	vm:cpp.Star<wren.native.WrenVM>,
	module:cpp.ConstCharStar,
	className:cpp.ConstCharStar,
	isStatic:Bool,
	signature:cpp.ConstCharStar
):wren.native.WrenForeignMethodFn {
	if(module == 'main' && className == 'Call' && isStatic && signature == 'add(_,_)') {
		return cpp.Function.fromStaticFunction(add);
	}
	if(module == 'main' && className == 'Point' && signature == 'print()') {
		return cpp.Function.fromStaticFunction(instance);
	}
	return null;
}

function bindForeignClassFn(
	vm:cpp.Star<wren.native.WrenVM>,
	module:cpp.ConstCharStar,
	className:cpp.ConstCharStar
):wren.native.WrenForeignClassMethods {
	trace('bindForeignClass', (module:String), (className:String));
	final methods = wren.native.WrenForeignClassMethods.init();
	
	if(module == 'main' && className == 'Point') {
		methods.allocate = cpp.Callable.fromStaticFunction(allocatePoint);
		methods.finalize = cpp.Callable.fromStaticFunction(finalizePoint);
	}
	
	return methods;
}

function loadModuleFn(
	vm:cpp.Star<wren.native.WrenVM>,
	name:cpp.ConstCharStar
	):wren.native.WrenLoadModuleResult {
		final name:String = name; // cast to haxe string
		
		return WrenLoadModuleResult.make('class ${capitalCase(name)} { static name { "Module: $name" } }');
		
		// final result = WrenLoadModuleResult.init();
		// result.source = 'class ${capitalCase(name)} { static name { "Module: $name" } }';
		// cpp.Native.set((cast result.userData:cpp.Star<String>), name);
		// TODO: may need to retain the source string in GC and free it in the onComplete callback
		// return result;
	}

inline function capitalCase(v:String) {
	return v.charAt(0).toUpperCase() + v.substr(1);
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
	final point = new Point();
	Wren.setSlotNewForeignDynamic(vm, 0, 0, point);
	
}

function finalizePoint(ptr:cpp.Star<cpp.Void>) {
	Wren.unroot(ptr);
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
