#!/usr/bin/env roundup
describe "test jit mrb mode"

HERE=$(dirname $1)
PATH=$(cd $HERE/.. && pwd)/bin:$PATH

it_works_with_mrb() {
  # rebuild and run the mrb test script
  prog=$($HERE/mrb.jit)
  test "$prog" = "Hello jitted world!"
}

it_gets_arguments() {
  # rebuild and run the mrb test script
  prog=$($HERE/mrb.echo.jit foo bar baz)
  test "$prog" = "mrb.echo.jit:foo bar baz"
}

it_sets_exitcode() {
  # rebuild and run the mrb test script
  if $HERE/mrb.exit.jit 1 ; then
    false Exit code must be 1
  else
    test $? = 1
  fi

  if $HERE/mrb.exit.jit 2 ; then
    false Exit code must be 2
  else
    test $? = 2
  fi

  $HERE/mrb.exit.jit 0
}
