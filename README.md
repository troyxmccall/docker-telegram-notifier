# Docker Telegram Notifier ![docker build status](https://github.com/troyxmccall/docker-telegram-notifier/actions/workflows/deploy-docker.yml/badge.svg)

A Modern `Node v22` and `Alpine 3.22` 
Cross-platform `amd64`/`arm64` Telegram integration to notify Docker events. 

This service notifies about container `start`, `stop`, `restart` events, and changes of Docker healthcheck status. If you wish you can add more event notifications in `templates.js` file.


## How to Run

[Set up a telegram bot](https://core.telegram.org/bots#3-how-do-i-create-a-bot) and get the `Bot Token`. then add the bot to a group and make it admin and [extract the Chat ID](https://stackoverflow.com/a/32572159/882223).

Run a container as follows:

```sh
# Docker
docker run -d --env TELEGRAM_NOTIFIER_BOT_TOKEN=token --env TELEGRAM_NOTIFIER_CHAT_ID=chat_id --volume /var/run/docker.sock:/var/run/docker.sock:ro troyxmccall/docker-telegram-notifier

# Docker Compose
curl -O https://raw.githubusercontent.com/troyxmccall/docker-telegram-notifier/master/docker-compose.yml
docker-compose up -d
```

## Blacklist and Whitelist

You can suppress notifications from certain containers by adding a label `--label telegram-notifier.monitor=false` to them. If you want to receive notifications only from whitelisted containers, set `--env ONLY_WHITELIST=true` environment variable on the notifier instance, and `--label telegram-notifier.monitor=true` label on the containers you want to monitor.

## Remote docker instance

By default notifier connects to a local docker instance (don't forget to specify `--volume /var/run/docker.sock:/var/run/docker.sock:ro` for this case). But if you have monitoring and the service on the same host, you will not receive notifications if the host goes down. So I recommend to have monitoring separately.

Notifier accepts usual `DOCKER_HOST` and `DOCKER_CERT_PATH` environment variables to specify remote instance. For http endpoint you need to specify only `--env DOCKER_HOST=tcp://example.com:2375` (make sure to keep such instances behind the firewall). For https, you'll also need to mount a volume with https certificates that contains `ca.pem`, `cert.pem`, and `key.pem`: `--env DOCKER_HOST=tcp://example.com:2376 --env DOCKER_CERT_PATH=/certs --volume $(pwd):/certs`
Tutorial on how to generate docker certs can be found [here](https://docs.docker.com/engine/security/https/)

## docker-compose

For docker-compose examples see comments in [docker-compose.yml](./docker-compose.yml) file.

## Docker Hub:

https://hub.docker.com/r/troyxmccall/docker-telegram-notifier
