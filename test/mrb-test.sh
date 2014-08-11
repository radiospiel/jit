#!/usr/bin/env roundup
describe "test jit mrb mode"

HERE=$(dirname $1)
PATH=$(cd $HERE/.. && pwd)/bin:$PATH

# verify parameter passing
it_works_with_mrb() {
  echo $PATH

  # rebuild and run the go test script
  welcome=$($HERE/mrb.jit)
  test "$welcome" = "Hello jitted world!"
}
