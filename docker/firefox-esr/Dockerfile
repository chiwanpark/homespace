ARG ARCH=arm32v6
FROM ${ARCH}/alpine:3.8

RUN set -x && \
    apk add --no-cache --virtual .build-deps perl curl wget && \
    curl -o /tmp/gdown.pl https://raw.githubusercontent.com/circulosmeos/gdown.pl/master/gdown.pl && \
    chmod +x /tmp/gdown.pl && \
    arch=$(uname -m) && \
    if [ "x$arch" = "xarmv6l" ]; then geckodriver_url="https://drive.google.com/file/d/1uNtke7XUEnfTOGitxcUhCpBE7AP6pO5t/view?usp=sharing"; fi && \
    if [ "x$arch" = "xarmv7l" ]; then geckodriver_url="https://drive.google.com/file/d/1uNtke7XUEnfTOGitxcUhCpBE7AP6pO5t/view?usp=sharing"; fi && \
    if [ "x$arch" = "xaarch64" ]; then geckodriver_url="https://drive.google.com/file/d/1aVk3MHXTjXDsG7Rl8k5dUycrd3WQhV1K/view?usp=sharing"; fi && \
    /tmp/gdown.pl ${geckodriver_url} /usr/bin/geckodriver && \
    chmod +x /usr/bin/geckodriver && \
    rm -rf /tmp/gdown.pl && \
    apk del .build-deps && \
    apk add --no-cache python3 dbus-x11 ttf-dejavu firefox-esr xvfb

CMD ["/bin/sh"]
