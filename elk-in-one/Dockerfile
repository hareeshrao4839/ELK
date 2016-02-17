FROM bbania/centos:base
MAINTAINER "Bart Bania" <contact@bartbania.com>

RUN yum install -q -y iptables-services git nginx httpd-tools python-devel python-setuptools python-pip gcc supervisor
RUN yum -q clean all

# supervisor, elastalert & curator
RUN easy_install -q -U setuptools &&\
    pip -q install elastalert && \
    pip -q install elasticsearch-curator

COPY ./iptables /etc/sysconfig/iptables
COPY ./init.sh /

WORKDIR /tmp
RUN wget -q --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -O jdk-8u73-linux-x64.rpm "http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.rpm" && \
    yum localinstall -q -y jdk-8u73-linux-x64.rpm

# Elasticsearch
RUN wget -q https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.2.0/elasticsearch-2.2.0.rpm && \
    yum localinstall -q -y elasticsearch-2.2.0.rpm
RUN rm -rf elastic* jdk*
COPY ./elasticsearch.yml /etc/elasticsearch/

# Logstash
RUN wget -q https://download.elastic.co/logstash/logstash/packages/centos/logstash-2.2.1-1.noarch.rpm && \
    yum localinstall -q -y logstash-2.2.1-1.noarch.rpm
RUN rm -rf logstash* jdk*
COPY ./patterns /etc/logstash/patterns
COPY ./GeoLiteCity.dat /etc/logstash/GeoLiteCity.dat
COPY ./conf.d /etc/logstash/conf.d

# Kibana
COPY ./topbeat.template.json ./filebeat.template.json ./packetbeat.template.json ./kibana.yml ./load.sh /tmp/
COPY ./dashboards /tmp/dashboards
COPY ./nginx.conf /etc/nginx/
COPY ./kibana.conf /etc/nginx/conf.d/
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
RUN chmod +x /tmp/load.sh /init.sh

# Beats
RUN wget -q https://download.elastic.co/beats/packetbeat/packetbeat-1.1.1-x86_64.rpm && \
    wget -q https://download.elastic.co/beats/topbeat/topbeat-1.1.1-x86_64.rpm && \
    wget -q https://download.elastic.co/beats/filebeat/filebeat-1.1.1-x86_64.rpm
RUN yum localinstall -q -y packetbeat-1.1.1-x86_64.rpm topbeat-1.1.1-x86_64.rpm filebeat-1.1.1-x86_64.rpm
COPY ./filebeat.yml /etc/filebeat/filebeat.yml
COPY ./packetbeat.yml /etc/packetbeat/packetbeat.yml
COPY ./topbeat.yml /etc/topbeat/topbeat.yml

VOLUME /opt/kibana/config /etc/nginx /etc/elasticsearch /etc/logstash /etc/filebeat/ /etc/packetbeat/ /etc/topbeat/

EXPOSE 22 80 443 5044 9200 9300

