#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/10.10.0.253/g' package/base-files/files/bin/config_generate

# Modify default passwd
sed -i '/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF./ d' package/lean/default-settings/files/zzz-default-settings

# Temporary repair https://github.com/coolsnowwolf/lede/issues/8423
# sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile


# 添加新主题
rm -rf ./feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git ./feeds/luci/themes/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git ./package/lean/luci-app-argon-config
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/lean/luci-app-adguardhome
# git clone https://github.com/jerrykuku/lua-maxminddb.git
# git clone https://github.com/jerrykuku/luci-app-vssr.git
# git clone https://github.com/lisaac/luci-app-dockerman.git

#恢复主机型号
sed -i 's/(dmesg | grep .*/{a}${b}${c}${d}${e}${f}/g' package/lean/autocore/files/x86/autocore
sed -i '/h=${g}.*/d' package/lean/autocore/files/x86/autocore
sed -i 's/echo $h/echo $g/g' package/lean/autocore/files/x86/autocore
