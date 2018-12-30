#!/bin/bash

set -e

echo "LISTENERS:$LISTENERS;BROKER_ID:${BROKER_ID};HOST_COMMAND:$HOST_COMMAND;PORT:$PORT;ZOOKEEPER_CONNECT:$ZOOKEEPER_CONNECT"

if [[ "$ISCLUSTER" == "true" ]]; then
  if [[ -z "$LISTENERS" ||
        -z "$BROKER_ID" ||
        -z "$HOST_COMMAND" ||
        -z "$PORT" ||
        -z "$ZOOKEEPER_CONNECT" ]]; then
          echo "ERROR: missing mandatory config: LISTENERS or LISTENERS or ZOOKEEPER_CONNECT or HOST_COMMAND or PORT, if ISCLUSTER=true that is all is required"
          exit 1
  fi
fi

if [[ -n "$HOST_COMMAND" ]]; then
    HOSTNAME_VALUE=$(eval "$HOST_COMMAND")
fi

if [[ -n "$LISTENERS" ]]; then
  sed  -i  "/^#listeners=/c\listeners=PLAINTEXT://$HOSTNAME_VALUE:$PORT" "$INSTALL_DIR/kafka_$SCALA_VERSION-$KAFKA_VERSION/config/server.properties"
fi

if [[ -n "$BROKER_ID" ]]; then
  sed  -i  "/^broker.id=/c\broker.id=$BROKER_ID" "$INSTALL_DIR/kafka_$SCALA_VERSION-$KAFKA_VERSION/config/server.properties"
fi

if [[ -n "$ZOOKEEPER_CONNECT" ]]; then
  sed  -i  "/^zookeeper.connect=/c\zookeeper.connect=$ZOOKEEPER_CONNECT" "$INSTALL_DIR/kafka_$SCALA_VERSION-$KAFKA_VERSION/config/server.properties"
fi

if [[ -n "$LOG_DIRS" ]]; then
  sed  -i  "/^log.dirs=/c\log.dirs=$LOG_DIRS" "$INSTALL_DIR/kafka_$SCALA_VERSION-$KAFKA_VERSION/config/server.properties"
fi

exec "$INSTALL_DIR/kafka_$SCALA_VERSION-$KAFKA_VERSION/bin/kafka-server-start.sh" "$INSTALL_DIR/kafka_$SCALA_VERSION-$KAFKA_VERSION/config/server.properties"
