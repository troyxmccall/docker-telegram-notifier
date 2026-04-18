#!/bin/sh
set -eu

SOCKET_PATH="${DOCKER_SOCKET_PATH:-/var/run/docker.sock}"
RUN_AS_ROOT="${RUN_AS_ROOT:-false}"

if [ "$RUN_AS_ROOT" = "true" ] || [ "$RUN_AS_ROOT" = "1" ]; then
  exec "$@"
fi

if [ -S "$SOCKET_PATH" ]; then
  socket_gid="$(stat -c '%g' "$SOCKET_PATH")"

  if [ "$socket_gid" != "0" ]; then
    socket_group="$(awk -F: -v gid="$socket_gid" '$3 == gid { print $1; exit }' /etc/group)"

    if [ -z "$socket_group" ]; then
      socket_group="dockersock"
      addgroup -g "$socket_gid" -S "$socket_group"
    fi

    addgroup node "$socket_group" >/dev/null 2>&1 || true
  fi
fi

exec su-exec node "$@"
