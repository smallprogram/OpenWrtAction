#!/bin/bash

url=$1
num=$2

resp="${url##*/}"

git clone $url --filter=blob:none
cd $resp
echo "SHA_$num=$(git rev-parse --short HEAD)" >> $GITHUB_OUTPUT
cd
rm -rf $resp