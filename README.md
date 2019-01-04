# 一把梭：image -> container -> service -> swarms -> stack -> k8s

## jdk8DoclerFile：
### centos7 + jdk8 + maven 基础镜像；下载 jdk-8u151-linux-x64.tar.gz ,放到jdk8DoclerFile目录下，如果换jdk版本，直接修改DoclerFile文件。此处不使用wget的原因是考虑此文件过大，下载时间过长，所以切换为本地copy。
#### 使用：
##### 构建：
```
cd jdk8DoclerFile
$docker build -t jdk8:v1
```

## zkDockerFile：
### zk镜像，基于jdk8DoclerFile构建，支持单点、全分布式方式。
#### 使用：
##### 构建：
```
cd zkDockerFile
$docker build -t zk:v1
```
##### 运行单节点:
```
$docker run -d zk:v1 
```
##### 运行集群:
```
$docker-dompose up -d
```

## kafkaDockerFile：
### 基于jdk8DoclerFile和zkDockerFile，支持kafkaCluster和单点部署方式。
#### 使用：
##### 构建：
```
$cd kafkaDockerFile
$docker build -t kafka:v1
```

##### 运行单节点:
```
$docker run -d kafka:v1 
```
多物理机部署参考swarm模式：https://docs.docker-cn.com/get-started/part4/#%E5%88%9B%E5%BB%BA%E9%9B%86%E7%BE%A4


##### 运行集群(默认3个zk + 2个kafka):
```
$docker-dompose up -d

Creating kafkadockerfile_kafka2_1 ... done
Creating kafkadockerfile_zoo2_1   ... done
Creating kafkadockerfile_kafka1_1 ... done
Creating kafkadockerfile_zoo3_1   ... done
Creating kafkadockerfile_zoo1_1   ... done

$docker container ls -a

CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                                        NAMES
63080be60291        zk:v1               "/data/docker-entryp…"   About a minute ago   Up 53 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2183->2181/tcp   kafkadockerfile_zoo3_1
02e5bc078337        zk:v1               "/data/docker-entryp…"   About a minute ago   Up 55 seconds       2888/tcp, 0.0.0.0:2181->2181/tcp, 3888/tcp   kafkadockerfile_zoo1_1
662a2cd09911        zk:v1               "/data/docker-entryp…"   About a minute ago   Up 55 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   kafkadockerfile_zoo2_1
f30a8566c982        kafka:v1            "/data/kafka-entrypo…"   About a minute ago   Up 57 seconds       0.0.0.0:9092->9092/tcp                       kafkadockerfile_kafka1_1
7581af3f94ed        kafka:v1            "/data/kafka-entrypo…"   About a minute ago   Up 57 seconds       0.0.0.0:9093->9093/tcp                       kafkadockerfile_kafka2_1
```
多物理机部署参考swarm模式：https://docs.docker-cn.com/get-started/part4/#%E5%88%9B%E5%BB%BA%E9%9B%86%E7%BE%A4




## redisDockerFile
### 基于jdk8DoclerFile搭建，支持单点和集群启动(redis集群最少6个节点，即redis-cluster模式，参考doc：https://redis.io/topics/cluster-tutorial),

### 使用:
变量：
- PORT: docker容器内redis服务的端口，必填变量。
- EXE_CREATE_CMD_NODE： 启动集群的节点需要配置此变量(设置为true)，用来在该节点执行启动集群命令。参考redis-cluster-compose.yml的redis1配置.
- PUBLISH_CLUSTER_MODE：是否是集群模式部署，true是集群模式。当启动单个redis服务时(docker-compose -f redis-single-compose.yml up -d)，要配置为false，必填变量。
- NODES:配置在EXE_CREATE_CMD_NODE==true的节点，包含了集群中所有的节点配置，EXE_CREATE_CMD_NODE==true时，是必选变量，参考redis-cluster-compose.yml的redis1配置.
- LOGFILEDIR: redis日志文件路径，配置在EXE_CREATE_CMD_NODE==true的节点时，此变量是必选配置，否则无法启动节点。另外还有配置数据卷，参考redis-cluster-compose.yml的redis1配置.
#### 构建：
```
$docker build -t redis:v1 .
```

#### 当为集群启动时使用如下命令启动：
```
$ docker-compose -f redis-cluster-compose.yml up -d
Creating redisdockfile_redis4_1 ... done
Creating redisdockfile_redis6_1 ... done
Creating redisdockfile_redis3_1 ... done
Creating redisdockfile_redis1_1 ... done
Creating redisdockfile_redis5_1 ... done
Creating redisdockfile_redis2_1 ... done

$>docker container ls -a 

CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                        NAMES
90c456fca8f8        redis:v1            "/data/redis-entrypo…"   26 seconds ago      Up 17 seconds       0.0.0.0:7005->7005/tcp                       redisdockfile_redis5_1
aaa4831bdfef        redis:v1            "/data/redis-entrypo…"   26 seconds ago      Up 17 seconds       0.0.0.0:7006->7006/tcp                       redisdockfile_redis6_1
4c499fec996b        redis:v1            "/data/redis-entrypo…"   26 seconds ago      Up 19 seconds       0.0.0.0:7003->7003/tcp                       redisdockfile_redis3_1
e74bf1e8e03f        redis:v1            "/data/redis-entrypo…"   26 seconds ago      Up 17 seconds       0.0.0.0:7001->7001/tcp                       redisdockfile_redis1_1
8487ef121af3        redis:v1            "/data/redis-entrypo…"   26 seconds ago      Up 19 seconds       0.0.0.0:7002->7002/tcp                       redisdockfile_redis2_1
5f2d5c667ae6        redis:v1            "/data/redis-entrypo…"   26 seconds ago      Up 21 seconds       0.0.0.0:7004->7004/tcp                       redisdockfile_redis4_1

```

#### 7001端口节点set一个数据:
```
>docker container ls -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
a6928d211f85        redis:v1            "/data/redis-entrypo…"   2 minutes ago       Up About a minute   0.0.0.0:7005->7005/tcp   redisdockfile_redis5_1
8e0e74e17afd        redis:v1            "/data/redis-entrypo…"   2 minutes ago       Up About a minute   0.0.0.0:7003->7003/tcp   redisdockfile_redis3_1
fbf8574acd84        redis:v1            "/data/redis-entrypo…"   2 minutes ago       Up About a minute   0.0.0.0:7004->7004/tcp   redisdockfile_redis4_1
292e98146a73        redis:v1            "/data/redis-entrypo…"   2 minutes ago       Up About a minute   0.0.0.0:7001->7001/tcp   redisdockfile_redis1_1
a268439d1314        redis:v1            "/data/redis-entrypo…"   2 minutes ago       Up About a minute   0.0.0.0:7006->7006/tcp   redisdockfile_redis6_1
0e567f0ad0c6        redis:v1            "/data/redis-entrypo…"   2 minutes ago       Up About a minute   0.0.0.0:7002->7002/tcp   redisdockfile_redis2_1

>docker exec -it 292e bash
>[root@redis1 data]# cd /data/redis-5.0.3/
[root@redis1 src]# ./redis-cli -c -p 7001 -a operater
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
127.0.0.1:7001> set key value1
-> Redirected to slot [12539] located at 172.21.0.5:7003
OK
172.21.0.5:7003> get key
"value1"
```
#### 找任意一个子节点查看数据:

```
>docker exec -it fbf bash
[root@redis4 data]# cd /data/redis-5.0.3/src/
[root@redis4 src]# ./redis-cli -c -p 7004 -a operater
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
127.0.0.1:7004> get key
-> Redirected to slot [12539] located at 172.21.0.5:7003
"value1"
```
关闭：
```
docker-compose -f redis-cluster-compose.yml stop
```


#### 当为单点启动时使用如下命令启动：

```
$ docker-compose -f redis-single-compose.yml up -d
```
关闭：
```
docker-compose -f redis-single-compose.yml stop
```


 yum install -y git
 git clone https://github.com/TwoDragonLake/kafka-manager.git  /data/kafka-manager
 yum isntall -y which
 