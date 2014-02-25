# The pipe2me binary to test

# A temporary workspace to run tests.
scrub=$(mktemp -d -t jit)

before() {
  mkdir -p $scrub
  cd $scrub
}

after() {
  cd ..
  rm -rf $scrub
}
