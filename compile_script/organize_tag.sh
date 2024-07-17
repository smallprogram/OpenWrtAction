#!/bin/bash

token=$1
repository=$2
run_id=$3

source $GITHUB_WORKSPACE/compile_script/platforms.sh

if [ -f "release.txt" ]; then

    json_data=$(curl -s -H "Authorization: Bearer $token" "https://api.github.com/repos/$repository/actions/runs/$run_id/jobs")
    name_conclusion_array=($(echo "$json_data" | jq -r '.jobs[] | select(.name | startswith("Build-OpenWrt-")) | "\(.name).\(.conclusion)"'))


    echo "-------------------build status--------------------------"
    for item in "${name_conclusion_array[@]}"; do
        IFS='.' read -r name conclusion <<< "$item"
        echo "Name: $name"
        echo "Conclusion: $conclusion"
    done
    echo "-----------------------------------------------------------"

    # Create a temporary file to store the updated content
    tmp_file=$(mktemp)

    # Iterate through the lines of release.txt
    while IFS= read -r line; do
        updated_line="$line"
        for platform in "${platforms[@]}"; do
            if [[ "$line" == *"$platform"* ]]; then
                for item in "${name_conclusion_array[@]}"; do
                    IFS='.' read -r name conclusion <<< "$item"
                    if [[ "$name" == "Build-OpenWrt-$platform" ]]; then
                        if [[ "$conclusion" == "success" ]]; then
                            updated_line=$(echo "$line" | sed 's/build-in_progress_or_waiting.....-yellow?logo=githubactions\&logoColor=yellow/build-passing-green?logo=githubactions\&logoColor=green/')
                        else
                            updated_line=$(echo "$line" | sed 's/build-in_progress_or_waiting.....-yellow?logo=githubactions\&logoColor=yellow/build-failure-red?logo=githubactions\&logoColor=red/')
                        fi
                        break
                    fi
                done
                break
            fi
        done
        echo "$updated_line" >> "$tmp_file"
    done < "release.txt"

    # Replace the original file with the updated content
    mv "$tmp_file" "release.txt"

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