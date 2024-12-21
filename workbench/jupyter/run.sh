#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source ${SCRIPT_DIR}/.env

if podman ps -a --format '{{.Names}}' | grep -q '^jupyter$'; then
  echo "Jupyter container is running. Stopping and removing it..."
  podman stop jupyter
  podman rm jupyter
fi

podman pull quay.io/jupyter/minimal-notebook
podman build -t chiwanpark/jupyter:latest .

echo "Starting Jupyter container..."
podman run -it -d \
  --name jupyter \
  -p 8888:8888 \
  -e NB_USER=chiwanpark \
  -e NB_UID=1000 \
  -e NB_GID=1000 \
  -e CHOWN_HOME=yes \
  -e JUPYTERHUB_PUBLIC_URL=${JUPYTERHUB_PUBLIC_URL} \
  -e JUPYTERHUB_SERVICE_URL=0.0.0.0:8888 \
  -w "/home/chiwanpark" \
  -v /mnt/nfs-workspace:/home/chiwanpark/workspace \
  --user root \
  --health-interval 60s \
  chiwanpark/jupyter:latest \
  start-notebook.py --PasswordIdentityProvider.hashed_password=${JUPYTERHUB_PASSWORD} --NotebookApp.base_url=${JUPYTERHUB_BASE_URL}
