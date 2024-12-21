FROM quay.io/jupyter/minimal-notebook

HEALTHCHECK --interval=60s --timeout=5s --start-period=5s --retries=5 \
        CMD /etc/jupyter/docker_healthcheck.py || exit 1
