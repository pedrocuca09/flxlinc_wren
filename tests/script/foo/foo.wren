import "bar/bar" for Bar

class Foo {
	static test() {
		return "Foo#test %(Bar.test())"
	}
}