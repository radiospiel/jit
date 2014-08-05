#!/usr/bin/env roundup
describe "test jit flex mode"

HERE=$(dirname $1)
PATH=$(cd $HERE/.. && pwd)/bin:$PATH

# verify parameter passing
it_works_with_flags() {
  # rebuild and run the c test script
  result=$($HERE/flags.jit)
  test "$result" = "jit says Ho"
}
