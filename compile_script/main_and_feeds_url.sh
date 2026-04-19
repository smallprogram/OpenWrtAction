#!/bin/bash

# 加载平台配置
source $GITHUB_WORKSPACE/compile_script/platforms.sh

# 声明全局数组
declare -a openwrt_REPO_URLS=() 
declare -a immortalwrt_REPO_URLS=()
declare -a lede_REPO_URLS=() 
declare -a all_REPO_URLS=()

# ==========================================
# 👑 核心改造一：动态解析 feeds_REPO_URLS
# 直接 source 自定义文件，提取 repos 数组中的 URL 和 分支
# ==========================================
declare -a feeds_REPO_URLS=()

CUSTOM_SCRIPT="$GITHUB_WORKSPACE/diy_script/custom_feeds_and_packages.sh"

if [ -f "$CUSTOM_SCRIPT" ]; then
    echo "发现 custom_feeds_and_packages.sh，开始动态解析 feeds..."
    source "$CUSTOM_SCRIPT"
    
    for repo in "${repos[@]}"; do
        # 提取 URL 部分 (例如: https://github.com/...;main)
        raw_url=$(echo "$repo" | awk '{print $3}')
        # 分离出纯 URL 和 分支
        clean_url=$(echo "$raw_url" | cut -d ';' -f 1)
        branch=$(echo "$raw_url" | cut -d ';' -f 2)
        
        # 组装并压入数组
        if [ "$clean_url" == "$branch" ] || [ -z "$branch" ]; then
            feeds_REPO_URLS+=("$clean_url")
        else
            feeds_REPO_URLS+=("$clean_url $branch")
        fi
    done
else
    echo "⚠️ 警告: 未找到 $CUSTOM_SCRIPT"
fi

# ==========================================
# 👑 核心改造二：动态解析 custompackages_REPO_URLS
# 用正则匹配提取 git clone 命令里的 URL 和 -b 分支
# ==========================================
declare -a custompackages_REPO_URLS=()

if [ -f "$CUSTOM_SCRIPT" ]; then
    echo "开始动态解析 custom packages..."
    # 提取所有以 git clone 开头（忽略缩进和注释）的行
    while read -r line; do
        # 提取 https:// 开头的 URL
        url=$(echo "$line" | grep -oP 'https?://\S+')
        # 提取 -b 后面跟着的分支名
        branch=""
        if echo "$line" | grep -q '\-b '; then
            branch=$(echo "$line" | grep -oP '\-b \K\S+')
        fi
        
        if [ -n "$url" ]; then
            if [ -n "$branch" ]; then
                custompackages_REPO_URLS+=("$url $branch")
            else
                custompackages_REPO_URLS+=("$url")
            fi
        fi
    done < <(grep -E '^[[:space:]]*git clone' "$CUSTOM_SCRIPT")
fi

# 打印解析结果以供日志审查
echo "=========================================="
echo "动态加载到的 Feeds URLs:"
printf "  - %s\n" "${feeds_REPO_URLS[@]}"
echo "动态加载到的 Custom Packages URLs:"
printf "  - %s\n" "${custompackages_REPO_URLS[@]}"
echo "=========================================="


# 下方是你原本的解析逻辑，一字未改！
# 处理仓库函数
process_repo() {
    local repo_url="$1"
    local repo_branch="$2"
    local platform="$3"
    echo "platform $platform: clone $repo_url（branch: $repo_branch）"
    local temp_dir="temp_clone_$platform"
    mkdir -p "$temp_dir"
    git clone --filter=blob:none --branch "$repo_branch" "$repo_url" "$temp_dir"
    if [[ $? -ne 0 ]]; then
        echo "error: clone $repo_url failed"
        exit 1
    fi
    local feeds_file="$temp_dir/feeds.conf.default"
    if [[ ! -f "$feeds_file" ]]; then
        echo "error: not found $feeds_file"
        rm -rf "$temp_dir"
        return 1
    fi
    echo "find feeds.conf file: $feeds_file"
    case "$platform" in
        openwrt)
            sed -i -e 's|git.openwrt.org/feed|github.com/openwrt|g' -e 's|git.openwrt.org/project|github.com/openwrt|g' "$feeds_file"
            openwrt_REPO_URLS+=("$repo_url $repo_branch")
            ;;
        immortalwrt)
            immortalwrt_REPO_URLS+=("$repo_url $repo_branch")
            ;;
        lede)
            lede_REPO_URLS+=("$repo_url $repo_branch")
            ;;
    esac
    while IFS= read -r line; do
        if [[ -z "$line" ]] || [[ "$line" =~ ^# ]]; then continue; fi
        if [[ "$line" =~ ^src-git[[:space:]]+[^[:space:]]+[[:space:]]+(https?://[^[:space:];]+)(;[^[:space:]]+)?$ ]]; then
            url="${BASH_REMATCH[1]}"
            branch="${BASH_REMATCH[2]#;}" 
            if [[ -n "$url" ]]; then
                entry="$url"
                [[ -n "$branch" ]] && entry="$url $branch"
                case "$platform" in
                    openwrt) openwrt_REPO_URLS+=("$entry") ;;
                    immortalwrt) immortalwrt_REPO_URLS+=("$entry") ;;
                    lede) lede_REPO_URLS+=("$entry") ;;
                esac
            fi
        fi
    done < "$feeds_file"
    rm -rf "$temp_dir"
}

# 处理每个平台
for platform in "${source_code_platforms[@]}"; do
    value_var="${platform}_value"
    eval "value=\$${value_var}"
    if [[ -z "$value" ]]; then continue; fi
    repo_url=$(echo "$value" | grep -oP '"REPO_URL":\s*"\K[^"]+')
    repo_branch=$(echo "$value" | grep -oP '"REPO_BRANCH":\s*"\K[^"]+')
    if [[ -z "$repo_url" || -z "$repo_branch" ]]; then continue; fi
    process_repo "$repo_url" "$repo_branch" "$platform"
done

# 检查数组内容
for platform in "${source_code_platforms[@]}"; do
    declare -n urls="${platform}_REPO_URLS"
    if [[ ${#urls[@]} -gt 0 ]]; then
        all_REPO_URLS+=("${urls[@]}")
    fi
done

all_REPO_URLS+=("${feeds_REPO_URLS[@]}")