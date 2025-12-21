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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/immortalwrt_custom_feeds_and_packages.sh"

# ---------------------------------------------------------------feeds update---------------------------------------------------------------
# 备份原始 feeds.conf.default
cp feeds.conf.default feeds.conf.default.bak

# 删除 feeds.conf.default 中的注释行（以 # 开头）
sed -i '/^#/d' feeds.conf.default
sed -i -e 's|git.openwrt.org/feed|github.com/openwrt|g' -e 's|git.openwrt.org/project|github.com/openwrt|g' feeds.conf.default


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

clone_custom_packages