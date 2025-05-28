#!/bin/bash
#
# Copyright (c) 2019-2025 SmallProgram <https://github.com/smallprogram>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/smallprogram/OpenWrtAction
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

cat << 'EOF' | cat - feeds.conf.default > temp && mv temp feeds.conf.default
src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main
src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main
src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main
src-git helloworld https://github.com/fw876/helloworld;master
src-git OpenClash https://github.com/vernesong/OpenClash;master
EOF

rm -rf ./package/custom_packages
mkdir -p ./package/custom_packages

git clone https://github.com/jerrykuku/luci-theme-argon.git ./package/custom_packages/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git ./package/custom_packages/luci-app-argon-config
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/custom_packages/luci-app-adguardhome
git clone https://github.com/sbwml/luci-app-mosdns -b v5 ./package/custom_packages/mosdns
git clone https://github.com/sirpdboy/luci-app-netspeedtest ./package/custom_packages/netspeedtest