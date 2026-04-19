#!/bin/bash
source $GITHUB_WORKSPACE/compile_script/main_and_feeds_url.sh
release_tag=$1
git_folders=(openwrt immortalwrt lede feeds custompackages)

cd $GITHUB_WORKSPACE

# 初始化 release.txt
echo "[![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/$release_tag/total?style=flat-square)](https://github.com/smallprogram/MyAction)"> release.txt

echo "">> release.txt
echo "## Source Code Information">> release.txt
echo "[![](https://img.shields.io/badge/source-openwrt_25.12-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/openwrt/openwrt) [![](https://img.shields.io/badge/source-immortalwrt_25.12-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/immortalwrt/immortalwrt) [![](https://img.shields.io/badge/source-lean_SNAPSHOT-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/coolsnowwolf/lede)">> release.txt
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
        if [ -f "release_$git_folder.txt" ]; then
            cat "release_$git_folder.txt" >> "release.txt"
        fi
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
    fi
    if [[ "$git_folder" == "custompackages" ]]; then
        echo "">>release.txt
        echo "### custom packages" >>release.txt
        echo "">>release.txt
    fi
    if [[ "$git_folder" == "openwrt" || "$git_folder" == "immortalwrt" || "$git_folder" == "lede" ]]; then
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
        OUTPUT_FILE="${OUTPUT_FILE%.git}"  # 移除.git后缀
        TITLE_MESSAGE="${OUTPUT_FILE} new commit log"

        # 克隆仓库
        if [ -n "$BRANCH" ]; then
            git clone "$REPO_URL" --filter=blob:none --branch "$BRANCH" "git_repositories/$git_folder/$OUTPUT_FILE"
        else
            git clone "$REPO_URL" --filter=blob:none "git_repositories/$git_folder/$OUTPUT_FILE"
        fi

        # ==========================================
        # 👑 核心一致性改造：获取真理 SHA (SSoT 原则)
        # 不再盲目使用远端 HEAD，强制校验 Artifact 里的历史记录
        # ==========================================
        SHA_End=""
        
        # 1. 优先尝试从对应平台的 artifact 日志中提取 (针对主源码库)
        if [ -f "git_log_${git_folder}.txt" ]; then
            SHA_End=$(grep "^${OUTPUT_FILE}:" "git_log_${git_folder}.txt" 2>/dev/null | cut -d: -f2)
        fi
        
        # 2. 如果没找到，扫描所有下载下来的 artifact 日志匹配 (针对 feeds 和 custompackages)
        if [ -z "$SHA_End" ]; then
            SHA_End=$(grep -h "^${OUTPUT_FILE}:" git_log_*.txt 2>/dev/null | head -n 1 | cut -d: -f2)
        fi

        # 3. 防呆兜底：如果 step03 真的漏了，安全降级使用最新 HEAD 防止脚本崩溃
        if [ -z "$SHA_End" ]; then
            SHA_End=$(git -C "git_repositories/$git_folder/$OUTPUT_FILE" rev-parse HEAD)
            echo "   ⚠️ [Fallback] 未在 Artifact 中找到 $OUTPUT_FILE 记录，使用最新 HEAD: $SHA_End"
        else
            echo "   ✅ [SSoT 匹配成功] 锁定真理 SHA ($OUTPUT_FILE): $SHA_End"
        fi
        # ==========================================

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
                # 去除链接末尾可能包含的 .git 后缀，以保证 GitHub 链接格式正确
                CLEAN_REPO_URL="${REPO_URL%.git}"
                # 拼接 GitHub 的 Compare 链接
                COMPARE_URL="${CLEAN_REPO_URL}/compare/${SHA_Begin}...${SHA_End}"
                echo "#### [:mega: Full Changelog. ](${COMPARE_URL})  " >>"git_log/$git_folder/$OUTPUT_FILE.log";
                echo ":heavy_exclamation_mark: The list displays only the latest 15 commit logs.  " >>"git_log/$git_folder/$OUTPUT_FILE.log"
                echo "" >>"git_log/$git_folder/$OUTPUT_FILE.log"
                echo "SHA|Author|Date|Message" >>"git_log/$git_folder/$OUTPUT_FILE.log"
                echo "-|-|-|-" >>"git_log/$git_folder/$OUTPUT_FILE.log"
                git -C "git_repositories/$git_folder/$OUTPUT_FILE" log --pretty=format:"%h|%an|%ad|%s" "$SHA_Begin...$SHA_End" | head -n 15 >>"git_log/$git_folder/$OUTPUT_FILE.log"
                if [ $(git -C "git_repositories/$git_folder/$OUTPUT_FILE" log --pretty=format:"%h|%an|%ad|%s" "$SHA_Begin...$SHA_End" | wc -l) -gt 15 ]; then 
                    echo "" >>"git_log/$git_folder/$OUTPUT_FILE.log"
                fi
            fi
            echo "" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "</details>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "     |-----------------------------------|"
            echo "     $OUTPUT_FILE has update log"
            echo "     |-----------------------------------|"
            sed -i "s/^${OUTPUT_FILE}:.*/${OUTPUT_FILE}:${SHA_End}/" "git_log/$git_folder/log"
            UPDATE_COUNT=$((UPDATE_COUNT + 1))
        # else
        #     # 没有更新的情况，生成默认日志
        #     echo "<b>No new commits for $OUTPUT_FILE.  :zzz: </b>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
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