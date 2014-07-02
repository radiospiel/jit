#!/usr/bin/env roundup
describe "test basic jit operation"

HERE=$(dirname $1)
PATH=$(cd $HERE/.. && pwd)/bin:$PATH

# verify parameter passing
it_gets_args() {
  r=$($HERE/args.jit)
  test "$r" = "1"

  r=$($HERE/args.jit a b c)
  test "$r" = "4 a b c"

  r=$($HERE/args.jit a "b c" dd)
  test "$r" = "4 a b c dd"
}
