#!/usr/bin/env roundup
describe "test jit mrb mode"

HERE=$(dirname $1)
PATH=$(cd $HERE/.. && pwd)/bin:$PATH

it_works_with_mrb() {
  # rebuild and run the mrb test script
  welcome=$($HERE/mrb.jit)
  test "$welcome" = "Hello jitted world!"
}

it_gets_arguments() {
  # rebuild and run the mrb test script
  welcome=$($HERE/mrb.echo.jit foo bar baz)
  test "$welcome" = "mrb.echo.jit:foo bar baz"
}
