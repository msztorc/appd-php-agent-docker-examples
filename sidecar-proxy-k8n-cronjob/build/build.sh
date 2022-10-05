#!/bin/bash

docker build --no-cache \
--build-arg AGENT_VERSION=22.3.0.501 \
--build-arg AGENT_PATH=/opt/appdynamics/php-agent \
--build-arg APPDYNAMICS_AGENT_APPLICATION_NAME=php-k8n-sidecar \
--build-arg APPDYNAMICS_AGENT_TIER_NAME=php-cronjob-tier \
--build-arg APPDYNAMICS_AGENT_NODE_NAME=php-cronjob-node \
--build-arg APPDYNAMICS_AGENT_ACCOUNT_NAME=<APPDYNAMICS-ACCOUNT-NAME> \
--build-arg APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=<APPDYNAMICS-ACCOUNT-KEY> \
--build-arg APPDYNAMICS_CONTROLLER_HOST_NAME=<APPDYNAMICS-CONTROLLER-HOST-NAME> \
--build-arg APPDYNAMICS_CONTROLLER_PORT=443 \
--build-arg APPDYNAMICS_CONTROLLER_SSL_ENABLED=true \
--build-arg AGENT_LOGS_PATH=/mnt \
--build-arg AGENT_CTRL_PATH=/mnt \
-t appd-php-cli .