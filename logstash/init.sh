#!/bin/bash

set -e

if [ "$1" = 'init' ]; then
  #Start services
  systemctl daemon-reload
  systemctl enable iptables
  chkconfig logstash on
  systemctl restart iptables
  sed -i "s/Extensions for a typical CA/a subjectAltName = IP: LO_SERVER_IP" /etc/pki/tls/openssl.cnf
  openssl req -config /etc/pki/tls/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:4096 -keyout /etc/pki/tls/private/logstash-forwarder.key -out /etc/pki/tls/certs/logstash-forwarder.crt
  sshpass -p "EL_SERVER_PASS" ssh-copy-id -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no EL_SERVER_IP
  sshpass -p "KI_SERVER_PASS" ssh-copy-id -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no KI_SERVER_IP
  scp -i /root/.ssh/id_rsa.pub -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /etc/pki/tls/certs/logstash-forwarder.crt EL_SERVER_IP:/etc/pki/tls/certs/logstash-forwarder.crt
  scp -i /root/.ssh/id_rsa.pub -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /etc/pki/tls/certs/logstash-forwarder.crt KI_SERVER_IP:/etc/pki/tls/certs/logstash-forwarder.crt
fi

exec "$@"

