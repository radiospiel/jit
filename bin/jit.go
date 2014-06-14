#!/bin/bash
set -e

if [ -z "$3" ]; then
  echo "jit.go compiles a source file into a binary using go." >&2
  exit 127
fi

ORIG_SOURCE="$1"; shift
SOURCE="$1"; shift
BINARY="$1"; shift

# -x: treat file as C
set -xv 
mv $SOURCE $SOURCE.go
go build -o $BINARY $SOURCE.go
