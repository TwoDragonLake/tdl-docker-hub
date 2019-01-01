# һ����image -> container -> service -> swarms -> stack -> k8s

## jdk8DoclerFile��
### centos7 + jdk8 + maven ������������ jdk-8u151-linux-x64.tar.gz ,�ŵ�jdk8DoclerFileĿ¼�£������jdk�汾��ֱ���޸�DoclerFile�ļ����˴���ʹ��wget��ԭ���ǿ��Ǵ��ļ���������ʱ������������л�Ϊ����copy��
#### ʹ�ã�
##### ������
```
cd jdk8DoclerFile
$docker build -t jdk8:v1
```

## zkDockerFile��
### zk���񣬻���jdk8DoclerFile������֧�ֵ��㡢ȫ�ֲ�ʽ��ʽ��
#### ʹ�ã�
##### ������
```
cd zkDockerFile
$docker build -t zk:v1
```
##### ���е��ڵ�:
```
$docker run -d zk:v1 
```
##### ���м�Ⱥ:
```
$docker-dompose up -d
```

## kafkaDockerFile��
### ����jdk8DoclerFile��zkDockerFile��֧��kafkaCluster�͵��㲿��ʽ��
#### ʹ�ã�
##### ������
```
$cd kafkaDockerFile
$docker build -t kafka:v1
```

##### ���е��ڵ�:
```
$docker run -d kafka:v1 
```
�����������ο�swarmģʽ��https://docs.docker-cn.com/get-started/part4/#%E5%88%9B%E5%BB%BA%E9%9B%86%E7%BE%A4


##### ���м�Ⱥ(Ĭ��3��zk + 2��kafka):
```
$docker-dompose up -d

Creating kafkadockerfile_kafka2_1 ... done
Creating kafkadockerfile_zoo2_1   ... done
Creating kafkadockerfile_kafka1_1 ... done
Creating kafkadockerfile_zoo3_1   ... done
Creating kafkadockerfile_zoo1_1   ... done

$docker container ls -a

CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                                        NAMES
63080be60291        zk:v1               "/data/docker-entryp��"   About a minute ago   Up 53 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2183->2181/tcp   kafkadockerfile_zoo3_1
02e5bc078337        zk:v1               "/data/docker-entryp��"   About a minute ago   Up 55 seconds       2888/tcp, 0.0.0.0:2181->2181/tcp, 3888/tcp   kafkadockerfile_zoo1_1
662a2cd09911        zk:v1               "/data/docker-entryp��"   About a minute ago   Up 55 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   kafkadockerfile_zoo2_1
f30a8566c982        kafka:v1            "/data/kafka-entrypo��"   About a minute ago   Up 57 seconds       0.0.0.0:9092->9092/tcp                       kafkadockerfile_kafka1_1
7581af3f94ed        kafka:v1            "/data/kafka-entrypo��"   About a minute ago   Up 57 seconds       0.0.0.0:9093->9093/tcp                       kafkadockerfile_kafka2_1
```
�����������ο�swarmģʽ��https://docs.docker-cn.com/get-started/part4/#%E5%88%9B%E5%BB%BA%E9%9B%86%E7%BE%A4




## redisDockerFile
### ����jdk8DoclerFile���֧�ֵ���ͼ�Ⱥ����(redis��Ⱥ����6���ڵ㣬��redis-clusterģʽ���ο�doc��https://redis.io/topics/cluster-tutorial)
### ʹ��:
#### ������
```
$docker run -d redis:v1 
```

#### ��Ϊ��Ⱥ����ʱʹ����������������
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
90c456fca8f8        redis:v1            "/data/redis-entrypo��"   26 seconds ago      Up 17 seconds       0.0.0.0:7005->7005/tcp                       redisdockfile_redis5_1
aaa4831bdfef        redis:v1            "/data/redis-entrypo��"   26 seconds ago      Up 17 seconds       0.0.0.0:7006->7006/tcp                       redisdockfile_redis6_1
4c499fec996b        redis:v1            "/data/redis-entrypo��"   26 seconds ago      Up 19 seconds       0.0.0.0:7003->7003/tcp                       redisdockfile_redis3_1
e74bf1e8e03f        redis:v1            "/data/redis-entrypo��"   26 seconds ago      Up 17 seconds       0.0.0.0:7001->7001/tcp                       redisdockfile_redis1_1
8487ef121af3        redis:v1            "/data/redis-entrypo��"   26 seconds ago      Up 19 seconds       0.0.0.0:7002->7002/tcp                       redisdockfile_redis2_1
5f2d5c667ae6        redis:v1            "/data/redis-entrypo��"   26 seconds ago      Up 21 seconds       0.0.0.0:7004->7004/tcp                       redisdockfile_redis4_1

```

#### ��Ϊ��������ʱʹ����������������

```
$ docker-compose -f redis-single-compose.yml up -d
```

