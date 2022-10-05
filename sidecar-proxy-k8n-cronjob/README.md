### Appdynamics PHP Agent - sidecar proxy - PHP-CLI example 3
Short-lived containers example (Kubernetes CronJob)

---

#### Prerequisites
1. Java Proxy Docker image needs to be built before deploying this example. You can also choose a prebuilt image from my public DockerHub: https://hub.docker.com/r/msztorc/appd-php-agent-proxy/tags or you can use a sample Dockerfile available here: https://github.com/msztorc/appd-php-agent-proxy to build your own Java Proxy image which will act as a sidecar container.
2. Job image containing php script and preinstalled php-agent. Below you can find a sample Dockerfile to build your own image to run on a time-based schedule.

#### Build Job image

```bash

cd build
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

```


#### Deployment

>**_NOTE:_** Before applying the deployment.yaml, please make sure to adjust values for environment variables for **Deployment** and **CronJob** specs.


```yaml
...
         env:
          - name: AGENT_PATH
            value: "/opt/appdynamics/php-agent"
          - name: APPDYNAMICS_AGENT_APPLICATION_NAME
            value: "php-k8n-sidecar"
          - name: APPDYNAMICS_AGENT_TIER_NAME
            value: "php-cronjob-tier"
          - name: APPDYNAMICS_AGENT_NODE_NAME
            value: "php-cronjob-node"
          - name: APPDYNAMICS_AGENT_ACCOUNT_NAME
            value: "<YOUR-ACCOUNT-NAME>"
          - name: APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY
            value: "<YOUR-ACCOUNT-KEY>"
          - name: APPDYNAMICS_CONTROLLER_HOST_NAME
            value: "<YOUR-CONTROLLER-HOST-NAME>"
          - name: APPDYNAMICS_CONTROLLER_PORT
            value: "443"
          - name: APPDYNAMICS_CONTROLLER_SSL_ENABLED
            value: "true"
          - name: AGENT_LOGS_PATH
            value: "/mnt/"
          - name: AGENT_CTRL_PATH
            value: "/mnt/" 
...
```


```bash
$ kubectl apply -f deployment.yaml
deployment.apps/appd-proxy created
persistentvolumeclaim/appd-proxy created
cronjob.batch/appd-proxy-cron created 
```

```bash
$ kubectl get pod,job -o wide
NAME                              READY   STATUS    RESTARTS   AGE   IP          NODE             NOMINATED NODE   READINESS GATES
pod/appd-proxy-77745ff755-4l9ls   1/1     Running   0          51s   10.1.2.69   docker-desktop   <none>           <none>
```

CronJob is scheduled to run every minute, so after a minute you should be able to see:

```bash
$ kubectl get pod,job -o wide
NAME                                 READY   STATUS              RESTARTS   AGE   IP          NODE             NOMINATED NODE   READINESS GATES
pod/appd-proxy-77745ff755-4l9ls      1/1     Running             0          52s   10.1.2.69   docker-desktop   <none>           <none>
pod/appd-proxy-cron-27749862-f5bvd   0/1     ContainerCreating   0          0s    <none>      docker-desktop   <none>           <none>

NAME                                 COMPLETIONS   DURATION   AGE   CONTAINERS        IMAGES         SELECTOR
job.batch/appd-proxy-cron-27749862   0/1           0s         0s    appd-proxy-cron   appd-php-cli   controller-uid=6d9d5431-e811-41e9-b4c5-2ab1bcc09795
```

After a few minutes, you will see more containers with Complete status.

```bash
$ kubectl get pod,job -o wide
NAME                                 READY   STATUS              RESTARTS   AGE     IP          NODE             NOMINATED NODE   READINESS GATES
pod/appd-proxy-77745ff755-4l9ls      1/1     Running             0          7m52s   10.1.2.69   docker-desktop   <none>           <none>
pod/appd-proxy-cron-27749866-rf6qk   0/1     Completed           0          3m      10.1.2.74   docker-desktop   <none>           <none>
pod/appd-proxy-cron-27749867-7rvm5   0/1     Completed           0          2m      10.1.2.75   docker-desktop   <none>           <none>
pod/appd-proxy-cron-27749868-5jzsx   0/1     Completed           0          60s     10.1.2.76   docker-desktop   <none>           <none>
pod/appd-proxy-cron-27749869-fwzh7   0/1     ContainerCreating   0          0s      <none>      docker-desktop   <none>           <none>

NAME                                 COMPLETIONS   DURATION   AGE   CONTAINERS        IMAGES         SELECTOR
job.batch/appd-proxy-cron-27749866   1/1           5s         3m    appd-proxy-cron   appd-php-cli   controller-uid=4e04e0a8-8d8e-4a65-83a9-2ddb24aed87c
job.batch/appd-proxy-cron-27749867   1/1           5s         2m    appd-proxy-cron   appd-php-cli   controller-uid=45e0d12f-542e-4006-9cba-5d1f3335ae18
job.batch/appd-proxy-cron-27749868   1/1           4s         60s   appd-proxy-cron   appd-php-cli   controller-uid=a2726fcb-23e3-4392-a487-6e48659efcb8
job.batch/appd-proxy-cron-27749869   0/1           0s         0s    appd-proxy-cron   appd-php-cli   controller-uid=f0cf29b6-aedb-4906-b2c1-205bebf647ba
```

#### Cleaning up

```bash
$ kubectl delete -f deployment.yaml
deployment.apps "appd-proxy" deleted
persistentvolumeclaim "appd-proxy" deleted
cronjob.batch "appd-proxy-cron" deleted
```
