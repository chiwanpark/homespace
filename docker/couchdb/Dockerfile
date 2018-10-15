FROM arm32v7/debian:jessie-slim

ARG COUCHDB_VERSION=2.2.0
ARG TINI_ARCH=static-armhf

RUN set -x \
    && echo "install runtime dependencies" \
    && apt -y update \
    && apt -y --no-install-recommends install ca-certificates curl erlang-nox erlang-reltool libicu52 libmozjs185-1.0 openssl

RUN set -x \
    && DEPENDENCIES='python wget apt-transport-https gcc g++ erlang-dev libcurl4-openssl-dev libicu-dev libmozjs185-dev make' \
    && echo "install build dependencies" \
    && apt -y --no-install-recommends -y install ${DEPENDENCIES} \
    && echo "download couchdb source code" \
    && mirror_url=$(wget -q -O - "http://www.apache.org/dyn/closer.cgi/?as_json=1" | python -c "import json,sys; print(json.loads(sys.stdin.read())['preferred'])") \
    && wget -q -O - ${mirror_url}/couchdb/source/${COUCHDB_VERSION}/apache-couchdb-${COUCHDB_VERSION}.tar.gz | tar -xzf - -C /tmp \
    && echo "build couchdb" \
    && cd /tmp/apache-* \
    && ./configure --disable-docs \
    && make release \
    && cp -r rel/couchdb /opt/ \
    && echo "remove build dependencies" \
    && apt purge -y --auto-remove ${DEPENDENCIES} \
    && apt-get clean \
    && rm -rf /tmp/apache-* /var/lib/apt/lists/*

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-${TINI_ARCH} /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini

COPY 10-docker-default.ini /opt/couchdb/etc/default.d/
COPY vm.args /opt/couchdb/etc/
COPY docker-entrypoint.sh /usr/local/bin/

VOLUME ["/data/couchdb"]
EXPOSE 5984 5986 4369 9100

ENTRYPOINT ["/usr/local/bin/tini", "--", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["/opt/couchdb/bin/couchdb"]
