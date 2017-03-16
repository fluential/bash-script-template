#!/usr/bin/env bash
#
# So bash it is, there are few things to keep in mind:
#
# I highly recommend reading                 - http://mywiki.wooledge.org/BashGuide and http://mywiki.wooledge.org/BashFAQ
# Do NOT parse ls output                     - http://mywiki.wooledge.org/ParsingLs alternatively use find -print0 and xargs -0
# Use bash internals for string manipulation - http://tldp.org/LDP/abs/html/string-manipulation.html
# Good style guide to follow                 - https://google-styleguide.googlecode.com/svn/trunk/shell.xml
# Use [[ insetad of [ (external binary)      - http://mywiki.wooledge.org/BashFAQ/031
# Advanced error handling                    - http://fvue.nl/wiki/Bash:_Error_handling
# Use getopts instead of getopt              - http://mywiki.wooledge.org/BashFAQ/035
#
# Any resource cleanup should happen in a cleanup() function
#

set -euo pipefail

# http://mywiki.wooledge.org/BashFAQ/004
shopt -s nullglob dotglob

PROGNAME=$(basename $0)

# Provide an option to override values via env variables
: ${VAR:="default_value"}
: ${LOCK_FD:="200"}
: ${LOCK_FILE:="/var/lock/${PROGNAME}.lock"}

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] ($PROGNAME): ERROR: $@" >&2
}

status() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] ($PROGNAME): $@"
}

lock() {
  eval "exec $LOCK_FD>$LOCK_FILE"
  flock -n $LOCK_FD || ( err "Cannot aquire lock on ${LOCK_FILE}" ; exit 1; )
}

cleanup() {
  shopt -u nullglob dotglob
}

finish() {
  local exit_status="${1:-$?}"
  if [[ "$exit_status" -eq 0 ]]; then
    status "DONE (exit code: ${exit_status})"
  else
    err "exit code: ${exit_status}"
  fi
  cleanup
  exit $exit_status
}

usage() {
  cat <<EOL

      USAGE

      Descriptive text saying what is the desired function of this program
      Usage: $0 [ -b build ] [ -c cleanup ]

EOL
exit 1
}

trap finish SIGHUP SIGINT SIGQUIT SIGTERM ERR

if [ "$#" -lt 1 ]; then
  usage
fi

while getopts ":bc" opt; do
  case "$opt" in
    b)
      lock
      status '-b invoked'
      shift
    ;;
    c)
      lock
      status '-c option invoked'
      shift
    ;;
    *)
      usage
    ;;
  esac
done
finish
