#!/bin/bash

set -e
sed '31c listeners=${LISTENERS}' "${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}"
