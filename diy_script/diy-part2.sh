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

# Modify default passwd
sed -i '/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF./ d' package/lean/default-settings/files/zzz-default-settings

# Temporary repair https://github.com/coolsnowwolf/lede/issues/8423
# sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile


# 添加新主题
# rm -rf ./feeds/luci/themes/luci-theme-argon
# git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git ./feeds/luci/themes/luci-theme-argon
#git clone https://github.com/jerrykuku/luci-app-argon-config.git ./package/lean/luci-app-argon-config
if [ ! -d "./package/lean/luci-app-argon-config" ]; then git clone https://github.com/jerrykuku/luci-app-argon-config.git ./package/lean/luci-app-argon-config;   else cd ./package/lean/luci-app-argon-config; git stash; git stash drop; git pull; cd ..; cd ..; cd ..; fi;
#git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/lean/luci-app-adguardhome
if [ ! -d "./package/lean/luci-app-adguardhome" ]; then git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/lean/luci-app-adguardhome;   else cd ./package/lean/luci-app-adguardhome; git stash; git stash drop; git pull; cd ..; cd ..; cd ..; fi;
# git clone https://github.com/jerrykuku/lua-maxminddb.git
# git clone https://github.com/jerrykuku/luci-app-vssr.git
# git clone https://github.com/lisaac/luci-app-dockerman.git

#passwall
# git clone https://github.com/xiaorouji/openwrt-passwall.git -b packages ./package/lean/passwall_package
# git clone https://github.com/xiaorouji/openwrt-passwall.git -b luci ./package/lean/passwall
# cp -rf ./package/lean/passwall_package/* ./package/lean/passwall
# rm -rf ./package/lean/passwall_package

#恢复主机型号
# sed -i 's/(dmesg | grep .*/{a}${b}${c}${d}${e}${f}/g' package/lean/autocore/files/x86/autocore
# sed -i '/h=${g}.*/d' package/lean/autocore/files/x86/autocore
# sed -i 's/echo $h/echo $g/g' package/lean/autocore/files/x86/autocore

#关闭串口跑码
sed -i 's/console=tty0//g'  target/linux/x86/image/Makefile

#添加默认登录背景
rm -rf ./feeds/luci/themes/luci-theme-argon-mod/htdocs/luci-static/argon/background
mkdir -p ./feeds/luci/themes/luci-theme-argon-mod/htdocs/luci-static/argon/background
wget -P ./feeds/luci/themes/luci-theme-argon-mod/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/NetworkWorld1.mp4
wget -P ./feeds/luci/themes/luci-theme-argon-mod/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/NetworkWorld2.mp4
wget -P ./feeds/luci/themes/luci-theme-argon-mod/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/NetworkWorld3.mp4
wget -P ./feeds/luci/themes/luci-theme-argon-mod/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/video1.mp4
wget -P ./feeds/luci/themes/luci-theme-argon-mod/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/video2.mp4
wget -P ./feeds/luci/themes/luci-theme-argon-mod/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/video3.mp4
wget -P ./feeds/luci/themes/luci-theme-argon-mod/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/video4.mp4
wget -P ./feeds/luci/themes/luci-theme-argon-mod/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/video5.mp4
wget -P ./feeds/luci/themes/luci-theme-argon-mod/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/video6.mp4
wget -P ./feeds/luci/themes/luci-theme-argon-mod/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/img/1.jpg


rm -rf ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background
mkdir -p ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background
wget -P ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/NetworkWorld1.mp4
wget -P ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/NetworkWorld2.mp4
wget -P ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/NetworkWorld3.mp4
wget -P ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/video1.mp4
wget -P ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/video2.mp4
wget -P ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/video3.mp4
wget -P ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/video4.mp4
wget -P ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/video5.mp4
wget -P ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/video/video6.mp4
wget -P ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background https://github.com/smallprogram/OpenWrtAction/raw/main/source/img/1.jpg


#Diy
rm -rf ./feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
wget -P ./feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status https://github.com/smallprogram/OpenWrtAction/raw/main/source/openwrtfile/index.htm

#修复一些问题
## 修复mac80211编译报错
# cp -r $GITHUB_WORKSPACE/patches/651-rt2x00-driver-compile-with-kernel-5.15.patch $GITHUB_WORKSPACE/openwrt/package/kernel/mac80211/patches/rt2x00

#修复一些奇怪的hash问题
# sed -ri 's#42aa7c213dedbd95d33ca84d92f4187880f7e96062c6a3fb05bfb16f77ba2a91#88dcddf2a92b9dc9243e929340fdc6f3431b779e22438093d7a31a400f1c3909#' ./feeds/packages/utils/rrdtool1/Makefile
