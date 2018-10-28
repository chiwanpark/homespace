#!/bin/sh
set -e

# first arg is `-something` or `+something`
if [ "${1#-}" != "$1" ] || [ "${1#+}" != "$1" ]; then
	set -- /opt/couchdb/bin/couchdb "$@"
fi

# first arg is the bare word `couchdb`
if [ "$1" = "couchdb" ]; then
    shift
    set -- /opt/couchdb/bin/couchdb "$@"
fi

if [ ! -z "$NODENAME" ]; then
    NODE_IP=$(cat /run/secrets/clusters | grep $NODENAME | awk '{split($0,a,"|"); print a[2]}')
    echo "\n-name couchdb@${NODE_IP}" >> /opt/couchdb/etc/vm.args
fi

COUCHDB_ADMIN_USER=$(cat /run/secrets/couchdb-auth | awk '{split($0,a,"|"); print a[1]}')
COUCHDB_ADMIN_PASS=$(cat /run/secrets/couchdb-auth | awk '{split($0,a,"|"); print a[2]}')
echo "\n[admins]\n${COUCHDB_ADMIN_USER} = ${COUCHDB_ADMIN_PASS}" >> /opt/couchdb/etc/local.d/admin.ini

exec "$@"
