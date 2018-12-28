# 一把梭：image -> container -> service -> swarms -> stack -> k8s
## jdk8DoclerFile：
### centos7 + jdk8 + maven 基础镜像；下载 jdk-8u151-linux-x64.tar.gz ,放到jdk8DoclerFile目录下，如果换jdk版本，直接修改DoclerFile文件。此处不使用wget的原因是考虑此文件过大，下载时间过长，所以切换为本地copy。

## zkDockerFile：
### zk镜像，基于jdk8DoclerFile构建，支持单点、全分布式方式。

## kafkaDockerFile：
### 开发中。。。将会支持kafkacluster和单点部署方式。

