# Kibana container
FROM bbania/centos:base
MAINTAINER "Bart Bania" <contact@bartbania.com>

RUN yum -q -y install nginx httpd-tools iptables-services git
RUN yum clean all

COPY ./iptables /etc/sysconfig/iptables
COPY ./init.sh /
COPY ./topbeat.template.json ./filebeat.template.json ./packetbeat.template.json ./kibana.yml ./load.sh /tmp/
COPY ./dashboards /tmp/dashboards
COPY ./nginx.conf /etc/nginx/
COPY ./kibana.conf /etc/nginx/conf.d/
RUN chmod +x /tmp/load.sh /init.sh

RUN groupadd -g 1005 kibana && \
    useradd -u 1005 -g 1005 kibana && \
    mkdir /opt/kibana
COPY ./kibana-init /etc/init.d/kibana
COPY ./kibana-default /etc/default/kibana
RUN chmod +x /etc/init.d/kibana
WORKDIR /tmp
RUN wget -q https://download.elastic.co/kibana/kibana/kibana-4.4.1-linux-x64.tar.gz
RUN tar xf kibana-4.4.1-linux-x64.tar.gz && \
    cp -r kibana*/* /opt/kibana && \
    cp kibana.yml /opt/kibana/config/kibana.yml && \
    chown -R kibana: /opt/kibana && \
    rm -rf kibana*

VOLUME /root /opt/kibana/config /etc/nginx

EXPOSE 22 80 443 5044 9200

