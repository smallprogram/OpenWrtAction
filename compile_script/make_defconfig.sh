#!/bin/bash

source $GITHUB_WORKSPACE/compile_script/platforms.sh
cd ..
for i in "${platforms[@]}"; do
    [ -e $CONFIGS/$i.config ] && cp -r $CONFIGS/$i.config openwrt/.config
    cd openwrt
    echo ""
    echo "make defconfig for $i platform....."
    echo "result:"
    make defconfig
    cd ..
    cp -f openwrt/.config $CONFIGS/$i.config
done
cd openwrt
rm -rf .config
