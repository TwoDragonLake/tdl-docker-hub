FROM jdk8:v1

MAINTAINER CeaserWang <ceaserwang@outlook.com>

ENV INSTALL_DIR="/data" \
    REDIS_VERSIOON=5.0.3

# http://download.redis.io/releases/redis-5.0.3.tar.gz

WORKDIR /data

COPY redis-entrypoint.sh  /data/

RUN wget -P ${INSTALL_DIR}/  http://download.redis.io/releases/redis-${REDIS_VERSIOON}.tar.gz \
    && tar -xzvf redis-${REDIS_VERSIOON}.tar.gz \
    && rm -rf redis-${REDIS_VERSIOON}.tar.gz \
    && dos2unix  ${INSTALL_DIR}/redis-entrypoint.sh \
    && cd  ${INSTALL_DIR}/redis-${REDIS_VERSIOON} \
    && make  \
    && make install

CMD ["/data/redis-entrypoint.sh"]
