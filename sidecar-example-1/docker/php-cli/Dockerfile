FROM ubuntu:20.04 AS appd-downloader

ARG AGENT_PATH
ARG AGENT_VERSION


RUN apt-get update -y && \
    apt-get install -y bash curl bzip2 tar

# download the agent
RUN mkdir -p ${AGENT_PATH} && \
    cd ${AGENT_PATH} && \
    curl -OL https://download-files.appdynamics.com/download-file/php-tar/${AGENT_VERSION}/appdynamics-php-agent-x64-linux-${AGENT_VERSION}.tar.bz2 && \
    tar -xf ${AGENT_PATH}/appdynamics-php-agent-x64-linux-${AGENT_VERSION}.tar.bz2 -C ${AGENT_PATH} && \
    rm ${AGENT_PATH}/appdynamics-php-agent-x64-linux-${AGENT_VERSION}.tar.bz2


FROM php:8.0.11-cli as appd-php-cli

ARG AGENT_PATH
ARG AGENT_VERSION
ARG AGENT_LOGS_PATH
ARG AGENT_CTRL_PATH

ARG APPDYNAMICS_AGENT_ACCOUNT_NAME
ARG APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY
ARG APPDYNAMICS_CONTROLLER_HOST_NAME
ARG APPDYNAMICS_CONTROLLER_PORT
ARG APPDYNAMICS_CONTROLLER_SSL_ENABLED
ARG APPDYNAMICS_AGENT_APPLICATION_NAME
ARG APPDYNAMICS_AGENT_TIER_NAME
ARG APPDYNAMICS_AGENT_NODE_NAME

ARG APPDYNAMICS_HTTP_PROXY_HOST
ARG APPDYNAMICS_HTTP_PROXY_PORT
ARG APPDYNAMICS_HTTP_PROXY_USER
ARG APPDYNAMICS_HTTP_PROXY_PASSWORD_FILE

ENV PHP_AGENT_DIR=${AGENT_PATH}
ENV PHP_AGENT_VERSION=${AGENT_VERSION}


RUN apt-get update -y && \
    apt-get install -y bash curl bzip2 tar unzip

RUN mkdir -p ${PHP_AGENT_DIR}
COPY --from=0 ${AGENT_PATH}/ ${PHP_AGENT_DIR}/

WORKDIR ${PHP_AGENT_DIR}

#RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

ADD ./docker/php-cli/agent-install.sh /agent-install.sh

# Install & instrument AppDynamics PHP Agent
RUN sh /agent-install.sh

# copy logger config file (trace logs enabled)
# COPY ./appdynamics_agent_log4cxx.xml ${PHP_AGENT_DIR}/appdynamics-php-agent-linux_x64/php/conf/appdynamics_agent_log4cxx.xml

# sample job script to run and exit
CMD ["php", "/src/cli-job.php"]
