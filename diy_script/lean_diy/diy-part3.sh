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
# Compilation scripts for packages that need to be compiled in advance after toolchain compilation is completed
#

attempts=$1
# is_test=$2

# if [ $is_test -eq 100 ]; then
#   if [ $attempts -eq 3 ]; then
#     echo "attempts = 3 is true";
#   else
#     echo "attempts = $attempts ,not eq 3";
#   fi
#   exit
# fi

set -e
if [ $attempts -eq 3 ]; then



  make -j$(nproc) V=s \
    package/feeds/passwall/luci-app-passwall/compile \
    package/feeds/passwall2/luci-app-passwall2/compile \
    package/feeds/helloworld/luci-app-ssr-plus/compile \
    package/feeds/OpenClash/luci-app-openclash/compile \
    package/feeds/nikki/luci-app-nikki/compile \
    package/custom_packages/luci-theme-argon/compile \
    package/custom_packages/luci-app-argon-config/compile \
    package/custom_packages/luci-app-adguardhome/compile \
    package/custom_packages/mosdns/luci-app-mosdns/compile \
    package/custom_packages/netspeedtest/luci-app-netspeedtest/compile

else

  make -j$(nproc) \
    package/feeds/passwall/luci-app-passwall/compile \
    package/feeds/passwall2/luci-app-passwall2/compile \
    package/feeds/helloworld/luci-app-ssr-plus/compile \
    package/feeds/OpenClash/luci-app-openclash/compile \
    package/custom_packages/luci-theme-argon/compile \
    package/custom_packages/luci-app-argon-config/compile \
    package/custom_packages/luci-app-adguardhome/compile \
    package/custom_packages/mosdns/luci-app-mosdns/compile \
    package/custom_packages/netspeedtest/luci-app-netspeedtest/compile

fi