#!/bin/bash

export repos=(
  "src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main"
  "src-git passwall https://github.com/Openwrt-Passwall/openwrt-passwall.git;main"
  "src-git passwall2 https://github.com/Openwrt-Passwall/openwrt-passwall2.git;main"
  "src-git helloworld https://github.com/fw876/helloworld;master"
  "src-git OpenClash https://github.com/vernesong/OpenClash;master"
  "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main"
)


clone_custom_packages () {
    local path="./package/custom_packages/"

    rm -rf ${path}
    mkdir -p ${path}

    git clone https://github.com/jerrykuku/luci-theme-argon.git ${path}luci-theme-argon
    git clone https://github.com/jerrykuku/luci-app-argon-config.git ${path}luci-app-argon-config
    git clone https://github.com/sirpdboy/luci-theme-kucat.git ${path}luci-theme-kucat
    git clone https://github.com/sirpdboy/luci-app-kucat-config.git ${path}luci-app-kucat-config
    git clone https://github.com/eamonxg/luci-theme-aurora.git ${path}luci-theme-aurora
    git clone https://github.com/derisamedia/luci-theme-alpha-reborn.git ${path}luci-theme-alpha-reborn
    git clone https://github.com/derisamedia/luci-theme-alpha.git ${path}luci-theme-alpha
    git clone https://github.com/animegasan/luci-app-alpha-config.git ${path}luci-app-alpha-config
    git clone https://github.com/AngelaCooljx/luci-theme-material3.git ${path}luci-theme-material3
    # git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ${path}luci-app-adguardhome
    git clone https://github.com/sbwml/luci-app-mosdns -b v5 ${path}mosdns
    git clone https://github.com/sirpdboy/luci-app-netspeedtest ${path}netspeedtest
    git clone https://github.com/timsaya/openwrt-bandix.git ${path}openwrt-bandix
    git clone https://github.com/timsaya/luci-app-bandix.git ${path}luci-app-bandix
    git clone https://github.com/destan19/OpenAppFilter.git ${path}OpenAppFilter

    # sed -i '/^[\t ]*PKG_VERSION:=/ s/\(PKG_VERSION:= *\)[^0-9.]*\([0-9.]*\)[^0-9.]*/\1\2/' "${path}luci-theme-alpha-reborn/Makefile"
    sed -i '/^[\t ]*PKG_VERSION:=/ s/\(PKG_VERSION:= *\)[^0-9.]*\([0-9.]*\)[^0-9.]*/\1\2/' "${path}luci-theme-alpha/Makefile"

    
    local target="luci.main.mediaurlbase="

    echo "开始全量扫描并注释目标字符串, 取消主题自动设置为默认主题..."
    # 1. 扫描所有 Makefile 文件
    # 2. 扫描所有 uci-defaults 目录下的文件
    find "$path" -type f \( -name "Makefile" -o -path "*/etc/uci-defaults/*" \) | while read -r file; do
        
        # 这里的 grep 需要更宽松，因为 Makefile 里的行首可能是 Tab 或者是脚本定义的起始
        if grep -q "$target" "$file"; then
            echo "命中目标: $file"
            
            # 针对 Makefile 的特殊处理：
            # Makefile 里的 postrm 脚本行首通常会有空格或 Tab
            # 我们直接匹配包含 target 的行，并在该行非空字符前加 #
            # 使用 [[:blank:]]* 兼容 Tab 和空格
            sed -i "/$target/s/^\([[:blank:]]*\)\([^#[:blank:]]\)/\1# \2/" "$file"
        fi
    done

    echo "注释处理完成。"
}