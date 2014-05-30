#!/bin/bash
set -e

if [ -z "$3" ]; then
  echo "jit.flex compiles a source file into a binary using cc." >&2
  exit 127
fi

ORIG_SOURCE="$1"; shift
SOURCE="$1"; shift
BINARY="$1"; shift

FLEX_LIB=-ll

flex -o ${BINARY}.c ${SOURCE} &&
cc -o $BINARY -I$(dirname $ORIG_SOURCE) -Wall ${BINARY}.c -O2 $@ $FLEX_LIB &&
rm ${BINARY}.c
