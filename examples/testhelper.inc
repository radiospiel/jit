here=$(cd $(dirname $0) && pwd)
export PATH=$here/../bin:$PATH


mkdir -p $here/tmp
scrub=$(mktemp -d $here/tmp/scrub.XXXXXX)
mkdir -p $scrub

before() {
  rm -rf $scrub/*
  cd $scrub
}

after() {
  :
}
