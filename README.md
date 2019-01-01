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
### 基于jdk8DoclerFile搭建，支持单点和集群启动(redis集群最少6个节点，即redis-cluster模式，参考doc：https://redis.io/topics/cluster-tutorial)
### 使用:
#### 构建：
```
$docker run -d redis:v1 
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

#### 当为单点启动时使用如下命令启动：

```
$ docker-compose -f redis-single-compose.yml up -d
```

