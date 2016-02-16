# Logstash container
FROM bbania/centos:base
MAINTAINER "Bart Bania" <contact@bartbania.com>

RUN yum install -q -y iptables-services git sshpass
RUN yum clean all

WORKDIR /tmp
RUN wget -q --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.rpm" && \
    yum localinstall -q -y jdk-8u73-linux-x64.rpm
RUN wget -q https://download.elastic.co/logstash/logstash/packages/centos/logstash-2.2.1-1.noarch.rpm && \
    yum localinstall -q -y logstash-2.2.1-1.noarch.rpm
RUN rm -rf logstash* jdk*

# Config files
COPY ./iptables /etc/sysconfig/iptables
COPY ./init.sh /
COPY ./patterns /etc/logstash/patterns
COPY ./GeoLiteCity.dat /etc/logstash/GeoLiteCity.dat
COPY ./conf.d /etc/logstash/conf.d

VOLUME /root /etc/logstash

EXPOSE 5044

