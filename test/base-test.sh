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

# verify parameter passing
it_rebuilds_binaries_when_changed() {
  # clean the compiled script, if it exists
  jit --clear $HERE/rebuild.jit
  
  cp $HERE/rebuild0.jit $HERE/rebuild.jit
  touch -A -010000 $HERE/rebuild.jit
  r=$($HERE/rebuild.jit)
  test "$r" = "rebuild original"

  cp $HERE/rebuild1.jit $HERE/rebuild.jit
  touch $HERE/rebuild.jit
  r=$($HERE/rebuild.jit)
  test "$r" = "rebuild changed"

  # clean the compiled script, if it exists
  jit --clear $HERE/rebuild.jit
  
  cp $HERE/rebuild0.jit $HERE/rebuild.jit
  touch -A -010000 $HERE/rebuild.jit
  r=$($HERE/rebuild.jit)
  test "$r" = "rebuild original"

  cp $HERE/rebuild1.jit $HERE/rebuild.jit
  touch $HERE/rebuild.jit
  r=$($HERE/rebuild.jit)
  test "$r" = "rebuild changed"
}
