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


# fixed rust host build download llvm in ci error
sed -i 's/--set=llvm\.download-ci-llvm=false/--set=llvm.download-ci-llvm=true/' feeds/packages/lang/rust/Makefile
grep -q -- '--ci false \\' feeds/packages/lang/rust/Makefile || sed -i '/x\.py \\/a \        --ci false \\' feeds/packages/lang/rust/Makefile

# update golang version
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang

# Add patches
if [ "$GITHUB_ACTIONS" = "true" ] && [ -n "$GITHUB_RUN_ID" ] && [ -n "$GITHUB_WORKFLOW" ]; then
    PATCHES_SRC_DIR="$GITHUB_WORKSPACE"
else
    PATCHES_SRC_DIR="../OpenWrtAction"
fi

# https://github.com/openwrt/packages/pull/27133
# rpcsvc-proto: fix build with autotools gettext macros 0.22
# cp -r "$PATCHES_SRC_DIR/patches/rpcsvc-proto/*" ./feeds/packages/libs/rpcsvc-proto


echo "DIY2 is complate!"