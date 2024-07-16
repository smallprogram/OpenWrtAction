#!/bin/bash

source $GITHUB_WORKSPACE/compile_script/platforms.sh

if [ -f "release.txt" ]; then

json_data=$(curl -s -H "Authorization: Bearer ${{ github.token }}" "https://api.github.com/repos/${{ github.repository }}/actions/runs/${{ github.run_id }}/jobs")
name_conclusion_array=($(echo "$json_data" | jq -r '.jobs[] | select(.name | startswith("Build-OpenWrt-")) | "\(.name).\(.conclusion)"'))


echo "-------------------build status--------------------------"
for item in "${name_conclusion_array[@]}"; do
    IFS='.' read -r name conclusion <<< "$item"
    echo "Name: $name"
    echo "Conclusion: $conclusion"
done
echo "-----------------------------------------------------------"

for ((i = 0; i < ${#platforms[@]}; i++)); do
    platform="${platforms[i]}"
    is_error=false
    row=$((i+14))s
    for item in "${name_conclusion_array[@]}"; do
    IFS='.' read -r name conclusion <<< "$item"          
    if [[ "$name" == "Build-OpenWrt-$platform" ]]; then
        if [[ "$conclusion" == "success" ]]; then
        break
        else
        is_error=true
        break
        fi
    fi
    done
    
    if $is_error; then
    echo "is_error be true: $is_error"
    sed -i "$row/build-in_progress_or_waiting.....-yellow?logo=githubactions\&logoColor=yellow/build-failure-red?logo=githubactions\&logoColor=red/" release.txt;
    else
    echo "is_error be false: $is_error"
    sed -i "$row/build-in_progress_or_waiting.....-yellow?logo=githubactions\&logoColor=yellow/build-passing-green?logo=githubactions\&logoColor=green/" release.txt;
    fi
done

echo "|=========================================|"
ls git_log
echo "|=========================================|"

echo "## What's Changed" >> release.txt

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

for file in "${OUTPUT_FILES[@]}"; do
    if [ -f "git_log/$file.log" ]; then
    echo "found file $file.log!"
    cat "git_log/$file.log" >> release.txt
    else
    echo "no file $file.log 404"
    fi
done


echo "status=success" >> $GITHUB_OUTPUT
echo "-----------------------release.txt------------------------"
cat release.txt

else
    echo "status=failure" >> $GITHUB_OUTPUT
fi