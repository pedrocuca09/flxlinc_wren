import wren.Wren;
import wren.WrenVM;
import wren.WrenHandle;
import wren.WrenConfiguration;
import wren.WrenForeignMethodFn;
import wren.WrenForeignClassMethods;

class Test {
	function new() {
		
		final conf = WrenConfiguration.init();
		conf.writeFn = cpp.Callable.fromStaticFunction(writeFn);
		conf.errorFn = cpp.Callable.fromStaticFunction(errorFn);
		conf.bindForeignMethodFn = cpp.Callable.fromStaticFunction(bindForeignMethodFn);
		conf.bindForeignClassFn = cpp.Callable.fromStaticFunction(bindForeignClassFn);
		final vm:WrenVM = Wren.newVM(conf);
	
		final file:String = sys.io.File.getContent("test/script.wren");
		final result = Wren.interpret(vm, 'main',  file);
		
		switch result {
			case WREN_RESULT_SUCCESS: trace('WREN_RESULT_SUCCESS');
			case WREN_RESULT_COMPILE_ERROR: trace('WREN_RESULT_COMPILE_ERROR');
			case WREN_RESULT_RUNTIME_ERROR: trace('WREN_RESULT_RUNTIME_ERROR');
		}
	
		Wren.ensureSlots(vm, 1);
		Wren.getVariable(vm, "main", "Call", 0);
		final callClass:WrenHandle = Wren.getSlotHandle(vm, 0);
	
		final noParams:WrenHandle = Wren.makeCallHandle(vm, "noParams");
		final zero:WrenHandle = Wren.makeCallHandle(vm, "zero()");
		final one:WrenHandle = Wren.makeCallHandle(vm, "one(_)");
		final add:WrenHandle = Wren.makeCallHandle(vm, "add(_,_)");
		final point:WrenHandle = Wren.makeCallHandle(vm, "point()");
		final stress:WrenHandle = Wren.makeCallHandle(vm, "stress()");
	
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
		
		
		Wren.ensureSlots(vm, 1);
		Wren.setSlotHandle(vm, 0, callClass);
		Wren.call(vm, point);
		
		for(i in 0...100) {
			Wren.ensureSlots(vm, 1);
			Wren.setSlotHandle(vm, 0, callClass);
			final result = Wren.call(vm, stress);
			Wren.collectGarbage(vm);
			debug();
		}
	
		Wren.releaseHandle(vm, callClass);
		Wren.releaseHandle(vm, noParams);
		Wren.releaseHandle(vm, zero);
		Wren.releaseHandle(vm, one);
		Wren.releaseHandle(vm, add);
		Wren.releaseHandle(vm, point);
		Wren.releaseHandle(vm, stress);
	
		debug();
		trace('free vm start');
		Wren.freeVM(vm);
		trace('free vm done');
		debug();
	}
	
	static function debug() {
		// trace('run gc'); cpp.vm.Gc.run(false);
		// trace('compact'); cpp.vm.Gc.compact();
		trace('MEM_INFO_USAGE', (cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_USAGE):UInt));
		trace('MEM_INFO_RESERVED', (cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_RESERVED):UInt));
		trace('MEM_INFO_CURRENT', (cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_CURRENT):UInt));
		trace('MEM_INFO_LARGE', (cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_LARGE):UInt));
	}

	static function main() {
		
		final test = new Test();
		// test.writeFn((null:Any), (null:Any));
		
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