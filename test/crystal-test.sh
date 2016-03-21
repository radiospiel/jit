#!/usr/bin/env roundup
describe "test jit crystal mode"

HERE=$(dirname $1)
PATH=$(cd $HERE/.. && pwd)/bin:$PATH

it_works_with_crystal() {
  # rebuild and run the go test script
  welcome=$($HERE/crystal.jit)
  test "$welcome" = "jit.crystal says hi"

  # rerun the go test script
  welcome=$($HERE/crystal.jit)
  test "$welcome" = "jit.crystal says hi"
}
