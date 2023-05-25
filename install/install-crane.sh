#!/usr/bin/env bash

# Set version to latest unless set by user
unset VERSION
VERSION=$1
if [ -z "$VERSION" ]; then
  VERSION=$(curl --silent "https://api.github.com/repos/google/go-containerregistry/releases/latest" |jq -r .tag_name)
fi

UNAME_O=$(uname -o)
UNAME_M=$(uname -m)
echo "UNAME_M=$UNAME_M, UNAME_O=$UNAME_O"

if [[ $UNAME_O == "Darwin" ]]; then
  OS="Darwin"
else
  OS="Linux"
fi
if [[ $UNAME_M == "arm64" ]]
then
  ARCH="arm64"
elif [[ $UNAME_M == "x86_64" ]]
then
  ARCH="x86_64"
else
  exit 1
fi

echo "Downloading version ${VERSION}, OS ${OS}, arch. ${ARCH}..."
wget -nv "https://github.com/google/go-containerregistry/releases/download/${VERSION}/go-containerregistry_${OS}_${ARCH}.tar.gz" -O go-containerregistry.tar.gz
tar -zxvf go-containerregistry.tar.gz -C /usr/local/bin/ crane
