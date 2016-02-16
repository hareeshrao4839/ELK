#!/bin/bash

set -e

if [ "$1" = 'init' ]; then
  #Start services
  systemctl daemon-reload
  systemctl enable iptables
  systemctl enable elasticsearch
  systemctl restart iptables
fi

exec "$@"

