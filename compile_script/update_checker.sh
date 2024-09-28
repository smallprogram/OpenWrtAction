#!/bin/bash

url=$1
num=$2

resp="${url##*/}"
cd $GITHUB_WORKSPACE
git clone $url --filter=blob:none
echo $resp
cd $resp
echo "SHA_$num=$(git rev-parse --short HEAD)" >> $GITHUB_OUTPUT
cd
rm -rf $GITHUB_WORKSPACE/$resp