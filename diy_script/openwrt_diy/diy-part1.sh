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

rm -rf ./package/custom_packages
mkdir -p ./package/custom_packages

git clone https://github.com/jerrykuku/luci-theme-argon.git ./package/custom_packages/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git ./package/custom_packages/luci-app-argon-config
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/custom_packages/luci-app-adguardhome
git clone https://github.com/sbwml/luci-app-mosdns -b v5 ./package/custom_packages/mosdns
git clone https://github.com/sirpdboy/luci-app-netspeedtest ./package/custom_packages/netspeedtest