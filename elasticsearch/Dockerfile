# Elasticsearch container
FROM bbania/centos:base
MAINTAINER "Bart Bania" <contact@bartbania.com>

RUN yum install -q -y iptables-services git sshpass
RUN yum clean all

WORKDIR /tmp
RUN wget -q --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -O jdk-8u73-linux-x64.rpm "http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.rpm" && \
    yum localinstall -q -y jdk-8u73-linux-x64.rpm
RUN wget -q https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.2.0/elasticsearch-2.2.0.rpm && \
    yum localinstall -q -y elasticsearch-2.2.0.rpm
RUN rm -rf elastic* jdk*

COPY ./iptables /etc/sysconfig/iptables
COPY ./init.sh /
COPY ./elasticsearch.yml /etc/elasticsearch/

VOLUME /root /etc/elasticsearch

EXPOSE 9200 9300

