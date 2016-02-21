#!/bin/bash

set -e

systemctl daemon-reload
systemctl enable iptables
systemctl restart iptables

supervisord -c /etc/supervisord.conf

