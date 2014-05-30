#!/bin/bash
set -e

if [ -z "$3" ]; then
  echo "jit.cc compiles a source file into a binary using cc." >&2
  exit 127
fi

ORIG_SOURCE="$1"; shift
SOURCE="$1"; shift
BINARY="$1"; shift

# -x: treat file as C
cc -o $BINARY -I$(dirname $ORIG_SOURCE) -Wall -x c $SOURCE -O2 $@
