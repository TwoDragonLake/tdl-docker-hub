FROM centos:7

MAINTAINER CeaserWang <ceaserwang@outlook.com>

ARG USER_HOME_DIR="/root"
ARG INSTALL_DIR="/data"

ADD jdk-8u151-linux-x64.tar.gz ${INSTALL_DIR}/
ADD apache-maven-3.6.0-bin.tar.gz ${INSTALL_DIR}/



ENV JAVA_HOME=${INSTALL_DIR}/jdk1.8.0_151 \
	MAVEN_HOME=${INSTALL_DIR}/apache-maven-3.6.0 \
	MAVEN_CONFIG=${USER_HOME_DIR}/.m2 \
	CLASSPATH=${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar \
	PATH=${PATH}:${JAVA_HOME}/bin:${MAVEN_HOME}/bin

RUN alternatives --install /usr/bin/java java ${JAVA_HOME}/bin/java 1 \
    && alternatives --install /usr/bin/javac javac ${JAVA_HOME}/bin/javac 1 \
    && alternatives --install /usr/bin/jar jar ${JAVA_HOME}/bin/jar 1 \
    && ln -s ${INSTALL_DIR}/apache-maven-3.6.0/bin/mvn /usr/local/bin/mvn \
    && rm -f ${INSTALL_DIR}/jdk-8u151-linux-x64.tar.gz \
    && rm -f ${INSTALL_DIR}/apache-maven-3.6.0-bin.tar.gz \
    && yum -y install dos2unix gcc automake autoconf libtool make  gcc-c++  \
    && yum install -y expect

ONBUILD RUN 	yum install net-tools -y \
							&& yum install -y wget

#CMD ["java","-v"]
