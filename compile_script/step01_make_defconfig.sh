#!/bin/bash
source $GITHUB_WORKSPACE/compile_script/platforms.sh
source_code_platform=$1
CONFIGS=$2
Is_Copy_Seeds=$3

if [[ "$source_code_platform" == "openwrt" ]]; then
  selected_platforms=("${openwrt_platforms[@]}")
elif [[ "$source_code_platform" == "immortalwrt" ]]; then
  selected_platforms=("${immortalwrt_platforms[@]}")
# elif [[ "$source_code_platform" == "lede" ]]; then
#   selected_platforms=("${lede_platforms[@]}")
fi

cd ..
for i in "${selected_platforms[@]}"; do
    echo $i
    [ -e $CONFIGS/$i.config ] && cp -r $CONFIGS/$i.config openwrt/.config
    cd openwrt
    if [[ "$Is_Copy_Seeds" == "true" ]]; then
      echo ""
      echo "copy seed for $i platform....."
      cat $GITHUB_WORKSPACE/config/seed/${source_code_platform}_seed.config >> .config
      echo ""
    fi
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
