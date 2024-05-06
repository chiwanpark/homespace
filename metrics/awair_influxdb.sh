#!/bin/bash
AWAIR_HOST=${AWAIR_HOST:-"http://AWAIR_HOST"}
INFLUXDB_HOST=${INFLUXDB_HOST:-"https://INFLUXDB_HOST"}
INFLUXDB_USER=${INFLUXDB_USER:-"user"}
INFLUXDB_PASSWORD=${INFLUXDB_PASSWORD:-"password"}
INFLUXDB_DATABASE=${INFLUXDB_DATABASE:-"db"}
REPEAT=${REPEAT:-2}
SLEEP=${SLEEP:-25}

for ((i=1; i<=REPEAT; i++)); do
  PAYLOAD=$(curl -XGET ${AWAIR_HOST}/air-data/latest)
  
  TIMESTAMP=$(echo ${PAYLOAD} | jq '.timestamp' | xargs -I {} date -d "{}" +"%s%N")
  KEYS=$(echo ${PAYLOAD} | jq -r 'keys[]' | grep -v 'timestamp')
  
  for KEY in ${KEYS}; do
    VALUE=$(echo ${PAYLOAD} | jq ".${KEY} | tonumber")
    DATA="${KEY} value=${VALUE} ${TIMESTAMP}"
  
    curl -i \
      -u ${INFLUXDB_USER}:${INFLUXDB_PASSWORD} \
      -XPOST --data-binary "${DATA}" \
      ${INFLUXDB_HOST}/write?db=${INFLUXDB_DATABASE}
  done
  sleep ${SLEEP}
done
