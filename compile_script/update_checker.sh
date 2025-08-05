#!/bin/bash
source $GITHUB_WORKSPACE/compile_script/main_and_feeds_url.sh

# 定义一个字符串变量用于累加 hash 值
HASH_STRING=""

for url in "${all_REPO_URLS[@]}"; do
    cd $GITHUB_WORKSPACE
    mkdir -p TMP_SHA_RESP
    cd $GITHUB_WORKSPACE/TMP_SHA_RESP
    # 分离 URL 和分支
    REPO_URL=$(echo "$url" | awk '{print $1}')
    BRANCH=$(echo "$url" | awk '{print $2}')
    resp="${REPO_URL##*/}"
    # 克隆仓库
    if [ -n "$BRANCH" ]; then
        git clone "$REPO_URL" --filter=blob:none --branch "$BRANCH"
    else
        git clone "$REPO_URL" --filter=blob:none
    fi
    cd $resp
    # 获取当前仓库的短 hash 并追加到 HASH_STRING，无空格
    CURRENT_HASH=$(git rev-parse --short HEAD)
    HASH_STRING="${HASH_STRING}${CURRENT_HASH}"
    
    cd $GITHUB_WORKSPACE
    rm -rf TMP_SHA_RESP
done

# 输出最终的 hash 字符串
echo "All hashes: $HASH_STRING"
echo "HASH_STRING=$HASH_STRING" >> $GITHUB_OUTPUT
