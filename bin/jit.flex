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

  flex -o ${PREPROCESSED_SOURCE}.c ${PREPROCESSED_SOURCE} && (
  if [ $os == LINUX ] && type -p tcc > /dev/null ; then
    tcc -o $BINARY -I$(dirname "$SOURCE") -O2 \
            -Wall \
            -Wno-unused-function \
            -Wno-unneeded-internal-declaration \
            $flags \
            ${PREPROCESSED_SOURCE}.c -ll
  else
    cc -o $BINARY -I$(dirname "$SOURCE") -O2 \
            -Wall \
            -Wno-unused-function \
            -Wno-unneeded-internal-declaration \
            $flags \
            ${PREPROCESSED_SOURCE}.c -ll
  fi
  )
}

JIT_EXT=fl
jit_inc=$(echo "$0" | sed 's-[.][^.]*$-.inc-')
. "$jit_inc"
