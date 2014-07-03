# jit.inc: helper for jit.$STRATEGY jitted scripts.
#
# jit.inc sets the following values:
#
# - SOURCE:  the full path of the source file.
# - PREPROCESSED_SOURCE: the full path of the preprocessed source file,
#            i.e. without the leading #! line
# - JITOS:   the host operating system
# - JITARCH: the host architecture.
#
# Note: JITARCH and JITOS values match the values expected in GOOS and GOARCH.

set -eu

arg0=$0

usage() {
  local arg0=$0
  
  cat >&2 <<-USAGE
$0 translates a script into a binary when the script is first run. It is usually embedded
into scripts via a header like this:

!#/usr/bin/env $(basename "$0")
USAGE

exit 127
}

log() {
  echo "$@" >&2
}

# The script needs a single argument.
[ "${1:-}" ] || usage "$0"

SOURCE="${1:-}"
shift

# -- get platform info --------------------------------------------------------

if [ "${JITOS:-}" ]; then
  :
elif [ "${GOHOSTARCH:-}" ]; then
  GOHOSTARCH="amd64"
  GOHOSTOS="darwin"

  JITOS=$GOHOSTOS
  JITARCH=$GOHOSTARCH
else
  JITOS=$(uname -s | tr A-Z a-z)

  case $(uname -m) in
    x86_64) JITARCH=amd64 ;;
  esac
fi

# -- determine paths ----------------------------------------------------------

strategy=$(basename $0)
source_basename="$(basename "$SOURCE")"
# Get the full path to the SOURCE.
FULL_SOURCE=$(cd "$(dirname "$SOURCE")" && pwd)/"$source_basename"

# Get the path relative to the HOME directory.
RELATIVE_SOURCE="${FULL_SOURCE#$HOME}"

dist_binary="$(dirname "$FULL_SOURCE")/$strategy.bin/$source_basename.$JITOS.$JITARCH"
local_binary=$HOME/.jit/$RELATIVE_SOURCE.$JITOS.$JITARCH

# -- build and run helpers ----------------------------------------------------

# If a path for binaries of a given strategy exist next to the source,
# we (try to) build the binary there. This allows to share a binary in
# a specific place.

function is_up_to_date() {
  [ -x "$1" ] && ! [ "$FULL_SOURCE" -nt "$1" ]
}

function build_binary() {
  BINARY=$1
  if ! [ -x "$(dirname $BINARY)" ]; then
    if [[ $JIT_DIST_BUILD != y ]]; then 
      log "Cannot build into $(dirname $BINARY)"
      return 1
    fi
    mkdir -p "$(dirname $BINARY)"
  fi

  log "Building $BINARY"
  
  JIT_TMPDIR=$(mktemp -d -t $strategy.XXXXXX)
  function cleanup_temp_files() {
    rm -rf $JIT_TMPDIR
  }
  trap cleanup_temp_files EXIT

  PREPROCESSED_SOURCE="$JIT_TMPDIR/$source_basename.$JIT_EXT"
  cat ${SOURCE} | sed -e '1,2d' > $PREPROCESSED_SOURCE
  if ! build ; then
    exit 1
  fi
  
  cleanup_temp_files
  return 0
}

is_up_to_date "$dist_binary"  && exec -a $SOURCE "$dist_binary" "$@"
is_up_to_date "$local_binary" && exec -a $SOURCE "$local_binary" "$@"

if [[ ${JIT_DIST_BUILD:-y} = y ]] ; then
  JIT_DIST_BUILD=y 
  build_binary "$dist_binary"  && exec -a $SOURCE "$dist_binary" "$@"
fi

JIT_DIST_BUILD=n
build_binary "$local_binary" && exec -a $SOURCE "$local_binary" "$@"
