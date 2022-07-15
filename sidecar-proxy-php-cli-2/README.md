### Appdynamics PHP Agent - sidecar proxy - PHP-CLI example 2
Short-lived job container + building own sidecar proxy

---

**docker-compose.yml**
```yml
  ...
  
  # sidecar proxy
  appd-proxy:
    image: appd-php-sidecar-proxy
    build:
      context: .
      dockerfile: ./docker/appd-proxy/Dockerfile
      args:
        - AGENT_PATH=${AGENT_PATH}
        - AGENT_VERSION=${AGENT_VERSION}
        - AGENT_LOGS_PATH=${AGENT_LOGS_PATH}
        - AGENT_CTRL_PATH=${AGENT_CTRL_PATH}
        - APPDYNAMICS_CONTROLLER_SSL_ENABLED=${APPDYNAMICS_CONTROLLER_SSL_ENABLED}
        - APPDYNAMICS_AGENT_ACCOUNT_NAME=${APPDYNAMICS_AGENT_ACCOUNT_NAME}
        - APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY}
        - APPDYNAMICS_CONTROLLER_HOST_NAME=${APPDYNAMICS_CONTROLLER_HOST_NAME}
        - APPDYNAMICS_CONTROLLER_PORT=${APPDYNAMICS_CONTROLLER_PORT}
        - APPDYNAMICS_AGENT_APPLICATION_NAME=${APPDYNAMICS_AGENT_APPLICATION_NAME}
        - APPDYNAMICS_AGENT_TIER_NAME=${APPDYNAMICS_AGENT_TIER_NAME}
        - APPDYNAMICS_AGENT_NODE_NAME=${APPDYNAMICS_AGENT_NODE_NAME}
        - APPDYNAMICS_HTTP_PROXY_HOST=${APPDYNAMICS_HTTP_PROXY_HOST}
        - APPDYNAMICS_HTTP_PROXY_PORT=${APPDYNAMICS_HTTP_PROXY_PORT}
        - APPDYNAMICS_HTTP_PROXY_USER=${APPDYNAMICS_HTTP_PROXY_USER}
        - APPDYNAMICS_HTTP_PROXY_PASSWORD_FILE=${APPDYNAMICS_HTTP_PROXY_PASSWORD_FILE}
    tty: true
    volumes:
      - appd-logs:/tmp/appd/logs/
      - appd-ctrl:/tmp/appd/ctrl/
    env_file: ./.env
    restart: always
    networks:
      - app-network
  
  ...      
```

**.env file**

```ini
AGENT_PATH=/opt/appdynamics/php-agent
AGENT_VERSION=22.3.0.501

AGENT_LOGS_PATH=/tmp/appd/logs/
AGENT_CTRL_PATH=/tmp/appd/ctrl/

APPDYNAMICS_AGENT_APPLICATION_NAME=php-cli-sidecar
APPDYNAMICS_AGENT_TIER_NAME=php-cli-tier
APPDYNAMICS_AGENT_NODE_NAME=php-cli-node

APPDYNAMICS_AGENT_ACCOUNT_NAME=
APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=
APPDYNAMICS_CONTROLLER_HOST_NAME=
APPDYNAMICS_CONTROLLER_PORT=443
APPDYNAMICS_CONTROLLER_SSL_ENABLED=true

APPDYNAMICS_HTTP_PROXY_HOST=
APPDYNAMICS_HTTP_PROXY_PORT=
APPDYNAMICS_HTTP_PROXY_USER=
APPDYNAMICS_HTTP_PROXY_PASSWORD_FILE=

```


**Build & Run**

```bash
$ docker-compose up --build -d
```

Run short-lived job container

```bash
$ docker-compose run --rm job
```

You should be able to see some random phrases like below:

```
Creating sidecar-proxy-php-cli-1_job_run ... done


Useless fact: Firehouses have circular stairways originating from the old days when the engines were pulled by horses. The horses were stabled on the ground floor and figured out how to walk up straight staircases.
source: djtech.net
-----------
tech-savvy sounding phrase: I am almost done configuring the suppression anomalies
-----------
Random advice: Measure twice, cut once.
```
