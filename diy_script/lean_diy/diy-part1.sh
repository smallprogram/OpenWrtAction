#!/bin/bash
#
# Copyright (c) 2019-2025 SmallProgram <https://github.com/smallprogram>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/smallprogram/OpenWrtAction
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# ---------------------------------------------------------------feeds update---------------------------------------------------------------
# 备份原始 feeds.conf.default
cp feeds.conf.default feeds.conf.default.bak

# 删除 feeds.conf.default 中的注释行（以 # 开头）
sed -i '/^#/d' feeds.conf.default

# 定义要添加的 feeds 数组
repos=(
  "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main"
  "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main"
  "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main"
  "src-git helloworld https://github.com/fw876/helloworld;master"
  "src-git OpenClash https://github.com/vernesong/OpenClash;master"
  "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main"
)

# 创建临时文件
temp_file=$(mktemp)

# 倒序遍历 repos 数组
for ((i=${#repos[@]}-1; i>=0; i--)); do
  repo="${repos[$i]}"
  # 提取 feed 名称（src-git 后的第一个字段）
  feed_name=$(echo "$repo" | awk '{print $2}')
  
  # 检查 feeds.conf.default 是否包含该 feed 名称
  if ! grep -q "src-git $feed_name " feeds.conf.default; then
    # 如果不存在，将该 repo 插入到临时文件的第一行
    echo "$repo" > "$temp_file"
    cat feeds.conf.default >> "$temp_file"
    mv "$temp_file" feeds.conf.default
    echo "Added: $repo"
  else
    echo "Skipped (already exists): $repo"
  fi
done

# 清理临时文件（如果仍然存在）
[ -f "$temp_file" ] && rm "$temp_file"

echo "Updated feeds.conf.default"
# ---------------------------------------------------------------end feeds update---------------------------------------------------------------

rm -rf ./package/custom_packages
mkdir -p ./package/custom_packages

git clone https://github.com/jerrykuku/luci-theme-argon.git ./package/custom_packages/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git ./package/custom_packages/luci-app-argon-config
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/custom_packages/luci-app-adguardhome
git clone https://github.com/sbwml/luci-app-mosdns -b v5 ./package/custom_packages/mosdns
git clone https://github.com/sirpdboy/luci-app-netspeedtest ./package/custom_packages/netspeedtest