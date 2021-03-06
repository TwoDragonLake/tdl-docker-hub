#!/bin/bash

set -e

CONFIG="${ZK_DIR}/conf/zoo.cfg"

if [[ ! -f "$CONFIG" ]]; then
  echo "clientPort=$ZOO_PORT" >> "$CONFIG"
  echo "dataDir=$ZOO_DATA_DIR" >> "$CONFIG"
  echo "dataLogDir=$ZOO_DATA_LOG_DIR" >> "$CONFIG"

  echo "tickTime=$ZOO_TICK_TIME" >> "$CONFIG"
  echo "initLimit=$ZOO_INIT_LIMIT" >> "$CONFIG"
  echo "syncLimit=$ZOO_SYNC_LIMIT" >> "$CONFIG"  

  echo "autopurge.snapRetainCount=$ZOO_AUTOPURGE_SNAPRETAINCOUNT" >> "$CONFIG"
  echo "autopurge.purgeInterval=$ZOO_AUTOPURGE_PURGEINTERVAL" >> "$CONFIG"
  echo "maxClientCnxns=$ZOO_MAX_CLIENT_CNXNS" >> "$CONFIG"

  for server in $ZOO_SERVERS; do
     echo "$server" >> "$CONFIG"
  done
  
fi



if [[ ! -f "$ZOO_DATA_DIR/myid" ]]; then
    echo "${ZOO_MY_ID:-1}" > "$ZOO_DATA_DIR/myid"
fi

exec "$@"