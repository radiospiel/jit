#!/usr/bin/env roundup
describe "test jit C mode"

HERE=$(dirname $1)
PATH=$(cd $HERE/.. && pwd)/bin:$PATH

# verify parameter passing
it_works_with_c() {
  # rebuild and run the c test script
  welcome=$($HERE/c.jit)
  test "$welcome" = "jit says hi"

  # rerun the c test script
  welcome=$($HERE/c.jit)
  test "$welcome" = "jit says hi"
}
