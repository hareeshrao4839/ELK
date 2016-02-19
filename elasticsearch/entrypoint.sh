#!/bin/bash

set -e

if [ "${1:0:1}" = '-' ]; then
  set -- elasticsearch "$@"
fi

if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
  set -- gosu elasticsearch "$@"
fi

exec "$@"
