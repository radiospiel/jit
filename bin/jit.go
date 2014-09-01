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
  # -- prepare go packages if needed.
  if [ -z "${GOPATH:-}" ]; then
    export GOPATH=$HOME/jit.golang
  fi

  local packages=$(
    < $SOURCE grep "// JIT_GO_PACKAGES="     | sed "sx// JIT_GO_PACKAGES=xx"
  )

  if [ "$packages" ]; then
  for package in "$packages" ; do
    go get $package
  done
  fi

  if [[ $JIT_DIST_BUILD = y ]]; then
    log "Building for distribution"
    local platforms=${JIT_GO_TARGET_PLATFORMS:-darwin.amd64 linux.amd64 linux.arm linux.386}
  else
    local platforms=$JITOS.$JITARCH
  fi

  local binary_base=$(echo $BINARY | sed 's-[.][^.]*[.][^.]*$--')

  local platform
  for platform in $platforms ; do
    local goos=$(cut -d . -f 1 <<<$platform)
    local goarch=$(cut -d . -f 2 <<<$platform)
	
	if ! env GOARCH=$goarch GOOS=$goos go build -o $binary_base.$goos.$goarch $PREPROCESSED_SOURCE ; then
		exit 1
	fi

	log Built $binary_base.$goos.$goarch
  done
}

JIT_EXT=go
jit_inc=$(echo "$0" | sed 's-[.][^.]*$-.inc-')
. "$jit_inc"
