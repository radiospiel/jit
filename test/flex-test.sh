#!/usr/bin/env roundup
describe "test jit flex mode"

HERE=$(dirname $1)
PATH=$(cd $HERE/.. && pwd)/bin:$PATH


# verify parameter passing
it_works_with_flex() {
  # rebuild and run the c test script
  result=$(echo "foobar" | $HERE/flex.jit)
  test "$result" = "ooa"
}
