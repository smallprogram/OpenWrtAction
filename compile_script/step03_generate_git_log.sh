#!/bin/bash

source_code_platform=$1
cd $GITHUB_WORKSPACE

log_file="git_log_${source_code_platform}.txt"

echo "==== 🔍 开始收集真理源码 SHA 指纹 ===="

# 1. 记录主源码仓库 (openwrt / immortalwrt / lede)
main_sha=$(git -C openwrt log -n 1 --format="%H" 2>/dev/null)
echo "${source_code_platform}:${main_sha}" >> "$log_file"
echo "  [Main] ${source_code_platform}: ${main_sha}"

# 2. 动态遍历 feeds 和 package 下所有的独立 Git 仓库
find openwrt/feeds openwrt/package -type d -name ".git" 2>/dev/null | while read -r gitdir; do
    # 提取仓库的物理路径
    repo_dir=$(dirname "$gitdir")
    
    # 👑 神级操作：直接逼问 Git 底层，获取它真实的远端 URL
    repo_url=$(git -C "$repo_dir" config --get remote.origin.url 2>/dev/null)
    
    # 如果没有 url (极为罕见的情况)，则跳过
    if [ -z "$repo_url" ]; then
        continue
    fi
    
    # 👑 使用和 step06 绝对一致的正则切割逻辑！无论文件夹叫啥，暗号绝对匹配！
    repo_name="${repo_url##*/}"
    repo_name="${repo_name%.git}"
    
    # 提取该仓库真实的 SHA
    sha=$(git -C "$repo_dir" log -n 1 --format="%H" 2>/dev/null)
    
    # 写入真理日志
    if [ -n "$sha" ]; then
        echo "${repo_name}:${sha}" >> "$log_file"
        echo "  [Pack] ${repo_name}: ${sha}"
    fi
done

echo "==== ✅ SHA 指纹收集完毕 ===="

echo "status=success" >> $GITHUB_OUTPUT