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

## redis
开发中。。。