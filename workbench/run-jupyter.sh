#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source ${SCRIPT_DIR}/.env

if docker ps -a --format '{{.Names}}' | grep -q '^jupyter$'; then
  echo "Jupyter container is running. Stopping and removing it..."
  docker stop jupyter
  docker rm jupyter
fi

echo "Starting Jupyter container..."
docker run -it -d \
  --name jupyter \
  -p 8888:8888 \
  -e NB_USER=chiwanpark \
  -e NB_UID=1000 \
  -e NB_GID=1000 \
  -e CHOWN_HOME=yes \
  -e JUPYTERHUB_PUBLIC_URL=${JUPYTERHUB_PUBLIC_URL} \
  -e JUPYTERHUB_SERVICE_URL=0.0.0.0:8888 \
  -w "/home/chiwanpark" \
  -v /home/chiwanpark/workspace:/home/chiwanpark/workspace \
  --user root \
  quay.io/jupyter/minimal-notebook \
  start-notebook.py --PasswordIdentityProvider.hashed_password=${JUPYTER_PASSWORD}
