#!/bin/bash

export repos=(
  "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main"
  "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main"
  "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main"
  "src-git helloworld https://github.com/fw876/helloworld;master"
  "src-git OpenClash https://github.com/vernesong/OpenClash;master"
  "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main"
)

clone_custom_packages () {
    rm -rf ./package/custom_packages
    mkdir -p ./package/custom_packages

    git clone https://github.com/jerrykuku/luci-theme-argon.git ./package/custom_packages/luci-theme-argon
    git clone https://github.com/jerrykuku/luci-app-argon-config.git ./package/custom_packages/luci-app-argon-config
    git clone https://github.com/sirpdboy/luci-theme-kucat.git ./package/custom_packages/luci-theme-kucat
    git clone https://github.com/sirpdboy/luci-app-kucat-config.git ./package/custom_packages/luci-app-kucat-config
    git clone https://github.com/eamonxg/luci-theme-aurora.git ./package/custom_packages/luci-theme-aurora
    git clone https://github.com/derisamedia/luci-theme-alpha.git ./package/custom_packages/luci-theme-alpha
    git clone https://github.com/animegasan/luci-app-alpha-config.git ./package/custom_packages/luci-app-alpha-config
    git clone https://github.com/AngelaCooljx/luci-theme-material3.git ./package/custom_packages/luci-theme-material3
    git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/custom_packages/luci-app-adguardhome
    git clone https://github.com/sbwml/luci-app-mosdns -b v5 ./package/custom_packages/mosdns
    git clone https://github.com/sirpdboy/luci-app-netspeedtest ./package/custom_packages/netspeedtest
    git clone https://github.com/timsaya/openwrt-bandix.git ./package/custom_packages/openwrt-bandix
    git clone https://github.com/timsaya/luci-app-bandix.git ./package/custom_packages/luci-app-bandix
    git clone https://github.com/destan19/OpenAppFilter.git ./package/custom_packages/OpenAppFilter


    sed -i '/^[\t ]*PKG_VERSION:=/ s/\(PKG_VERSION:= *\)[^0-9.]*\([0-9.]*\)[^0-9.]*/\1\2/' "./package/custom_packages/luci-theme-alpha/Makefile"


    rm -rf temp_resp
    git clone -b master --single-branch  https://github.com/immortalwrt/immortalwrt.git temp_resp/immortalwrt_source
    git clone -b master --single-branch  https://github.com/immortalwrt/luci.git temp_resp/immortalwrt_luci
    git clone -b master --single-branch  https://github.com/immortalwrt/packages.git temp_resp/immortalwrt_packages

    # add some package from immortalwrt
    cp -rf temp_resp/immortalwrt_packages/utils/coremark ./package/custom_packages
    cp -rf temp_resp/immortalwrt_source/package/emortal/autocore ./package/custom_packages
    cp -rf temp_resp/immortalwrt_luci/applications/luci-app-cifs-mount ./package/custom_packages
    cp -rf temp_resp/immortalwrt_luci/applications/luci-app-ddns-go ./package/custom_packages
    cp -rf temp_resp/immortalwrt_packages/net/ddns-go ./package/custom_packages
    cp -rf temp_resp/immortalwrt_luci/applications/luci-app-diskman ./package/custom_packages
    cp -rf temp_resp/immortalwrt_luci/applications/luci-app-eqos ./package/custom_packages
    cp -rf temp_resp/immortalwrt_luci/applications/luci-app-homeproxy ./package/custom_packages
    cp -rf temp_resp/immortalwrt_luci/applications/luci-app-netdata ./package/custom_packages
    cp -rf temp_resp/immortalwrt_luci/applications/luci-app-ramfree ./package/custom_packages
    cp -rf temp_resp/immortalwrt_luci/applications/luci-app-vlmcsd ./package/custom_packages
    cp -rf temp_resp/immortalwrt_packages/net/vlmcsd ./package/custom_packages
    cp -rf temp_resp/immortalwrt_luci/applications/luci-app-wechatpush ./package/custom_packages

    rm -rf temp_resp

}