#!/bin/bash

set -e

CURL=`which curl`
ELASTIC_IP='ELK_SERVER_IP'

$CURL -XPUT "http://${ELASTIC_IP}:9200/_template/filebeat?pretty" -d@/tmp/filebeat.template.json 
$CURL -XPUT "http://${ELASTIC_IP}:9200/_template/topbeat?pretty" -d@/tmp/topbeat.template.json 
$CURL -XPUT "http://${ELASTIC_IP}:9200/_template/packetbeat?pretty" -d@/tmp/packetbeat.template.json 
cd /tmp/beats-dashboards-1.1.0; ./load.sh; cd /
rm -r /tmp/beats-dashboards-1.1.0

