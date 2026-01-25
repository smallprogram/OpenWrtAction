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
# sed -i '/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF./ d' package/lean/default-settings/files/zzz-default-settings


rm -rf temp_resp

# git clone -b master --single-branch https://github.com/openwrt/packages.git temp_resp/openwrt_packages
# git clone -b main --single-branch https://github.com/openwrt/openwrt.git temp_resp/openwrt_source

# update golang version
# rm -rf feeds/packages/lang/golang
# cp -rf temp_resp/openwrt_packages/lang/golang feeds/packages/lang
# rm -rf feeds/packages/lang/rust
# cp -rf temp_resp/openwrt_packages/lang/rust feeds/packages/lang
# cp -rf temp_resp/openwrt_source/scripts/patch-kernel.sh scripts/

    
git clone -b master --single-branch  https://github.com/immortalwrt/immortalwrt.git temp_resp/immortalwrt_source
git clone -b master --single-branch  https://github.com/immortalwrt/luci.git temp_resp/immortalwrt_luci
git clone -b master --single-branch  https://github.com/immortalwrt/packages.git temp_resp/immortalwrt_packages

# add some package from immortalwrt
# cp -rf temp_resp/immortalwrt_packages/utils/coremark ./feeds/packages
# cp -rf temp_resp/immortalwrt_source/package/emortal/autocore ./package/emortal
cp -rf temp_resp/immortalwrt_luci/applications/luci-app-cifs-mount ./feeds/luci/applications
cp -rf temp_resp/immortalwrt_luci/applications/luci-app-ddns-go ./feeds/luci/applications
cp -rf temp_resp/immortalwrt_packages/net/ddns-go ./feeds/packages/net
cp -rf temp_resp/immortalwrt_luci/applications/luci-app-diskman ./feeds/luci/applications
cp -rf temp_resp/immortalwrt_luci/applications/luci-app-eqos ./feeds/luci/applications
cp -rf temp_resp/immortalwrt_luci/applications/luci-app-homeproxy ./feeds/luci/applications
cp -rf temp_resp/immortalwrt_luci/applications/luci-app-netdata ./feeds/luci/applications
cp -rf temp_resp/immortalwrt_luci/applications/luci-app-ramfree ./feeds/luci/applications
cp -rf temp_resp/immortalwrt_luci/applications/luci-app-vlmcsd ./feeds/luci/applications
cp -rf temp_resp/immortalwrt_packages/net/vlmcsd ./feeds/packages/net
cp -rf temp_resp/immortalwrt_luci/applications/luci-app-wechatpush ./feeds/luci/applications

rm -rf temp_resp

./scripts/feeds update -a
./scripts/feeds install -a


# golnag update version to 1.25.6
# sed -i \
#   -e 's/^GO_VERSION_PATCH:=.*/GO_VERSION_PATCH:=6/' \
#   -e 's/^PKG_HASH:=.*/PKG_HASH:=58cbf771e44d76de6f56d19e33b77d745a1e489340922875e46585b975c2b059/' \
#   feeds/packages/lang/golang/golang/Makefile


# fixed rust host build download llvm in ci error
sed -i 's/--set=llvm\.download-ci-llvm=false/--set=llvm.download-ci-llvm=true/' feeds/packages/lang/rust/Makefile
grep -q -- '--ci false \\' feeds/packages/lang/rust/Makefile || sed -i '/x\.py \\/a \        --ci false \\' feeds/packages/lang/rust/Makefile


# Add patches
if [ "$GITHUB_ACTIONS" = "true" ] && [ -n "$GITHUB_RUN_ID" ] && [ -n "$GITHUB_WORKFLOW" ]; then
    PATCHES_SRC_DIR="$GITHUB_WORKSPACE"
else
    PATCHES_SRC_DIR="../OpenWrtAction"
fi

# https://github.com/openwrt/packages/pull/27133
# rpcsvc-proto: fix build with autotools gettext macros 0.22
# cp -r "$PATCHES_SRC_DIR/patches/rpcsvc-proto/*" ./feeds/packages/libs/rpcsvc-proto

# inject download package
mkdir -p dl
cp -r $PATCHES_SRC_DIR/library/* ./dl/


echo "DIY2 is complate!"
