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

set -e

make -j$(($(nproc)+1)) \
  package/libs/libpcap/compile \
  package/feeds/packages/libcap-ng/compile \
  package/feeds/packages/libwebp/compile \
  package/feeds/packages/coremark/compile \
  package/feeds/packages/libmspack/compile \
  package/feeds/packages/glib2/compile \
  package/libs/libubox/compile \
  package/libs/gettext-full/compile \
  package/feeds/packages/libvorbis/compile \
  package/network/ipv6/odhcp6c/compile \
  package/feeds/packages/htop/compile \
  package/kernel/cryptodev-linux/compile \
  package/kernel/r8168/compile \
  package/network/services/shellsync/compile \
  package/utils/busybox/compile \
  package/feeds/luci/lucihttp/compile \
  package/custom_packages/mosdns/v2dat/compile \
  package/feeds/packages/bash/compile \
  package/feeds/helloworld/dnsproxy/compile \
  package/feeds/passwall_packages/v2ray-plugin/compile \
  package/feeds/passwall_packages/xray-core/compile \
  package/feeds/packages/cloudflared/compile \
  package/utils/f2fs-tools/compile \
  package/network/utils/iproute2/compile \
  package/feeds/passwall_packages/trojan-plus/compile \
  package/network/services/uhttpd/compile \
  package/feeds/packages/strongswan/compile \
  package/feeds/packages/python3/compile \
  package/custom_packages/luci-app-argon-config/compile \
  package/boot/grub2/compile \
  package/feeds/luci/luci-app-zerotier/compile \
  package/feeds/luci/luci-app-minidlna/compile \
  package/feeds/packages/ddns-scripts/compile \
  package/feeds/packages/ddns-scripts_dnspod/compile \
  package/feeds/luci/luci-app-netdata/compile \
  package/feeds/passwall_packages/shadowsocks-rust/compile \
  package/feeds/packages/rustdesk-server/compile \
  package/feeds/packages/gnutls/compile \
  package/feeds/packages/rpcsvc-proto/compile \
  package/feeds/packages/open-vm-tools/compile \
  package/feeds/OpenClash/luci-app-openclash/compile \
  package/feeds/luci/luci-app-rustdesk-server/compile \
  package/feeds/helloworld/luci-app-ssr-plus/compile \
  package/feeds/packages/smartmontools/compile \
  package/feeds/luci/luci-app-wechatpush/compile \
  package/feeds/luci/luci-app-samba4/compile
