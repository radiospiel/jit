#!/bin/bash
#
# The "build" function below will later build a binary from a preprocessed
# source file. When "build" is called, these variables are set:
#
# - SOURCE:  the full path of the source file.
# - PREPROCESSED_SOURCE: the full path of the preprocessed source file,
#            i.e. without the leading #! line
# - BINARY:  the full path of the binary. The build function must generate
#            this file.
# - JITOS:   the host operating system
# - JITARCH: the host architecture.
#
function build() {
  local os=$(<<<$JITOS tr a-z A-Z)
  local flags=$(
    < $SOURCE grep "// JIT_CFLAGS="     | sed "sx// JIT_CFLAGS=xx"
    < $SOURCE grep "// JIT_CFLAGS_$os=" | sed "sx// JIT_CFLAGS_$os=xx"
  )

  # if [ $os == LINUX ] && type -p tcc > /dev/null ; then
  #   tcc -o $BINARY -I$(dirname "$SOURCE") -Wall -x c -O2 $flags $PREPROCESSED_SOURCE
  # else
    cc -o $BINARY -I$(dirname "$SOURCE") -Wall -x c -std=c99 -D_BSD_SOURCE -D_POSIX_SOURCE -O2 $flags $PREPROCESSED_SOURCE
  # fi
}

JIT_EXT=c
jit_inc=$(echo "$0" | sed 's-[.][^.]*$-.inc-')
. "$jit_inc"
