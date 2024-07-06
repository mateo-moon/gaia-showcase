#!/usr/bin/env sh
set -e

if [ "$1" = "pruned" ] && [ "$2" = "start" ]; then
  echo "Initializing pruned node..."
  /usr/local/bin/init_pruned.sh
  shift 1
fi
exec gaiad "$@"
