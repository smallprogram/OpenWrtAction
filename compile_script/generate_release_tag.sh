#!/bin/bash

release_tag=$1

kernel_X86=$(grep -oP 'KERNEL_PATCHVER:=\K[^ ]+' $GITHUB_WORKSPACE/openwrt/target/linux/x86/Makefile)
kernel_X86_version=$(sed -n '2p' $GITHUB_WORKSPACE/openwrt/include/kernel-${kernel_X86} | awk -F '-' '{print $2}' | awk -F ' =' '{print $1}')
kernel_rockchip=$(grep -oP 'KERNEL_PATCHVER:=\K[^ ]+' $GITHUB_WORKSPACE/openwrt/target/linux/rockchip/Makefile)
kernel_rockchip_version=$(sed -n '2p' $GITHUB_WORKSPACE/openwrt/include/kernel-${kernel_rockchip} | awk -F '-' '{print $2}' | awk -F ' =' '{print $1}')
kernel_bcm27xx=$(grep -oP 'KERNEL_PATCHVER:=\K[^ ]+' $GITHUB_WORKSPACE/openwrt/target/linux/bcm27xx/Makefile)
kernel_bcm27xx_version=$(sed -n '2p' $GITHUB_WORKSPACE/openwrt/include/kernel-${kernel_bcm27xx} | awk -F '-' '{print $2}' | awk -F ' =' '{print $1}')
kernel_ipq60xx=$(grep -oP 'KERNEL_PATCHVER:=\K[^ ]+' $GITHUB_WORKSPACE/openwrt/target/linux/qualcommax/Makefile)
kernel_ipq60xx_version=$(sed -n '2p' $GITHUB_WORKSPACE/openwrt/include/kernel-${kernel_ipq60xx} | awk -F '-' '{print $2}' | awk -F ' =' '{print $1}')
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
echo "platform|kernel|compile status" >> release.txt
echo "-|-|-" >> release.txt
echo "**:ice_cube: X86**|**$kernel_X86_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: R5S**|**$kernel_rockchip_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: R5C**|**$kernel_rockchip_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: R4S**|**$kernel_rockchip_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: R4SE**|**$kernel_rockchip_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: R2S**|**$kernel_rockchip_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: R2C**|**$kernel_rockchip_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: H66K**|**$kernel_rockchip_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: H68K**|**$kernel_rockchip_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: H69K**|**$kernel_rockchip_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: R66S**|**$kernel_rockchip_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: R68S**|**$kernel_rockchip_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: R_Pi_3b**|**$kernel_bcm27xx_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: R_Pi_4b**|**$kernel_bcm27xx_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
echo "**:ice_cube: Redmi_AX5**|**$kernel_ipq60xx_version**|![](https://img.shields.io/badge/build-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellow&style=flat-square)" >> release.txt
touch release.txt
echo 'status=success' >> $GITHUB_OUTPUT