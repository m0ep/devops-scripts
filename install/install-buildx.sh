#!/usr/bin/env bash

# Set version to latest unless set by user
unset VERSION
VERSION=$1
if [ -z "$VERSION" ]; then
  VERSION=$(curl --silent "https://api.github.com/repos/docker/buildx/releases/latest" | jq -r .tag_name)
fi

UNAME_O=$(uname -o)
UNAME_M=$(uname -m)

if [[ $UNAME_O == "Darwin" ]]; then
  OS="darwin"
else
  OS="linux"
fi
if [[ $UNAME_M == "arm64" ]]
then
  ARCH="arm64"
elif [[ $UNAME_M == "x86_64" ]]
then
  ARCH="amd64"
else
  exit 1
fi

echo "Downloading buildx version ${VERSION}, OS ${OS}, arch. ${ARCH}..."
wget -nv "https://github.com/docker/buildx/releases/download/${VERSION}/buildx-${VERSION}.${OS}-${ARCH}"

mkdir -p ~/.docker/cli-plugins
mv "buildx-${VERSION}.${OS}-${ARCH}" ~/.docker/cli-plugins/docker-buildx
chmod +x ~/.docker/cli-plugins/docker-buildx
docker run --privileged --rm tonistiigi/binfmt --install arm64
# To install all the supported platforms:
# - docker run --privileged --rm tonistiigi/binfmt --install all
