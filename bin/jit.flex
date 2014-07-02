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
  flex -o ${PREPROCESSED_SOURCE}.c ${PREPROCESSED_SOURCE} &&
  cc -o $BINARY -I$(dirname "$SOURCE") -O2 \
          -Wall \
          -Wno-unused-function \
          -Wno-unneeded-internal-declaration \
          ${PREPROCESSED_SOURCE}.c -ll
}

JIT_EXT=fl
jit_inc=$(echo "$0" | sed 's-[.][^.]*$-.inc-')
. "$jit_inc"
