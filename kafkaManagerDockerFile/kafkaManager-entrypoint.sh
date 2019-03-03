#!/bin/sh

set -es

echo "execute kafkaManager-entrypoint.sh"

if [[ $KM_USERNAME != ''  && $KM_PASSWORD != '' ]]; then
    echo "reset password...."
    sed -i.bak '/^basicAuthentication/d' "${INSTALL_DIR}/kafka-manager-${KM_VERSION}/conf/application.conf"
    echo 'basicAuthentication.enabled=true' >> "${INSTALL_DIR}/kafka-manager-${KM_VERSION}/conf/application.conf"
    echo "basicAuthentication.username=${KM_USERNAME}" >> "${INSTALL_DIR}/kafka-manager-${KM_VERSION}/conf/application.conf"
    echo "basicAuthentication.password=${KM_PASSWORD}" >> "${INSTALL_DIR}/kafka-manager-${KM_VERSION}/conf/application.conf"
    echo 'basicAuthentication.realm="Kafka-Manager"' >> "${INSTALL_DIR}/kafka-manager-${KM_VERSION}/conf/application.conf"
fi

echo "exec: ${INSTALL_DIR}/kafka-manager-${KM_VERSION}/bin/kafka-manager Dconfig.file=${KM_CONFIGFILE} ${KM_ARGS} ${@}"

exec  ${INSTALL_DIR}/kafka-manager-${KM_VERSION}/bin/kafka-manager -Dconfig.file=${KM_CONFIGFILE} "${KM_ARGS}" "${@}"
