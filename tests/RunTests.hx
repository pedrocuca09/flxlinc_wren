package ;

import tink.unit.*;
import tink.testrunner.*;

using tink.CoreApi;

class RunTests {
	static function main() {
		Runner.run(TestBatch.make([
			new Haxe(),
			new Native(),
		])).handle(Runner.exit);
	}
}