#!/bin/bash

set -e

if [ "$1" = 'init' ]; then
  #Start services
  systemctl daemon-reload

  # Jelastic specific instructions
  #sed -i "/Extensions for a typical CA/a subjectAltName = IP: LO_SERVER_IP" /etc/pki/tls/openssl.cnf
  #openssl req -config /etc/pki/tls/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:4096 -keyout /etc/pki/tls/private/logstash-forwarder.key -out /etc/pki/tls/certs/logstash-forwarder.crt
  ssh-keygen -q -t rsa -b 4096 -N "" -f /root/.ssh/id_rsa
  chmod 600 /root/.ssh/id_rsa*
  sshpass -p "EL_SERVER_PASS" ssh-copy-id -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no EL_SERVER_IP
  sshpass -p "KI_SERVER_PASS" ssh-copy-id -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no KI_SERVER_IP
  scp -i /root/.ssh/id_rsa.pub -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /etc/pki/tls/certs/logstash-forwarder.crt EL_SERVER_IP:/etc/pki/tls/certs/logstash-forwarder.crt
  scp -i /root/.ssh/id_rsa.pub -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /etc/pki/tls/certs/logstash-forwarder.crt KI_SERVER_IP:/etc/pki/tls/certs/logstash-forwarder.crt
fi

exec "$@"

