#!/usr/bin/env luajit

function fib(n)
	if n < 2 then return n end
	return fib(n-2) + fib(n-1)
end

if arg[1] then n = tonumber(arg[1]) else n = 20 end

print(fib(n))
