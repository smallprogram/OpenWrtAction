#!/bin/bash

# 加载平台配置
source $GITHUB_WORKSPACE/compile_script/platforms.sh
# 声明全局数组
declare -a openwrt_REPO_URLS=()
declare -a immortalwrt_REPO_URLS=()
declare -a lede_REPO_URLS=()
declare -a all_REPO_URLS=()  # 汇总所有仓库URL,用于updatecheacker.sh
declare -a feeds_REPO_URLS=(
    "https://github.com/fw876/helloworld"
    "https://github.com/Openwrt-Passwall/openwrt-passwall-packages"
    "https://github.com/Openwrt-Passwall/openwrt-passwall"
    "https://github.com/Openwrt-Passwall/openwrt-passwall2"
    "https://github.com/vernesong/OpenClash"
    "https://github.com/nikkinikki-org/OpenWrt-nikki"
)

declare -a custompackages_REPO_URLS=(
    https://github.com/jerrykuku/luci-theme-argon
    https://github.com/jerrykuku/luci-app-argon-config
    https://github.com/sirpdboy/luci-theme-kucat
    https://github.com/sirpdboy/luci-app-kucat-config
    https://github.com/eamonxg/luci-theme-aurora
    https://github.com/derisamedia/luci-theme-alpha.git
    https://github.com/animegasan/luci-app-alpha-config.git
    https://github.com/AngelaCooljx/luci-theme-material3.git
    https://github.com/rufengsuixing/luci-app-adguardhome
    https://github.com/sbwml/luci-app-mosdns
    https://github.com/sirpdboy/luci-app-netspeedtest
    https://github.com/timsaya/openwrt-bandix
    https://github.com/timsaya/luci-app-bandix
    https://github.com/destan19/OpenAppFilter
)

# 处理仓库函数
process_repo() {
    local repo_url="$1"
    local repo_branch="$2"
    local platform="$3"
    # repo_url="${repo_url%.git}" # 移除.git后缀
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
            echo "current openwrt_REPO_URLS: ${openwrt_REPO_URLS[*]}"
            ;;
        immortalwrt)
            immortalwrt_REPO_URLS+=("$repo_url $repo_branch")
            echo "current immortalwrt_REPO_URLS: ${immortalwrt_REPO_URLS[*]}"
            ;;
        lede)
            lede_REPO_URLS+=("$repo_url $repo_branch")
            echo "current lede_REPO_URLS: ${lede_REPO_URLS[*]}"
            ;;
    esac
    echo "Add main repos: $repo_url $repo_branch"
    while IFS= read -r line; do
        echo "Parsing Lines: $line"
        # 1. 空行跳过
        if [[ -z "$line" ]]; then
            continue
        fi
        # 2. 注释行（#开头）跳过
        if [[ "$line" =~ ^# ]]; then
            continue
        fi
        # 3. 解析 src-git 行
        if [[ "$line" =~ ^src-git[[:space:]]+[^[:space:]]+[[:space:]]+(https?://[^[:space:];]+)(;[^[:space:]]+)?$ ]]; then
            url="${BASH_REMATCH[1]}"
            #url="${url%.git}" # 移除.git后缀
            echo "url:$url"
            branch="${BASH_REMATCH[2]#;}" # 移除分号，空则保持空
            echo "branch:$branch"
            echo "extract URL: $url，branch: $branch"
            if [[ -n "$url" ]]; then
                # 根据是否有分支决定添加内容
                entry="$url"
                [[ -n "$branch" ]] && entry="$url $branch"
                case "$platform" in
                    openwrt)
                        openwrt_REPO_URLS+=("$entry")
                        echo "current openwrt_REPO_URLS: ${openwrt_REPO_URLS[*]}"
                        ;;
                    immortalwrt)
                        immortalwrt_REPO_URLS+=("$entry")
                        echo "current immortalwrt_REPO_URLS: ${immortalwrt_REPO_URLS[*]}"
                        ;;
                    lede)
                        lede_REPO_URLS+=("$entry")
                        echo "current lede_REPO_URLS: ${lede_REPO_URLS[*]}"
                        ;;
                esac
                echo "Add: $entry"
            fi
        else
            echo "Skip invalid rows: $line"
        fi
    done < "$feeds_file"
    rm -rf "$temp_dir"
    echo "Clean up the temporary directory: $temp_dir"
}

# 处理每个平台
for platform in "${source_code_platforms[@]}"; do
    echo "Start processing platform: $platform"
    value_var="${platform}_value"
    eval "value=\$${value_var}"
    if [[ -z "$value" ]]; then
        echo "error: not found $platform value"
        continue
    fi
    echo "platform $platform value: $value"
    repo_url=$(echo "$value" | grep -oP '"REPO_URL":\s*"\K[^"]+')
    repo_branch=$(echo "$value" | grep -oP '"REPO_BRANCH":\s*"\K[^"]+')
    echo "Parsing results: REPO_URL=$repo_url, REPO_BRANCH=$repo_branch"
    if [[ -z "$repo_url" || -z "$repo_branch" ]]; then
        echo "error: $platform  REPO_URL or REPO_BRANCH is empty"
        continue
    fi
    process_repo "$repo_url" "$repo_branch" "$platform"
done

# 检查数组内容
for platform in "${source_code_platforms[@]}"; do
    echo "platform: $platform"
    declare -n urls="${platform}_REPO_URLS"
    if [[ ${#urls[@]} -eq 0 ]]; then
        echo "  warning: ${platform}_REPO_URLS is empty"
    else
        echo "  info: ${urls[*]}"
        all_REPO_URLS+=("${urls[@]}")
    fi
done

all_REPO_URLS+=("${feeds_REPO_URLS[@]}")
