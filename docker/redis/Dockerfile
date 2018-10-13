ARG ARCH=arm32v6
FROM ${ARCH}/alpine:3.8

ARG REDIS_VERSION=4.0.11-r0

RUN set -x \
    && echo "upgrade apk" \
    && apk upgrade \
    && echo "install redis" \
    && apk --no-cache add redis=${REDIS_VERSION} tzdata

COPY redis.conf /etc/redis/
COPY docker-entrypoint.sh /usr/local/bin

VOLUME ["/data/redis"]
EXPOSE 6379

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["redis-server", "/etc/redis/redis.conf"]
