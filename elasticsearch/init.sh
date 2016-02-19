#!/bin/bash

set -e

if [ "$1" = 'init' ]; then
  #Start services
  systemctl daemon-reload
fi

exec "$@"

