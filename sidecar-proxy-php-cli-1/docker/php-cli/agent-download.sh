#!/bin/bash

AGENT_VERSION=$1
APPD_USER=$2
APPD_PASS=$3
AGENT_PATH=$4

APPD_LOGIN_URL="https://identity.msrv.saas.appdynamics.com/v2.0/oauth/token"
AGENT_FILE="appdynamics-php-agent-x64-linux-${AGENT_VERSION}.tar.bz2"

APPD_AGENT_URL="https://download.appdynamics.com/download/prox/download-file/php-tar/${AGENT_VERSION}/${AGENT_FILE}"


# login
echo "APPD_LOGIN_URL: ${APPD_LOGIN_URL}"
RESPONSE=`curl -X POST -d '{"username": "'"${APPD_USER}"'","password": "'"${APPD_PASS}"'","scopes": ["download"]}' ${APPD_LOGIN_URL}`
TOKEN=`echo ${RESPONSE} | sed s/\"/\\|/g | awk 'BEGIN{FS="|"}{print $10}'`

# Download agent
echo "DOWNLOAD TOKEN: ${TOKEN}\n"
echo "AGENT VERSION: ${AGENT_VERSION}"
echo "AGENT URL: ${APPD_AGENT_URL}"

curl -L -O -H "Authorization: Bearer $TOKEN" $APPD_AGENT_URL

# Unpack agent
echo "FILE: ${AGENT_FILE} => ${AGENT_PATH}"
mv ${AGENT_FILE} ${AGENT_PATH}
tar -xf ${AGENT_PATH}/${AGENT_FILE} -C ${AGENT_PATH}
rm ${AGENT_PATH}/${AGENT_FILE}
