#!/bin/bash

release_tag=$1

source $GITHUB_WORKSPACE/compile_script/platforms.sh

openwrt_version=$(grep -o "DISTRIB_REVISION='[^']*'" $GITHUB_WORKSPACE/openwrt/package/lean/default-settings/files/zzz-default-settings | sed "s/DISTRIB_REVISION='\([^']*\)'/\1/")


echo "![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/$release_tag/total?style=flat-square)" >> release.txt
echo "### Firmware Information" >> release.txt
echo "**:loudspeaker:Cancel the ext4 format and only keep the squashfs format.**" >> release.txt
echo "**:computer:Including traditional IMG format firmware and UEFI boot firmware.**" >> release.txt
echo "**:cd:Including qcow2 format firmware and UEFI boot firmware supporting pve virtual machine.**" >> release.txt
echo "**:cd:Including vdi format firmware and UEFI boot firmware supporting Visual Box virtual machine.**" >> release.txt
echo "**:cd:Including vhdx format firmware and UEFI boot firmware supporting Hyper-v virtual machines.**" >> release.txt
echo "**:dvd:Including vmdk format firmware and UEFI boot firmware that support ESXi virtual machines (8.0 requires tool conversion).**" >> release.txt
echo "### Openwrt Information" >> release.txt
echo "**:minidisc: OpenWrt Version: $openwrt_version**" >> release.txt
#echo "**:gear: Default-Setting Version: $PKG_VERSION.$PKG_RELEASE**" >> release.txt
echo "### Compile Information" >> release.txt
echo "platform|kernel|target|compile status" >> release.txt
echo "-|-|-|-" >> release.txt

for platform in "${platforms[@]}"; do
    # Construct the path to the .config file
    config_file="$GITHUB_WORKSPACE/config/leanlede_config/$platform.config"
    
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
    
    # Write the result to release.txt
    echo "**:ice_cube: $platform**|**$kernel_version**|**$target_board**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
done


             
touch release.txt
echo 'status=success' >> $GITHUB_OUTPUT