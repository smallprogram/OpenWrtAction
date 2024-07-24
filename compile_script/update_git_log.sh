#!/bin/bash

REPO_URLS=(
    "https://github.com/coolsnowwolf/lede --filter=blob:none"
    "https://github.com/coolsnowwolf/packages --filter=blob:none"
    "https://github.com/coolsnowwolf/luci --filter=blob:none"
    "https://github.com/openwrt/routing.git --filter=blob:none -b openwrt-23.05"
    "https://github.com/openwrt/telephony.git --filter=blob:none -b openwrt-23.05"
    "https://github.com/fw876/helloworld --filter=blob:none"
    "https://github.com/xiaorouji/openwrt-passwall-packages --filter=blob:none"
    "https://github.com/xiaorouji/openwrt-passwall --filter=blob:none"
    "https://github.com/xiaorouji/openwrt-passwall2 --filter=blob:none"
    "https://github.com/vernesong/OpenClash.git --filter=blob:none"
    "https://github.com/jerrykuku/luci-theme-argon.git --filter=blob:none -b 18.06"
    "https://github.com/jerrykuku/luci-app-argon-config.git --filter=blob:none -b 18.06"
    "https://github.com/rufengsuixing/luci-app-adguardhome.git --filter=blob:none"
    "https://github.com/sbwml/luci-app-mosdns --filter=blob:none -b v5"
)
LINE_NUMBERS=(1 2 3 4 5 6 7 8 9 10 11 12 13 14)
OUTPUT_FILES=(
    "lede"
    "packages"
    "luci"
    "routing"
    "telephony"
    "helloworld"
    "openwrt-passwall-packages"
    "openwrt-passwall"
    "openwrt-passwall2"
    "OpenClash"
    "luci-theme-argon"
    "luci-app-argon-config"
    "luci-app-adguardhome"
    "luci-app-mosdns"
)
TITLE_MESSAGES=(
    "openwrt new commit log"
    "package new commit log"
    "luci new commit log"
    "routing new commit log"
    "telephony new commit log"
    "helloworld new commit log"
    "passwall packages new commit log"
    "passwall new commit log"
    "passwall2 new commit log"
    "openclash new commit log"
    "luci-theme-argon new commit log"
    "luci-app-argon-config new commit log"
    "luci-app-adguardhome new commit log"
    "luci-app-mosdns new commit log"
)
cd $GITHUB_WORKSPACE
find git_log -type f ! -name 'log' -exec rm {} +
mkdir -p git_repositories

for i in "${!REPO_URLS[@]}"; do
    REPO_URL=${REPO_URLS[$i]}
    LINE_NUMBER=${LINE_NUMBERS[$i]}
    OUTPUT_FILE=${OUTPUT_FILES[$i]}
    TITLE_MESSAGE=${TITLE_MESSAGES[$i]}

    line=$(sed -n "${LINE_NUMBER}p" git_log/log)
    SHA_Begin=$(echo "$line" | sed -n 's/^[^:]*://p')
    SHA_End=$(sed -n "${LINE_NUMBER}p" git_log.txt)

    git clone $REPO_URL git_repositories/$OUTPUT_FILE

    if ! git -C git_repositories/$OUTPUT_FILE cat-file -t "$SHA_Begin" >/dev/null 2>&1 ||
        ! git -C git_repositories/$OUTPUT_FILE cat-file -t "$SHA_End" >/dev/null 2>&1; then
        sed -i "${LINE_NUMBER}s/:.*/:$SHA_End/" git_log/log

        echo " :x: Invalid SHA detected (Begin: $SHA_Begin, End: $SHA_End) for $OUTPUT_FILE"
        echo "<details> <summary> <b>$TITLE_MESSAGE :x: </b>  </summary>" >>"git_log/$OUTPUT_FILE.log"
        echo "" >>"git_log/$OUTPUT_FILE.log"
        echo "<b> It is detected that $OUTPUT_FILE has an illegal SHA value. It is possible that $OUTPUT_FILE has git rebase behavior. The relevant git update log cannot be counted. Please wait for the next compilation time.</b>" >>"git_log/$OUTPUT_FILE.log"
        echo "" >>"git_log/$OUTPUT_FILE.log"
        echo "</details>" >>"git_log/$OUTPUT_FILE.log"
        continue
    fi

    if [ -z "$SHA_Begin" ]; then
        sed -i "${LINE_NUMBER}s/:.*/:$SHA_End/" git_log/log
    elif [ "$SHA_Begin" != "$SHA_End" ]; then
        echo "<details> <summary> <b>$TITLE_MESSAGE :new: </b>  </summary>" >>"git_log/$OUTPUT_FILE.log"
        echo "" >>"git_log/$OUTPUT_FILE.log"
        echo "SHA|Author|Date|Message" >>"git_log/$OUTPUT_FILE.log"
        echo "-|-|-|-" >>"git_log/$OUTPUT_FILE.log"
        git -C git_repositories/$OUTPUT_FILE log --pretty=format:"%h|%an|%ad|%s" "$SHA_Begin...$SHA_End" >>"git_log/$OUTPUT_FILE.log"
        echo "" >>"git_log/$OUTPUT_FILE.log"
        echo "</details>" >>"git_log/$OUTPUT_FILE.log"
        echo "|-----------------------------------|"
        echo "$OUTPUT_FILE has update log"
        echo "|-----------------------------------|"
        sed -i "${LINE_NUMBER}s/:.*/:$SHA_End/" git_log/log
    fi
done

echo "|=========================================|"
ls git_log
echo "|=========================================|"
cd $GITHUB_WORKSPACE
rm -rf git_log.txt git_repositories
