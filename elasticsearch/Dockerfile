# Elasticsearch container
FROM bbania/centos:base
MAINTAINER "Bart Bania" <contact@bartbania.com>

ENV LANG en_US.utf8

RUN yum install -q -y iptables-services git sshpass python-devel python-setuptools python-pip
RUN yum clean all

# Setup gosu for easier command execution
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -q -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
    && curl -q -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu

WORKDIR /tmp
RUN wget -q --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -O jdk-8u73-linux-x64.rpm "http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.rpm" && \
    yum localinstall -q -y jdk-8u73-linux-x64.rpm
RUN wget -q https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.2.0/elasticsearch-2.2.0.rpm && \
    yum localinstall -q -y elasticsearch-2.2.0.rpm && \
     rm -rf elastic* jdk*

RUN set -ex \
    && for path in \
        /usr/share/elasticsearch/data \
        /usr/share/elasticsearch/logs \
        /usr/share/elasticsearch/config \
        /usr/share/elasticsearch/config/scripts \
    ; do \
        mkdir -p "$path"; \
        chown -R elasticsearch:elasticsearch "$path"; \
    done

RUN easy_install -q -U setuptools && \
    pip -q install elasticsearch-curator && \
    pip -q install supervisor

# Config files
COPY ./supervisord.conf /etc/supervisord.conf
COPY ./iptables /etc/sysconfig/iptables
COPY ./init.sh /
COPY ./entrypoint.sh /

COPY ./elasticsearch.yml ./logging.yml /usr/share/elasticsearch/config/
RUN mkdir /var/log/supervisor
RUN chown -R elasticsearch: /usr/share/elasticsearch /etc/supervisord.conf

ENV PATH /usr/share/elasticsearch/bin:$PATH
ENV ES_HEAP_SIZE=2g

VOLUME /root /etc/elasticsearch /var/lib/elasticsearch

EXPOSE 9200 9300

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "elasticsearch", "-Des.default.path.logs=/var/log/elasticsearch" ]

