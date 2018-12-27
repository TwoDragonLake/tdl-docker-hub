FROM jdk8:v1

MAINTAINER CeaserWang <ceaserwang@outlook.com>


ARG USER_HOME_DIR="/root"
ARG INSTALL_DIR="/data"
ARG ZK_VERSION=3.4.12

COPY docker-entrypoint.sh  /data/

ENV ZK_DIR=${INSTALL_DIR}/zookeeper-${ZK_VERSION} \
		PATH=${PATH}:${ZK_DIR}/bin \
		ZOO_PORT=2181 \
		ZOO_DATA_DIR=${INSTALL_DIR}/zookeeper-${ZK_VERSION}/ZOO_DATA_DIR \
		ZOO_DATA_LOG_DIR=${INSTALL_DIR}/zookeeper-${ZK_VERSION}/ZOO_DATA_LOG_DIR \
		ZOO_TICK_TIME=2000 \
    ZOO_INIT_LIMIT=5 \
    ZOO_SYNC_LIMIT=2 \
    ZOO_AUTOPURGE_PURGEINTERVAL=0 \
    ZOO_AUTOPURGE_SNAPRETAINCOUNT=3 \
    ZOO_MAX_CLIENT_CNXNS=60

WORKDIR /data


RUN  mkdir -p "$ZOO_DATA_DIR" "$ZOO_DATA_LOG_DIR" \
   && wget -P ${INSTALL_DIR}/  http://mirrors.hust.edu.cn/apache/zookeeper/zookeeper-3.4.12/zookeeper-${ZK_VERSION}.tar.gz \
	 && tar -xzvf  ${INSTALL_DIR}/zookeeper-${ZK_VERSION}.tar.gz  \
	 && rm -rf ${INSTALL_DIR}/zookeeper-${ZK_VERSION}.tar.gz \
#	 && mv ${INSTALL_DIR}/zookeeper-${ZK_VERSION}/conf/zoo_sample.cfg ${INSTALL_DIR}/zookeeper-${ZK_VERSION}/conf/zoo.cfg \
	 && mkdir /tmp/zookeeper \
	 && yum -y install dos2unix \
	 && dos2unix  /data/docker-entrypoint.sh

EXPOSE 2181 2888 3888



#CMD ["/data/zookeeper-3.4.12/bin/zkServer.sh", "start-foreground"]
#ENTRYPOINT ["/data/zookeeper-3.4.12/bin/zkServer.sh"]
ENTRYPOINT ["/data/docker-entrypoint.sh"]
CMD ["/data/zookeeper-3.4.12/bin/zkServer.sh","start-foreground"]
