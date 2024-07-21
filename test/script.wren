

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
		var total = 1000
		System.print("stress start (%(total))")
		for (i in 1..total) {
			if(i % 100 == 0) {
				System.print("checkpoint %(i)")
			}
			alloc()
		}
		System.print("stress end")
	}
	
	static alloc() {
		var p = Point.new()
	}
	
	foreign static add(a, b)

}

foreign class Point {
  construct new() {}
  foreign print()
}