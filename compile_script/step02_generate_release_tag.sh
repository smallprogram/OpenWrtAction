#!/bin/bash

source_code_platform=$1
config=$2

source $GITHUB_WORKSPACE/compile_script/platforms.sh

if [[ "$source_code_platform" == "immortalwrt" ]]; then
  selected_platforms=("${immortalwrt_platforms[@]}")
elif [[ "$source_code_platform" == "openwrt" ]]; then
  selected_platforms=("${openwrt_platforms[@]}")
elif [[ "$source_code_platform" == "lede" ]]; then
  selected_platforms=("${lede_platforms[@]}")
fi

echo "<table>">>${source_code_platform}_release.txt
echo "  <tr>">>${source_code_platform}_release.txt
echo "    <th>platform</th>">>${source_code_platform}_release.txt
echo "    <th>source platform</th>">>${source_code_platform}_release.txt
echo "    <th>kernel</th>">>${source_code_platform}_release.txt
echo "    <th>target</th>">>${source_code_platform}_release.txt
echo "    <th>compile status</th>">>${source_code_platform}_release.txt
echo "  </tr>">>${source_code_platform}_release.txt

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

    # Get the kernel version from the corresponding kernel file
    kernel_version=$(sed -n '2p' "$GITHUB_WORKSPACE/openwrt/include/kernel-$kernel" | awk -F '-' '{print $2}' | awk -F ' =' '{print $1}')


    echo "  <tr>">>${source_code_platform}_release.txt
    echo "    <td>**:ice_cube: $platform**</td>">>${source_code_platform}_release.txt
    echo "    <td>**$source_code_platform**</td>">>${source_code_platform}_release.txt
    echo "    <td>**$kernel_version**</td>">>${source_code_platform}_release.txt
    echo "    <td>**$target_board**</td>">>${source_code_platform}_release.txt
    echo "    <td>![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)</td>">>${source_code_platform}_release.txt
    echo "  </tr>">>${source_code_platform}_release.txt

done
echo "</table>">>${source_code_platform}_release.txt

touch ${source_code_platform}_release.txt
echo 'status=success' >>$GITHUB_OUTPUT
