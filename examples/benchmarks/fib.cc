#!/usr/bin/env jit.cc

#include <stdio.h>
#include <stdlib.h>

long long fib(int n) {
	if(n < 2) return n;
	return fib(n-2) + fib(n-1);
}

int main(int argc, char** argv) {
	int n = 20;
	if(argv[1]) n = atoi(argv[1]);
	printf("%lld\n", fib(n));
	return 0;
}
