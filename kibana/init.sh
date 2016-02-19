#!/bin/bash

set -e

CURL=`which curl`
SED=`which sed`

ELASTIC_IP='ELK_SERVER_IP'

if [ "$1" = 'init' ]; then
  #Elasticsearch IP
  #$SED -i "s/EL_SERVER_IP/ELASTIC_IP/g" /opt/kibana/config/kibana.yml

  #Add templates
  $CURL -XPUT "http://${ELASTIC_IP}:9200/_template/filebeat?pretty" -d@/tmp/filebeat.template.json 
  $CURL -XPUT "http://${ELASTIC_IP}:9200/_template/topbeat?pretty" -d@/tmp/topbeat.template.json 
  $CURL -XPUT "http://${ELASTIC_IP}:9200/_template/packetbeat?pretty" -d@/tmp/packetbeat.template.json 
  cd /tmp; ./load.sh
fi

exec "$@"

