#!/bin/bash
source $GITHUB_WORKSPACE/compile_script/main_and_feeds_url.sh

# 定义一个字符串变量用于累加 hash 值
HASH_STRING=""

echo "------------------------------------------------------------------------"
echo "-------------------------Begin Update Checker---------------------------"
echo "------------------------------------------------------------------------"

for url in "${all_REPO_URLS[@]}"; do
    # 分离 URL 和分支
    REPO_URL=$(echo "$url" | awk '{print $1}')
    BRANCH=$(echo "$url" | awk '{print $2}')
    
    echo "Checking $REPO_URL (Branch/Tag: ${BRANCH:-HEAD})..."
    
    # 👑 核心优化：使用 git ls-remote 直接探查远端，绝不 clone 代码！耗时从几分钟缩短到几秒！
    if [ -n "$BRANCH" ]; then
        # 查找指定分支的远端 Hash，截取前 7 位
        CURRENT_HASH=$(git ls-remote "$REPO_URL" "$BRANCH" | head -n 1 | awk '{print substr($1,1,7)}')
    else
        # 查找默认 HEAD 的远端 Hash，截取前 7 位
        CURRENT_HASH=$(git ls-remote "$REPO_URL" HEAD | head -n 1 | awk '{print substr($1,1,7)}')
    fi
    
    # 防呆校验：如果获取失败，给出明确提示
    if [ -z "$CURRENT_HASH" ]; then
        echo "  ⚠️ Warning: Failed to fetch hash for $REPO_URL"
    else
        echo "  ✅ Latest Hash: $CURRENT_HASH"
        HASH_STRING="${HASH_STRING}${CURRENT_HASH}"
    fi
done

# 输出最终的 hash 字符串
echo "------------------------------------------------------------------------"
echo "Raw combined hashes (Length: ${#HASH_STRING}): $HASH_STRING"

# 👑 核心优化：对无限变长的字符串进行 SHA-256 降维打击，生成绝对唯一的固定 64 位 Hash
FINAL_HASH=$(echo -n "$HASH_STRING" | sha256sum | awk '{print $1}')

echo "Final fixed-length hash: $FINAL_HASH"
# 将这个终极定长 Hash 传递给下个步骤
echo "FINAL_HASH=$FINAL_HASH" >> $GITHUB_OUTPUT
echo "HASH_STRING=$HASH_STRING" >> $GITHUB_OUTPUT
echo "------------------------------------------------------------------------"
echo "-------------------------End Update Checker---------------------------"
echo "------------------------------------------------------------------------"