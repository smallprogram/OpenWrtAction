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
set -e
if [ $attempts -eq 3 ]; then



  make -j$(nproc) V=s \
    package/feeds/passwall/luci-app-passwall/compile \
    package/feeds/passwall2/luci-app-passwall2/compile \
    package/feeds/helloworld/luci-app-ssr-plus/compile \
    package/feeds/OpenClash/luci-app-openclash/compile \
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