#!/bin/bash

set -e

# Add kibana as command if needed
if [[ "$1" == -* ]]; then
  set -- kibana "$@"
fi

# Run as user "kibana" if the command is "kibana"
if [ "$1" = 'kibana' ]; then
  systemctl daemon-reload
  systemctl enable iptables
  systemctl restart iptables

  $SED -i "s/EL_SERVER_IP/ELASTIC_IP/g" /opt/kibana/config/kibana.yml

  set -- gosu kibana tini; nginx & -- "$@"
fi

exec "$@"

