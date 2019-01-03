#!/bin/bash

set -e

echo "EXE_CREATE_CMD_NODE: $EXE_CREATE_CMD_NODE ; PORT: $PORT ; NODES : $NODES ; PUBLISH_CLUSTER_MODE: $PUBLISH_CLUSTER_MODE ;LOGFILEDIR : $LOGFILEDIR"

if [[  -z "$PORT" ]]; then
  echo "not exists PORT environment varibale"
  exit 1
fi

if [[ "$EXE_CREATE_CMD_NODE" == "true" ]]; then
  if [[ -z "$NODES" ]]; then
     echo "if config EXE_CREATE_CMD_NODE is true ,must required NODES  environment variable"
     exit 1
  fi
  if [[ -z "$LOGFILEDIR" ]]; then
    echo "if config EXE_CREATE_CMD_NODE is true ,must required LOGFILEDIR  environment variable"
    exit 1
  fi
  # if execute cluster command  node ,set redis  run daemon
  sed  -i  "/^daemonize/c\daemonize yes" "${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf"
fi

#密码
sed  -i  "/^# masterauth/c\masterauth operater" "${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf"
sed  -i  "/^# requirepass/c\requirepass operater" "${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf"
#redis后台运行
#sed  -i  "/^daemonize/c\daemonize yes" "${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf"
#端口
sed  -i  "/^port/c\port $PORT" "${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf"
#pidfile文件
sed  -i  "/^pidfile/c\pidfile /var/run/redis_$PORT.pid" "${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf"
#aof日志开启  有需要就开启，它会每次写操作都记录一条日志
sed  -i  "/^appendonly/c\appendonly yes" "${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf"
sed  -i  "/^bind 127.0.0.1/c\bind 0.0.0.0" "${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf"

if [[ -n "$LOGFILEDIR" && "$EXE_CREATE_CMD_NODE" == "true"  ]]; then
  mkdir -p "$LOGFILEDIR"
  sed  -i  "/^logfile/c\logfile \"$LOGFILEDIR/redis.log\"" "${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf"
fi



if [[ "$PUBLISH_CLUSTER_MODE" == "true" ]]; then
  sed  -i  "/^# cluster-enabled/c\cluster-enabled yes" "${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf"
  sed  -i  "/^# cluster-config-file/c\cluster-config-file nodes_$PORT.conf" "${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf"
  sed  -i  "/^# cluster-node-timeout/c\cluster-node-timeout 15000" "${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf"
fi

#ping www.sina.com.cn -c1|sed '1{s/[^(]*(//;s/).*//;q}'


#SERVER1_IP=$(ping www.sina.com.cn -c1|sed '1{s/[^(]*(//;s/).*//;q}')
#echo "SERVER1_IP : $SERVER1_IP"

echo "start redis server .... exec: ${INSTALL_DIR}/redis-${REDIS_VERSIOON}/src/redis-server ${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf"
cd ${INSTALL_DIR}/redis-${REDIS_VERSIOON}/src/
./redis-server ${INSTALL_DIR}/redis-${REDIS_VERSIOON}/redis.conf

if [[ "$EXE_CREATE_CMD_NODE" == "true" ]]; then
  space=" "
  str="$NODES"
  OLD_IFS="$IFS"
  IFS=" "
  array=($str)
  newStr=""
  for server in ${array[@]}
  do
   echo "$server"
   IFS=":"
   inarray=($server)
   newServer=$(ping ${inarray[0]}  -c1|sed '1{s/[^(]*(//;s/).*//;q}')
   newStr=$newStr$newServer:${inarray[1]}$space
  done
  IFS="$OLD_IFS"
  NEW_NODES=$newStr
  echo "$NEW_NODES"

  echo "start redis cluster ....NEW_NODES :  $NEW_NODES"
  cd ${INSTALL_DIR}/redis-${REDIS_VERSIOON}/src/

  expect -c "set timeout -1;
      spawn ./redis-cli --cluster create  $NEW_NODES;
      expect {
          *yes* {send -- yes\r;exp_continue;}
          eof        {exit 0;}
      }";
  tail -f "$LOGFILEDIR/redis.log"

fi
