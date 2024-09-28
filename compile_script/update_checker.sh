#!/bin/bash

url=$1
num=$2

resp="${url##*/}"

cd $GITHUB_WORKSPACE
mkdir -p TMP_SHA_RESP
cd $GITHUB_WORKSPACE/SHA_RESP
git clone $url --filter=blob:none
ls
cd $resp
echo "SHA_$num=$(git rev-parse --short HEAD)" >> $GITHUB_OUTPUT
cd $GITHUB_WORKSPACE
rm -rf TMP_SHA_RESP