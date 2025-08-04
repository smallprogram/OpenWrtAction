#!/bin/bash
release_tag=$1
git_folders=(openwrt immortalwrt lede feeds)

openwrt_REPO_URLS=(
    "https://github.com/openwrt/openwrt openwrt-24.10"
    "https://github.com/openwrt/packages openwrt-24.10"
    "https://github.com/openwrt/luci openwrt-24.10"
    "https://github.com/openwrt/routing openwrt-24.10"
    "https://github.com/openwrt/telephony openwrt-24.10"
)

immortalwrt_REPO_URLS=(
    "https://github.com/immortalwrt/immortalwrt openwrt-24.10"
    "https://github.com/immortalwrt/packages openwrt-24.10"
    "https://github.com/immortalwrt/luci openwrt-24.10"
)

lede_REPO_URLS=(
    "https://github.com/coolsnowwolf/lede"
    "https://github.com/coolsnowwolf/packages"
    "https://github.com/coolsnowwolf/luci openwrt-23.05"
    "https://github.com/coolsnowwolf/routing"
    "https://github.com/coolsnowwolf/telephony"
)

feeds_REPO_URLS=(
    "https://github.com/fw876/helloworld"
    "https://github.com/xiaorouji/openwrt-passwall-packages"
    "https://github.com/xiaorouji/openwrt-passwall"
    "https://github.com/xiaorouji/openwrt-passwall2"
    "https://github.com/vernesong/OpenClash"
    "https://github.com/nikkinikki-org/OpenWrt-nikki"
)

cd $GITHUB_WORKSPACE

# 初始化 release.txt
echo "[![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/$release_tag/total?style=flat-square)](https://github.com/smallprogram/MyAction)"> release.txt

echo "">> release.txt
echo "## Source Code Information">> release.txt
echo "[![](https://img.shields.io/badge/source-openwrt_24.10-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/openwrt/openwrt) [![](https://img.shields.io/badge/source-immortalwrt_24.10-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/immortalwrt/immortalwrt) [![](https://img.shields.io/badge/source-lean_SNAPSHOT-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/coolsnowwolf/lede)">> release.txt
echo "">>release.txt
echo "## Build Information">> release.txt

echo "<table>">>release.txt
echo "  <tr>">>release.txt
echo "    <th>platform</th>">>release.txt
echo "    <th>source platform</th>">>release.txt
echo "    <th>kernel</th>">>release.txt
echo "    <th>target</th>">>release.txt
echo "    <th>compile status</th>">>release.txt
echo "  </tr>">>release.txt

for git_folder in "${git_folders[@]}"; do
    if [[ "$git_folder" == "feeds" ]]; then
        echo "jump $git_folder"
    else
        cat release_$git_folder.txt >> release.txt
    fi
done
echo "</table>">>release.txt
echo "">>release.txt
echo "## What's Changed" >>release.txt
echo "">>release.txt

# 清理 git_log 目录中的非 log 文件
find git_log -type f ! -name 'log' -exec rm {} +
mkdir -p git_repositories

for git_folder in "${git_folders[@]}"; do
    echo "git_folder: $git_folder"
    declare -n repo_urls="${git_folder}_REPO_URLS"

    if [[ "$git_folder" == "feeds" ]]; then
        echo "">>release.txt
        echo "### common $git_folder" >>release.txt
        echo "">>release.txt
    else
        echo "">>release.txt
        echo "### $git_folder" >>release.txt
        echo "">>release.txt
    fi

    UPDATE_COUNT=0
    for url in "${repo_urls[@]}"; do
        # 分离 URL 和分支
        REPO_URL=$(echo "$url" | awk '{print $1}')
        BRANCH=$(echo "$url" | awk '{print $2}')
        OUTPUT_FILE="${REPO_URL##*/}"
        TITLE_MESSAGE="${OUTPUT_FILE} new commit log"

        # 克隆仓库
        if [ -n "$BRANCH" ]; then
            git clone "$REPO_URL" --filter=blob:none --branch "$BRANCH" "git_repositories/$git_folder/$OUTPUT_FILE"
        else
            git clone "$REPO_URL" --filter=blob:none "git_repositories/$git_folder/$OUTPUT_FILE"
        fi

        # 获取最新 SHA
        SHA_End=$(git -C "git_repositories/$git_folder/$OUTPUT_FILE" rev-parse HEAD)
        echo "$git_folder-$OUTPUT_FILE Begin git log update-----------------------------------------------------------"
        echo "SHAEnd:$SHA_End"

        # 检查 log 文件是否存在且是否包含 OUTPUT_FILE 条目
        SHA_Begin=$(grep "^${OUTPUT_FILE}:" "git_log/${git_folder}/log" | cut -d: -f2)
        echo "SHABegin:$SHA_Begin"

        # 如果 log 文件不存在或为空，或者没有 OUTPUT_FILE 条目，初始化 log 文件
        if [ ! -f "git_log/$git_folder/log" ] || ! grep -q "^${OUTPUT_FILE}:" "git_log/$git_folder/log"; then
            echo "${OUTPUT_FILE}:${SHA_End}" >> "git_log/$git_folder/log"
            SHA_Begin=""
        fi

        # 检查 SHA 是否有效
        if ! git -C "git_repositories/$git_folder/$OUTPUT_FILE" cat-file -t "$SHA_Begin" >/dev/null 2>&1 && [ -n "$SHA_Begin" ]; then
            echo "     :x: Invalid SHA detected (Begin: $SHA_Begin, End: $SHA_End) for $OUTPUT_FILE"
            echo "<details> <summary> <b>$TITLE_MESSAGE :x: </b> </summary>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "<b> It is detected that $OUTPUT_FILE has an illegal SHA value. It is possible that $OUTPUT_FILE has git rebase behavior. The relevant git update log cannot be counted. Please wait for the next compilation time.</b>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "</details>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            sed -i "s/^${OUTPUT_FILE}:.*/${OUTPUT_FILE}:${SHA_End}/" "git_log/$git_folder/log"
            UPDATE_COUNT=$((UPDATE_COUNT + 1))
        elif [ -z "$SHA_Begin" ] || [ "$SHA_Begin" != "$SHA_End" ]; then
            echo "<details> <summary> <b>$TITLE_MESSAGE :rocket: </b> </summary>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            if [ -z "$SHA_Begin" ]; then
                echo "<b>Initial commit log for $OUTPUT_FILE, no previous SHA.</b>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            else
                echo "SHA|Author|Date|Message" >>"git_log/$git_folder/$OUTPUT_FILE.log"
                echo "-|-|-|-" >>"git_log/$git_folder/$OUTPUT_FILE.log"
                git -C "git_repositories/$git_folder/$OUTPUT_FILE" log --pretty=format:"%h|%an|%ad|%s" "$SHA_Begin...$SHA_End" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            fi
            echo "" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "</details>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "     |-----------------------------------|"
            echo "     $OUTPUT_FILE has update log"
            echo "     |-----------------------------------|"
            sed -i "s/^${OUTPUT_FILE}:.*/${OUTPUT_FILE}:${SHA_End}/" "git_log/$git_folder/log"
            UPDATE_COUNT=$((UPDATE_COUNT + 1))
        else
            # 没有更新的情况，生成默认日志
            echo "<b>No new commits for $OUTPUT_FILE.  :zzz: </b>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
        fi

        # 将生成的 .log 文件追加到 release.txt
        if [ -f "git_log/$git_folder/$OUTPUT_FILE.log" ]; then
            echo "found file $OUTPUT_FILE.log!"
            cat "git_log/$git_folder/$OUTPUT_FILE.log" >>release.txt
        else
            echo "no file $OUTPUT_FILE.log 404"
        fi
        echo "$git_folder-$OUTPUT_FILE complete git log update-----------------------------------------------------------"
        echo "==========================================================================================================="
        echo ""
        echo ""
        echo ""
    done
    if [ "$UPDATE_COUNT" -eq 0 ]; then
        echo "No source code updates...... :zzz:">>release.txt
    fi
done

cd $GITHUB_WORKSPACE
find . -type f -name "*.txt" ! -name "release.txt" -exec rm {} +
rm -rf git_repositories