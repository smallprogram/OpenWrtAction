#!/bin/bash
#
# Copyright (c) 2019-2023 SmallProgram <https://github.com/smallprogram>
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

# rollback ruby verion from 3.3.4 to 3.2.2
# cd feeds/packages
# git fetch --unshallow
# git checkout 565e79e73619f806bc56ef189917ba013f306023 -- lang/ruby
# git checkout HEAD -- lang/ruby
# cd ..
# cd ..


# Modify default passwd
# sed -i '/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF./ d' package/lean/default-settings/files/zzz-default-settings

# Temporary Fix
# sed -i '/^UBOOT_TARGETS := rk3528-evb rk3588-evb/s/^/#/' package/boot/uboot-rk35xx/Makefile

# Reset drive type
# sed -i 's/(dmesg | grep .*/{a}${b}${c}${d}${e}${f}/g' package/lean/autocore/files/x86/autocore
# sed -i '/h=${g}.*/d' package/lean/autocore/files/x86/autocore
# sed -i 's/echo $h/echo $g/g' package/lean/autocore/files/x86/autocore

# Close running yards
# sed -i 's/console=tty0//g'  target/linux/x86/image/Makefile

# Diy
# rm -rf ./feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
# wget -P ./feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status https://github.com/smallprogram/OpenWrtAction/raw/main/source/openwrtfile/index.htm

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

# homeproxy incloude luci pakcage
# git clone https://github.com/immortalwrt/homeproxy.git ./package/custom_packages/homeproxy

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
# git clone https://github.com/destan19/OpenAppFilter.git ./package/custom_packages/luci-app-openappfilter

# Speedtest
git clone https://github.com/sirpdboy/netspeedtest.git ./package/custom_packages/netspeedtest


# delete immortalwrt passwall packages
rm -rf ./feeds/packages/net/brook
rm -rf ./feeds/packages/net/chinadns-ng
rm -rf ./feeds/packages/net/dns2socks
rm -rf ./feeds/packages/net/dns2tcp
rm -rf ./feeds/packages/net/geoview
rm -rf ./feeds/packages/net/hysteria
rm -rf ./feeds/packages/net/ipt2socks
rm -rf ./feeds/packages/net/microsocks
rm -rf ./feeds/packages/net/naiveproxy
rm -rf ./feeds/packages/net/shadowsocks-rust
rm -rf ./feeds/packages/net/simple-obfs
rm -rf ./feeds/packages/net/sing-box
rm -rf ./feeds/packages/net/tcping
rm -rf ./feeds/packages/net/trojan
rm -rf ./feeds/packages/net/trojan-go
rm -rf ./feeds/packages/net/trojan-plus
rm -rf ./feeds/packages/net/tuic-client
rm -rf ./feeds/packages/net/v2ray-core
rm -rf ./feeds/packages/net/v2ray-geodata
rm -rf ./feeds/packages/net/v2ray-plugin
rm -rf ./feeds/packages/net/xray-core
rm -rf ./feeds/packages/net/xray-plugin


# smartdns
# git clone https://github.com/pymumu/smartdns.git ./package/custom_packages/smartdns


echo "DIY2 is complate!"