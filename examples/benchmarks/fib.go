#!/usr/bin/env jit.go

package main;

import "os"
import "fmt"
import "strconv"

func fib(n int) int {
	if n < 2 {
   	 return n
	}
	
	return fib(n-2) + fib(n-1)
}

func main() {
	var err error
	var n int
	if len(os.Args) >= 2 {
		n, err = strconv.Atoi(os.Args[1])
		if err != nil {
			n = 0
		}
	}
	if n == 0 { 
		n = 20 
	}
	
	fmt.Fprintf(os.Stdout, "%d\n", fib(n))
}
