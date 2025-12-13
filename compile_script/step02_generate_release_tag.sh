#!/bin/bash

release_tag=$1
source_code_platform=$2
config=$3

source $GITHUB_WORKSPACE/compile_script/platforms.sh

# echo "[![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/$release_tag/total?style=flat-square)](https://github.com/smallprogram/MyAction)">> release.txt
# echo ""
# echo "## Source Code Information">> release.txt
# echo "[![](https://img.shields.io/badge/sorce-immortalwrt-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/immortalwrt/immortalwrt) [![](https://img.shields.io/badge/sorce-lean-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/coolsnowwolf/lede) [![](https://img.shields.io/badge/sorce-openwrt-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/openwrt/openwrt)
# ">> release.txt
# echo ""
# echo "## Build Information"

# echo "<table>">>release.txt
# echo "  <tr>">>release.txt
# echo "    <th>platform</th>">>release.txt
# echo "    <th>source platform</th>">>release.txt
# echo "    <th>kernel</th>">>release.txt
# echo "    <th>target</th>">>release.txt
# echo "    <th>compile status</th>">>release.txt
# echo "  </tr>">>release.txt



if [[ "$source_code_platform" == "openwrt" ]]; then
  selected_platforms=("${openwrt_platforms[@]}")
elif [[ "$source_code_platform" == "immortalwrt" ]]; then
  selected_platforms=("${immortalwrt_platforms[@]}")
elif [[ "$source_code_platform" == "lede" ]]; then
  selected_platforms=("${lede_platforms[@]}")
fi


for platform in "${selected_platforms[@]}"; do
    # Construct the path to the .config file
    config_file="$GITHUB_WORKSPACE/$config/$platform.config"

    # Extract the CONFIG_TARGET_BOARD value
    if [[ -f $config_file ]]; then
        target_board=$(grep 'CONFIG_TARGET_BOARD=' "$config_file" | awk -F '=' '{print $2}' | tr -d '"')
    else
        echo "Config file for $platform not found."
        continue
    fi

    # Extract the KERNEL_PATCHVER value from the Makefile
    kernel=$(grep -oP 'KERNEL_PATCHVER:=\K[^ ]+' "$GITHUB_WORKSPACE/openwrt/target/linux/$target_board/Makefile")

    # kernel_version=$(sed -n '2p' "$GITHUB_WORKSPACE/openwrt/include/kernel-$kernel" | awk -F '-' '{print $2}' | awk -F ' =' '{print $1}')

    # Get the kernel version from the corresponding kernel file
    if [[ "$source_code_platform" == "lede" ]]; then
      kernel_version=$(sed -n '2p' "$GITHUB_WORKSPACE/openwrt/include/kernel-$kernel" | awk -F '-' '{print $2}' | awk -F ' =' '{print $1}')
    else
      kernel_version=$(sed -n '2p' "$GITHUB_WORKSPACE/openwrt/target/linux/generic/kernel-$kernel" | awk -F '-' '{print $2}' | awk -F ' =' '{print $1}')  
    fi


    echo "  <tr>">>release_$source_code_platform.txt
    echo "    <td><strong>🧊 $platform</strong></td>">>release_$source_code_platform.txt
    echo "    <td><strong>$source_code_platform</strong></td>">>release_$source_code_platform.txt
    echo "    <td><strong>$kernel_version</strong></td>">>release_$source_code_platform.txt
    echo "    <td><strong>$target_board</strong></td>">>release_$source_code_platform.txt
    echo "    <td><img scp=\"$source_code_platform\" plm=\"$platform\" src=\"https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square\" alt=\"build status\"/></td>">>release_$source_code_platform.txt
    echo "  </tr>">>release_$source_code_platform.txt

done


# echo "</table>">>release.txt

touch release_$source_code_platform.txt
echo 'status=success' >>$GITHUB_OUTPUT
