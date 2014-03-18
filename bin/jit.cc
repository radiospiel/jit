#!/bin/bash

if [ -z "$2" ]; then
  echo "jit.cc compiles a source file into a binary using cc." >&2
  exit 127
fi

SOURCE="$1"; shift
BINARY="$1"; shift

cc -o $BINARY -x c $SOURCE -O2 $@
