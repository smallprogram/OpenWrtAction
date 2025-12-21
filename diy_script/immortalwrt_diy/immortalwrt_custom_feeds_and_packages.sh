#!/bin/bash

export repos=(
  "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main"
  "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main"
  "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main"
  "src-git helloworld https://github.com/fw876/helloworld;master"
  "src-git OpenClash https://github.com/vernesong/OpenClash;master"
  "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main"
  "src-link custom_packages ./custom_packages"
)

clone_custom_packages () {
    rm -rf ./custom_packages
    mkdir -p ./custom_packages

    git clone https://github.com/jerrykuku/luci-theme-argon.git ./custom_packages/luci-theme-argon
    git clone https://github.com/jerrykuku/luci-app-argon-config.git ./custom_packages/luci-app-argon-config
    git clone https://github.com/sirpdboy/luci-theme-kucat.git ./custom_packages/luci-theme-kucat
    git clone https://github.com/sirpdboy/luci-app-kucat-config.git ./custom_packages/luci-app-kucat-config
    git clone https://github.com/eamonxg/luci-theme-aurora.git ./custom_packages/luci-theme-aurora
    git clone https://github.com/derisamedia/luci-theme-alpha.git ./custom_packages/luci-theme-alpha
    git clone https://github.com/animegasan/luci-app-alpha-config.git ./custom_packages/luci-app-alpha-config
    git clone https://github.com/AngelaCooljx/luci-theme-material3.git ./custom_packages/luci-theme-material3
    git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./custom_packages/luci-app-adguardhome
    git clone https://github.com/sbwml/luci-app-mosdns -b v5 ./custom_packages/mosdns
    git clone https://github.com/sirpdboy/luci-app-netspeedtest ./custom_packages/netspeedtest
    git clone https://github.com/timsaya/openwrt-bandix.git ./custom_packages/openwrt-bandix
    git clone https://github.com/timsaya/luci-app-bandix.git ./custom_packages/luci-app-bandix
    git clone https://github.com/destan19/OpenAppFilter.git ./custom_packages/OpenAppFilter


    sed -i '/^[\t ]*PKG_VERSION:=/ s/\(PKG_VERSION:= *\)[^0-9.]*\([0-9.]*\)[^0-9.]*/\1\2/' "./custom_packages/luci-theme-alpha/Makefile"
}