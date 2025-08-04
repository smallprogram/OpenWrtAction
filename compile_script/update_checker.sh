#!/bin/bash

url=$1
branch=$2
num=$3

resp="${url##*/}"

cd $GITHUB_WORKSPACE
mkdir -p TMP_SHA_RESP
cd $GITHUB_WORKSPACE/TMP_SHA_RESP
if [ -n "$branch" ]; then
    git clone $url -b $branch --filter=blob:none
else
    git clone $url --filter=blob:none
fi
ls
cd $resp
echo "SHA_$num=$(git rev-parse --short HEAD)" >> $GITHUB_OUTPUT
cd $GITHUB_WORKSPACE
rm -rf TMP_SHA_RESP