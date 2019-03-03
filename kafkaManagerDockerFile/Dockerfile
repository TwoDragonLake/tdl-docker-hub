FROM jdk8:v1

MAINTAINER CeaserWang <ceaserwang@outlook.com>


ENV INSTALL_DIR="/data" \
  KM_VERSION=1.3.3.22 \
  KM_CONFIGFILE=${INSTALL_DIR}/kafka-manager-${KM_VERSION}/conf/application.conf


COPY kafkaManager-entrypoint.sh  /data/


RUN git clone https://github.com/TwoDragonLake/kafka-manager.git  ${INSTALL_DIR}/kafka-manager \
    && cd  ${INSTALL_DIR}/kafka-manager \
    && git checkout ${KM_VERSION}  \
    && ./sbt clean dist  \
    && unzip -d   ${INSTALL_DIR}/  ${INSTALL_DIR}/kafka-manager/target/universal/kafka-manager-${KM_VERSION}.zip \
    && cd ${INSTALL_DIR}/ \
    && os2unix   ${INSTALL_DIR}/kafka-entrypoint.sh \
    && rm -rf ${INSTALL_DIR}/kafka-manager \
    && yum clean all

EXPOSE 9000

WORKDIR /data

CMD ["/data/kafkaManager-entrypoint.sh"]
