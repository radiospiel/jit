#!/usr/bin/env node

function fib(n) {
	return n < 2 ? n : fib(n-2) + fib(n-1);
}

n = 20
if(process.argv[2]) {
	n = parseInt(process.argv[2]);
}

console.log(fib(n));
process.exit();
