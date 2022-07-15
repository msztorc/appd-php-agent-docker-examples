### Appdynamics PHP Agent - sidecar proxy - PHP-CLI example 1
Short-lived job container - uses prebuilt image `msztorc/appd-php-agent-proxy`

---

**docker-compose.yml**
```yml
  ...
  
  # sidecar proxy service
  appd-proxy:
    image: msztorc/appd-php-agent-proxy:22.3.0  # <- uses prebuilt image
    volumes:
      - appd-logs:/tmp/appd/logs/  # <- mount volume for agent logs
      - appd-ctrl:/tmp/appd/ctrl/  # <- mount volume for ctrl dir
    restart: always
  
  ...
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
