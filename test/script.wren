

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

	static point() {
		var p = Point.new()
		p.print()
	}
	
	static stress() {
		var total = 10000
		System.print("stress start (%(total))")
		for (i in 1..total) {
			if(i % 2000 == 0) {
				System.print("checkpoint %(i)")
			}
			alloc()
		}
		System.print("stress end")
	}
	
	static alloc() {
		var p = Point.new()
		p.print()
	}
	
	foreign static add(a, b)

}

foreign class Point {
	construct new() {}
	foreign print()
}