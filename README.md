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
### ����jdk8DoclerFile���֧�ֵ���ͼ�Ⱥ����(redis��Ⱥ����6���ڵ㣬��redis-clusterģʽ���ο�doc��https://redis.io/topics/cluster-tutorial),

### ʹ��:
������
- PORT: docker������redis����Ķ˿ڣ����������
- EXE_CREATE_CMD_NODE�� ������Ⱥ�Ľڵ���Ҫ���ô˱���(����Ϊtrue)�������ڸýڵ�ִ��������Ⱥ����ο�redis-cluster-compose.yml��redis1����.
- PUBLISH_CLUSTER_MODE���Ƿ��Ǽ�Ⱥģʽ����true�Ǽ�Ⱥģʽ������������redis����ʱ(docker-compose -f redis-single-compose.yml up -d)��Ҫ����Ϊfalse�����������
- NODES:������EXE_CREATE_CMD_NODE==true�Ľڵ㣬�����˼�Ⱥ�����еĽڵ����ã�EXE_CREATE_CMD_NODE==trueʱ���Ǳ�ѡ�������ο�redis-cluster-compose.yml��redis1����.
- LOGFILEDIR: redis��־�ļ�·����������EXE_CREATE_CMD_NODE==true�Ľڵ�ʱ���˱����Ǳ�ѡ���ã������޷������ڵ㡣���⻹���������ݾ��ο�redis-cluster-compose.yml��redis1����.
#### ������
```
$docker build -t redis:v1 .
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

#### 7001�˿ڽڵ�setһ������:
```
>docker container ls -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
a6928d211f85        redis:v1            "/data/redis-entrypo��"   2 minutes ago       Up About a minute   0.0.0.0:7005->7005/tcp   redisdockfile_redis5_1
8e0e74e17afd        redis:v1            "/data/redis-entrypo��"   2 minutes ago       Up About a minute   0.0.0.0:7003->7003/tcp   redisdockfile_redis3_1
fbf8574acd84        redis:v1            "/data/redis-entrypo��"   2 minutes ago       Up About a minute   0.0.0.0:7004->7004/tcp   redisdockfile_redis4_1
292e98146a73        redis:v1            "/data/redis-entrypo��"   2 minutes ago       Up About a minute   0.0.0.0:7001->7001/tcp   redisdockfile_redis1_1
a268439d1314        redis:v1            "/data/redis-entrypo��"   2 minutes ago       Up About a minute   0.0.0.0:7006->7006/tcp   redisdockfile_redis6_1
0e567f0ad0c6        redis:v1            "/data/redis-entrypo��"   2 minutes ago       Up About a minute   0.0.0.0:7002->7002/tcp   redisdockfile_redis2_1

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
#### ������һ���ӽڵ�鿴����:

```
>docker exec -it fbf bash
[root@redis4 data]# cd /data/redis-5.0.3/src/
[root@redis4 src]# ./redis-cli -c -p 7004 -a operater
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
127.0.0.1:7004> get key
-> Redirected to slot [12539] located at 172.21.0.5:7003
"value1"
```
�رգ�
```
docker-compose -f redis-cluster-compose.yml stop
```


#### ��Ϊ��������ʱʹ����������������

```
$ docker-compose -f redis-single-compose.yml up -d
```
�رգ�
```
docker-compose -f redis-single-compose.yml stop
```


 yum install -y git
 git clone https://github.com/TwoDragonLake/kafka-manager.git  /data/kafka-manager
 yum isntall -y which
 