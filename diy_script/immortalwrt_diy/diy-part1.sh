#!/bin/bash
#
# Copyright (c) 2019-2023 SmallProgram <https://github.com/smallprogram>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/smallprogram/OpenWrtAction
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

rm -rf ./package/custom_packages
mkdir -p ./package/custom_packages

# Add Theme
rm -rf ./feeds/luci/themes/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git ./package/custom_packages/luci-theme-argon

rm -rf ./feeds/luci/applications/luci-app-argon-config
git clone https://github.com/jerrykuku/luci-app-argon-config.git ./package/custom_packages/luci-app-argon-config

# adguardhome
# rm -rf ./package/lean/luci-app-adguardhome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/custom_packages/luci-app-adguardhome

# mosdns

# find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
# find ./ | grep Makefile | grep mosdns | xargs rm -f
rm -rf ./feeds/luci/applications/luci-app-mosdns/
rm -rf ./feeds/packages/net/mosdns/
# rm -rf feeds/packages/net/v2ray-geodata/
git clone https://github.com/sbwml/luci-app-mosdns -b v5 ./package/custom_packages/mosdns
# git clone https://github.com/sbwml/v2ray-geodata ./package/custom_packages/v2ray-geodata

# git clone https://github.com/jerrykuku/lua-maxminddb.git
# git clone https://github.com/jerrykuku/luci-app-vssr.git


# Open App Filter
git clone https://github.com/destan19/OpenAppFilter.git ./package/custom_packages/luci-app-openappfilter

# Speedtest
git clone https://github.com/sirpdboy/netspeedtest.git ./package/custom_packages/netspeedtest


# smartdns
# git clone https://github.com/pymumu/smartdns.git ./package/custom_packages/smartdns
