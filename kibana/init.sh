#!/bin/bash

set -e

CURL=`which curl`
ELASTIC_IP='ELK_SERVER_IP'

if [ "$1" = 'init' ]; then
  #Start services
  systemctl daemon-reload
  systemctl enable iptables
  systemctl enable nginx
  chkconfig kibana on
  systemctl restart iptables
  systemctl restart nginx
  /etc/init.d/kibana restart

  #Add templates
  cd /tmp; ./load.sh
  $CURL -XPUT "http://${ELASTIC_IP}:9200/_template/filebeat?pretty" -d@/tmp/filebeat.template.json 
  $CURL -XPUT "http://${ELASTIC_IP}:9200/_template/topbeat?pretty" -d@/tmp/topbeat.template.json 
  $CURL -XPUT "http://${ELASTIC_IP}:9200/_template/packetbeat?pretty" -d@/tmp/packetbeat.template.json 
fi

exec "$@"

