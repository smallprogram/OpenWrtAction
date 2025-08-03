#!/bin/bash
#
# Copyright (c) 2019-2025 SmallProgram <https://github.com/smallprogram>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/smallprogram/OpenWrtAction
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#



# Modify default IP
sed -i 's/192.168.1.1/10.10.0.253/g' package/base-files/files/bin/config_generate

# Modify default passwd
sed -i '/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF./ d' package/lean/default-settings/files/zzz-default-settings

# fixed rust host build download llvm in ci error
sed -i 's/--set=llvm\.download-ci-llvm=false/--set=llvm.download-ci-llvm=true/' feeds/packages/lang/rust/Makefile
grep -q -- '--ci false \\' feeds/packages/lang/rust/Makefile || sed -i '/x\.py \\/a \        --ci false \\' feeds/packages/lang/rust/Makefile

# Add patches
if [ "$GITHUB_ACTIONS" = "true" ] && [ -n "$GITHUB_RUN_ID" ] && [ -n "$GITHUB_WORKFLOW" ]; then
    # https://github.com/openwrt/packages/pull/27133
    # rpcsvc-proto: fix build with autotools gettext macros 0.22
    # cp -r $GITHUB_WORKSPACE/patches/rpcsvc-proto/* ./feeds/packages/libs/rpcsvc-proto
    echo "Patches applied from GitHub Actions workspace."
else
    # https://github.com/openwrt/packages/pull/27133
    # rpcsvc-proto: fix build with autotools gettext macros 0.22
    # cp -r ../OpenWrtAction/patches/rpcsvc-proto/* ./feeds/packages/libs/rpcsvc-proto
    echo "Patches applied from local OpenWrtAction repository."
fi

echo "DIY2 is complate!"