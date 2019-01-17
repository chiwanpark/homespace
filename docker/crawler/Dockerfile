ARG ARCH=arm32v6
FROM chiwanpark/firefox-esr:52.9.0-${ARCH}

RUN set -x && \
    apk add --no-cache --virtual .build-deps git gcc python3-dev build-base && \
    mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/chiwanpark/crawler.git crawler.git && \
    pip3 install -r crawler.git/requirements.txt && \
    apk del .build-deps

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

WORKDIR /opt/crawler.git
CMD ["python3", "exec.py"]
