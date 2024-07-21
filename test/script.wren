

class Call {

	static noParams {
		System.print("noParams")
	}

	static zero() {
		System.print("zero")
	}

	static one(one) {
		System.print("one %(one)")
	}

	static testPoint() {
		var point = Point.new()
		point.print()
		
	}
	
	foreign static add(a, b)

}

foreign class Point {
  construct new() {}
  foreign print()
}