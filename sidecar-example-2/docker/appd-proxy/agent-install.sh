#!/bin/bash

# php agent properties
CLI_ARGS=""

# if ssl true then -s
if [ "${APPDYNAMICS_CONTROLLER_SSL_ENABLED}" = "true" ]; then
    CLI_ARGS="-s "
fi

if [ ! -z "${APPDYNAMICS_HTTP_PROXY_HOST}" ]; then
    CLI_ARGS="${CLI_ARGS} --http-proxy-host=${APPDYNAMICS_HTTP_PROXY_HOST}"
fi

if [ ! -z "${APPDYNAMICS_HTTP_PROXY_PORT}" ]; then
    CLI_ARGS="${CLI_ARGS} --http-proxy-port=${APPDYNAMICS_HTTP_PROXY_PORT}"
fi

if [ ! -z "${APPDYNAMICS_HTTP_PROXY_USER}" ]; then
    CLI_ARGS="${CLI_ARGS} --http-proxy-user=${APPDYNAMICS_HTTP_PROXY_USER}"
fi

if [ ! -z "${APPDYNAMICS_HTTP_PROXY_PASSWORD_FILE}" ]; then
    CLI_ARGS="${CLI_ARGS} --http-proxy-password-file=${APPDYNAMICS_HTTP_PROXY_PASSWORD_FILE}"
fi

if [ ! -z "${APPDYNAMICS_AGENT_LOG_DIR}" ]; then
    mkdir -p ${APPDYNAMICS_AGENT_LOG_DIR}
    chmod 777 ${APPDYNAMICS_AGENT_LOG_DIR}
    CLI_ARGS="${CLI_ARGS} --log-dir=${APPDYNAMICS_AGENT_LOG_DIR}"
fi

if [ ! -z "${APPDYNAMICS_CTRL_DIR}" ]; then
    CLI_ARGS="${CLI_ARGS} --proxy-ctrl-dir=${APPDYNAMICS_CTRL_DIR}"
fi


CLI_ARGS="${CLI_ARGS} -a ${APPDYNAMICS_AGENT_ACCOUNT_NAME}@${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY}"
CLI_ARGS="${CLI_ARGS} --enable-cli"
CLI_ARGS="${CLI_ARGS} ${APPDYNAMICS_CONTROLLER_HOST_NAME}"
CLI_ARGS="${CLI_ARGS} ${APPDYNAMICS_CONTROLLER_PORT}"
CLI_ARGS="${CLI_ARGS} ${APPDYNAMICS_AGENT_APPLICATION_NAME}"
CLI_ARGS="${CLI_ARGS} ${APPDYNAMICS_AGENT_TIER_NAME}"
CLI_ARGS="${CLI_ARGS} ${APPDYNAMICS_AGENT_NODE_NAME}"


echo "CLI_ARGS: $CLI_ARGS"

chmod +x ${PHP_AGENT_DIR}/appdynamics-php-agent-linux_x64/install.sh
${PHP_AGENT_DIR}/appdynamics-php-agent-linux_x64/install.sh $CLI_ARGS
