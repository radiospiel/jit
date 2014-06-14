#!/usr/bin/env roundup
describe "test jit go mode"

HERE=$(dirname $1)
PATH=$(cd $HERE/.. && pwd)/bin:$PATH

# verify parameter passing
it_works_with_go() {
  # clean the compiled script, if it exists
  jit --clear $HERE/go.jit
  
  # rebuild and run the go test script
  welcome=$($HERE/go.jit)
  test "$welcome" = "jit.go says hi"

  # rerun the go test script
  welcome=$($HERE/go.jit)
  test "$welcome" = "jit.go says hi"
}
