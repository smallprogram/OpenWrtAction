#!/bin/bash
source $GITHUB_WORKSPACE/compile_script/platforms.sh
source_code_platform=$1
CONFIGS=$2

if [[ "$source_code_platform" == "immortalwrt" ]]; then
  selected_platforms=("${immortalwrt_platforms[@]}")
elif [[ "$source_code_platform" == "openwrt" ]]; then
  selected_platforms=("${openwrt_platforms[@]}")
elif [[ "$source_code_platform" == "lede" ]]; then
  selected_platforms=("${lede_platforms[@]}")
fi

echo $source_code_platform
echo $CONFIGS

cd ..
for i in "${selected_platforms[@]}"; do
    echo $i
    [ -e $CONFIGS/$i.config ] && cp -r $CONFIGS/$i.config openwrt/.config
    cd openwrt
    echo ""
    echo "make defconfig for $i platform....."
    echo "result:"
    make defconfig
    echo ""
    cd ..
    cp -f openwrt/.config $CONFIGS/$i.config
done
cd openwrt
rm -rf .config
