FROM jdk8:v1

MAINTAINER CeaserWang <ceaserwang@outlook.com>

ARG install_dir="/data"
ARG kafka_version=2.1.0
ARG scala_version=2.11

ENV KAFKA_VERSION=2.1.0 \
    SCALA_VERSION=2.11


WORKDIR /data

COPY kafka-entrypoint.sh  /data/

RUN wget -P ${INSTALL_DIR}/  http://mirrors.tuna.tsinghua.edu.cn/apache/kafka/${kafka_version}/kafka_${scala_version}-${kafka_version}.tgz \
    && tar -xzvf ${kafka_version}/kafka_${scala_version}-${kafka_version}.tgz
    && rm -rf ${kafka_version}/kafka_${scala_version}-${kafka_version}.tgz
    && yum -y install dos2unix \
    && mkdir  /tmp/kafka/ \
 	  && dos2unix  /data/kafka-entrypoint.sh


ENTRYPOINT ["/data/kafka-entrypoint.sh"]
CMD ["/data/zookeeper-3.4.12/bin/zkServer.sh"]
