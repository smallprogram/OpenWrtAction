#!/bin/bash
#
# Copyright (c) 2019-2025 SmallProgram <https://github.com/smallprogram>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/smallprogram/OpenWrtAction
# File name: diy-part3.sh
# Description: OpenWrt DIY script part 3
# This script will be executed after `make defconfig` and `make download` to fix certain issues.
#

attempts=$1

echo "DiY script part 3: is Runing"

echo "修正相关package的hash值"

# -------------------------smartdns----------------------------------
echo "正在修正smartdns的hash值到最新版本"
current_path=$PWD
cd package/custom_packages/openwrt-smartdns
LATEST_TAG=$(curl -sL https://api.github.com/repos/pymumu/smartdns/releases/latest | jq -r .tag_name)
# 过滤掉开头的英文字符，按照openwrt规定
CLEAN_VERSION=$(echo "$LATEST_TAG" | sed 's/^[a-zA-Z_]*//')
LATEST_SMARTDNS=$(curl -sL "https://api.github.com/repos/pymumu/smartdns/commits/$LATEST_TAG" | jq -r .sha)
LATEST_WEBUI=$(curl -sL https://api.github.com/repos/pymumu/smartdns-webui/commits | jq -r '.[0].sha')
if [ -z "$LATEST_SMARTDNS" ] || [ "$LATEST_SMARTDNS" == "null" ]; then
    echo "Failed to fetch SmartDNS commit"
    exit 1
fi
echo ">> 获取到 SmartDNS 最新版本: $LATEST_TAG (Commit: $LATEST_SMARTDNS)"
echo ">> 提取到合法数字版本号: $CLEAN_VERSION (原始Tag: $LATEST_TAG)"
echo ">> 获取到 WebUI 最新 Commit: $LATEST_WEBUI"
sed -i "s/^PKG_VERSION:=.*/PKG_VERSION:=$CLEAN_VERSION/g" Makefile
sed -i "s/^PKG_RELEASE:=.*/PKG_RELEASE:=1/g" Makefile
sed -i "s/^PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=$LATEST_SMARTDNS/g" Makefile
sed -i "s/^SMARTDNS_WEBUI_SOURCE_VERSION:=.*/SMARTDNS_WEBUI_SOURCE_VERSION:=$LATEST_WEBUI/g" Makefile
sed -i "s/^PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=$LATEST_SMARTDNS/g" Makefile
sed -i "s/^SMARTDNS_WEBUI_SOURCE_VERSION:=.*/SMARTDNS_WEBUI_SOURCE_VERSION:=$LATEST_WEBUI/g" Makefile
sed -i 's/^PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=/g' Makefile
sed -i 's/^[[:space:]]*MIRROR_HASH:=.*/\tMIRROR_HASH:=/g' Makefile
cd $current_path

make package/custom_packages/openwrt-smartdns/download -j8
make package/custom_packages/openwrt-smartdns/check FIXUP=1 V=s
# -------------------------end-smartdns----------------------------------

# -------------------------shadowsocksr-libev----------------------------------
# make package/feeds/passwall_packages/shadowsocksr-libev/download -j8
# make package/feeds/passwall_packages/shadowsocksr-libev/check FIXUP=1 V=s
# -------------------------end-shadowsocksr-libev----------------------------------
echo "修正完成"


echo "DiY script part 3: is Completed"

# set -e
# if [ $attempts -eq 3 ]; then
#   make -j$(nproc) V=s \
#     package/feeds/passwall/luci-app-passwall/compile \
#     package/feeds/passwall2/luci-app-passwall2/compile \
#     package/feeds/helloworld/luci-app-ssr-plus/compile \
#     package/feeds/OpenClash/luci-app-openclash/compile \
#     package/feeds/nikki/luci-app-nikki/compile \
#     package/custom_packages/luci-app-alpha-config/compile \
#     package/custom_packages/luci-app-argon-config/compile \
#     package/custom_packages/luci-app-bandix/luci-app-bandix/compile \
#     package/custom_packages/openwrt-bandix/openwrt-bandix/compile \
#     package/custom_packages/luci-app-kucat-config/compile \
#     package/custom_packages/luci-theme-alpha/compile \
#     package/custom_packages/luci-theme-alpha-reborn/compile \
#     package/custom_packages/luci-theme-argon/compile \
#     package/custom_packages/luci-theme-aurora/compile \
#     package/custom_packages/luci-theme-kucat/compile \
#     package/custom_packages/luci-theme-material3/compile \
#     package/custom_packages/mosdns/luci-app-mosdns/compile \
#     package/custom_packages/netspeedtest/luci-app-netspeedtest/compile
    
# else
#   make -j$(nproc) \
#     package/feeds/passwall/luci-app-passwall/compile \
#     package/feeds/passwall2/luci-app-passwall2/compile \
#     package/feeds/helloworld/luci-app-ssr-plus/compile \
#     package/feeds/OpenClash/luci-app-openclash/compile \
#     package/feeds/nikki/luci-app-nikki/compile \
#     package/custom_packages/luci-app-alpha-config/compile \
#     package/custom_packages/luci-app-argon-config/compile \
#     package/custom_packages/luci-app-bandix/luci-app-bandix/compile \
#     package/custom_packages/openwrt-bandix/openwrt-bandix/compile \
#     package/custom_packages/luci-app-kucat-config/compile \
#     package/custom_packages/luci-theme-alpha/compile \
#     package/custom_packages/luci-theme-alpha-reborn/compile \
#     package/custom_packages/luci-theme-argon/compile \
#     package/custom_packages/luci-theme-aurora/compile \
#     package/custom_packages/luci-theme-kucat/compile \
#     package/custom_packages/luci-theme-material3/compile \
#     package/custom_packages/mosdns/luci-app-mosdns/compile \
#     package/custom_packages/netspeedtest/luci-app-netspeedtest/compile
# fi

# echo "DiY script part 3: is Disabled"