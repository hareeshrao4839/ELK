# Kibana container
FROM bbania/centos:base
MAINTAINER "Bart Bania" <contact@bartbania.com>

RUN yum -q -y install nginx httpd-tools iptables-services git sshpass
RUN yum clean all

# Setup gosu for easier command execution
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -q -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
    && curl -q -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu

# Add Tini
ENV TINI_VERSION v0.9.0
RUN set -x && \
    wget -q -O /usr/local/bin/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
    wget -q -O /usr/local/bin/tini.asc https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini.asc && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5 && \
    gpg --verify /usr/local/bin/tini.asc && \
    rm -r "$GNUPGHOME" /usr/local/bin/tini.asc && \
    chmod +x /usr/local/bin/tini

COPY ./iptables /etc/sysconfig/iptables
COPY ./entrypoint.sh ./init.sh /
COPY ./topbeat.template.json ./filebeat.template.json ./packetbeat.template.json ./kibana.yml ./load.sh /tmp/
COPY ./dashboards /tmp/dashboards
COPY ./nginx.conf /etc/nginx/
COPY ./kibana.conf /etc/nginx/conf.d/
RUN chmod +x /tmp/load.sh /init.sh /entrypoint.sh

RUN groupadd -g 1005 kibana && \
    useradd -u 1005 -g 1005 kibana && \
    mkdir /opt/kibana

WORKDIR /tmp
RUN wget -q https://download.elastic.co/kibana/kibana/kibana-4.4.1-linux-x64.tar.gz
RUN tar xf kibana-4.4.1-linux-x64.tar.gz && \
    cp -r kibana*/* /opt/kibana && \
    cp kibana.yml /opt/kibana/config/kibana.yml && \
    chown -R kibana: /opt/kibana && \
    rm -rf kibana*

ENV PATH /opt/kibana/bin:$PATH

VOLUME /root /opt/kibana/config /etc/nginx

EXPOSE 22 80 443 5044 9200

ENTRYPOINT ["/entrypoint.sh"]
CMD ["kibana"]

