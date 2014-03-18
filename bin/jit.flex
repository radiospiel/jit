#!/bin/bash

if [ -z "$2" ]; then
  echo "jit.flex compiles a source file into a binary using flex/cc." >&2
  exit 127
fi

SOURCE="$1"; shift
BINARY="$1"; shift

FLEX_LIB=-ll

flex -o ${BINARY}.c ${SOURCE} &&
cc -o ${BINARY} ${BINARY}.c -O2 $@ $FLEX_LIB
