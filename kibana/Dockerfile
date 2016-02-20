# Kibana container
FROM bbania/centos:base
MAINTAINER "Bart Bania" <contact@bartbania.com>

ENV LANG en_US.utf8

RUN yum -q -y install unzip nginx httpd-tools iptables-services git sshpass
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

RUN groupadd -g 1005 kibana && \
    useradd -u 1005 -g 1005 kibana && \
    mkdir /opt/kibana

WORKDIR /tmp
RUN wget -q https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip && \
    unzip -qq beats-dashboards-*.zip && \
    rm -rf beats-dashboards-*.zip
RUN wget -q https://download.elastic.co/kibana/kibana/kibana-4.4.1-linux-x64.tar.gz
RUN tar xf kibana-4.4.1-linux-x64.tar.gz && \
    cp -r kibana*/* /opt/kibana && \
    rm -rf kibana*

COPY ./iptables /etc/sysconfig/iptables
COPY ./entrypoint.sh ./init.sh /
COPY ./topbeat.template.json ./filebeat.template.json ./packetbeat.template.json /tmp/
COPY ./nginx.conf /etc/nginx/
COPY ./kibana.conf /etc/nginx/conf.d/
COPY ./kibana.yml /opt/kibana
COPY ./load.sh /tmp/beats-dashboards-1.1.0/
RUN chown -R kibana: /opt/kibana
RUN chmod +x /init.sh /entrypoint.sh

ENV PATH /opt/kibana/bin:$PATH

VOLUME /root /opt/kibana/config /etc/nginx

EXPOSE 22 80 443

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "kibana" ]

