def main
	print("hello world")
	let fn = \(a:int, n:int) -> int
		count = 0
		result = 1
		while count < n
			result *= a
			result %= 65537
			++count
		return result
	zip(fn, [3, 5, 2, 16, 256, 4292], [5, 27, 8, 997, 1002, 12082]).print()
	
	let a = 0;
	let s = \() {
		a = 8;
		return 9;
	} ()