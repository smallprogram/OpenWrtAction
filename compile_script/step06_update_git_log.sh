#!/bin/bash
release_tag=$1
git_folders=(openwrt immortalwrt lede feeds)

openwrt_REPO_URLS=(
    "https://github.com/openwrt/openwrt"
    "https://github.com/openwrt/packages"
    "https://github.com/openwrt/luci"
)

immortalwrt_REPO_URLS=(
    "https://github.com/immortalwrt/immortalwrt"
    "https://github.com/immortalwrt/packages"
    "https://github.com/immortalwrt/luci"
)

lede_REPO_URLS=(
    "https://github.com/coolsnowwolf/lede"
    "https://github.com/coolsnowwolf/packages"
    "https://github.com/coolsnowwolf/luci"
)

feeds_REPO_URLS=(
    "https://github.com/openwrt/routing"
    "https://github.com/openwrt/telephony"
    "https://github.com/fw876/helloworld"
    "https://github.com/xiaorouji/openwrt-passwall-packages"
    "https://github.com/xiaorouji/openwrt-passwall"
    "https://github.com/xiaorouji/openwrt-passwall2"
    "https://github.com/vernesong/OpenClash"
    "https://github.com/nikkinikki-org/OpenWrt-nikki"
)


cd $GITHUB_WORKSPACE

echo "[![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/$release_tag/total?style=flat-square)](https://github.com/smallprogram/MyAction)"> release.txt
echo "">> release.txt
echo "## Source Code Information">> release.txt
echo "[![](https://img.shields.io/badge/source-immortalwrt-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/immortalwrt/immortalwrt) [![](https://img.shields.io/badge/source-lean-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/coolsnowwolf/lede) [![](https://img.shields.io/badge/source-openwrt-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/openwrt/openwrt)">> release.txt
echo "">>release.txt
echo "## Build Information">>release.txt

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
# 删掉git_log目录和子目录中的除了log文件以外的所有文件
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
        
        OUTPUT_FILE="${url##*/}"
        TITLE_MESSAGE="${url##*/} new commit log"

        SHA_Begin=$(grep "^${OUTPUT_FILE}:" git_log/${git_folder}/log | cut -d: -f2)
        echo ""
        echo "$git_folder-$OUTPUT_FILE Begin git log update-----------------------------------------------------------"
        echo "SHABegin:$SHA_Begin"

        if [[ "$git_folder" == "feeds" ]]; then
            SHA_End=$(grep "^${OUTPUT_FILE}:" git_log_immortalwrt.txt | cut -d: -f2)
        else
            SHA_End=$(grep "^${OUTPUT_FILE}:" git_log_${git_folder}.txt | cut -d: -f2)
        fi
        echo "SHAEnd:$SHA_End"

        git clone $url --filter=blob:none git_repositories/$git_folder/$OUTPUT_FILE

        if ! git -C git_repositories/$git_folder/$OUTPUT_FILE cat-file -t "$SHA_Begin" >/dev/null 2>&1 ||
            ! git -C git_repositories/$git_folder/$OUTPUT_FILE cat-file -t "$SHA_End" >/dev/null 2>&1; then
            sed -i "s/^${OUTPUT_FILE}:.*/${OUTPUT_FILE}:${SHA_End}/" git_log/$git_folder/log

            echo "     :x: Invalid SHA detected (Begin: $SHA_Begin, End: $SHA_End) for $OUTPUT_FILE"
            echo "<details> <summary> <b>$TITLE_MESSAGE :x: </b>  </summary>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "<b> It is detected that $OUTPUT_FILE has an illegal SHA value. It is possible that $OUTPUT_FILE has git rebase behavior. The relevant git update log cannot be counted. Please wait for the next compilation time.</b>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "</details>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            continue
        fi

        if [ -z "$SHA_Begin" ]; then
            sed -i "s/^${OUTPUT_FILE}:.*/${OUTPUT_FILE}:${SHA_End}/" git_log/$git_folder/log
        elif [ "$SHA_Begin" != "$SHA_End" ]; then
            echo "<details> <summary> <b>$TITLE_MESSAGE :rocket: </b>  </summary>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "SHA|Author|Date|Message" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "-|-|-|-" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            git -C git_repositories/$git_folder/$OUTPUT_FILE log --pretty=format:"%h|%an|%ad|%s" "$SHA_Begin...$SHA_End" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "</details>" >>"git_log/$git_folder/$OUTPUT_FILE.log"
            echo "     |-----------------------------------|"
            echo "     $OUTPUT_FILE has update log"
            echo "     |-----------------------------------|"
            sed -i "s/^${OUTPUT_FILE}:.*/${OUTPUT_FILE}:${SHA_End}/" git_log/$git_folder/log
        fi

        if [ -f "git_log/$git_folder/$OUTPUT_FILE.log" ]; then
            echo "found file $OUTPUT_FILE.log!"
            cat "git_log/$git_folder/$OUTPUT_FILE.log" >>release.txt
            UPDATE_COUNT=$((UPDATE_COUNT + 1))
        else
            echo "no file $OUTPUT_FILE.log 404"
        fi  
        echo "$git_folder-$OUTPUT_FILE complate git log update-----------------------------------------------------------"

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
