#!/bin/bash

token=$1
repository=$2
run_id=$3

source $GITHUB_WORKSPACE/compile_script/platforms.sh

json_data=$(curl -s -H "Authorization: Bearer $token" "https://api.github.com/repos/$repository/actions/runs/$run_id/jobs")
name_conclusion_array=($(echo "$json_data" | jq -r '.jobs[] | select(.name | startswith("Build-OpenWrt-")) | "\(.name).\(.conclusion)"'))

is_success_compiled=false
for ((i = 0; i < ${#platforms[@]}; i++)); do
    if $is_success_compiled; then break; fi
    platform="${platforms[i]}"
    for item in "${name_conclusion_array[@]}"; do
        IFS='.' read -r name conclusion <<<"$item"
        if [[ "$name" == "Build-OpenWrt-$platform" ]]; then
            if [[ "$conclusion" == "success" ]]; then
                is_success_compiled=true
                break
            fi
        fi
    done
done

echo "-------------------build status--------------------------"
for item in "${name_conclusion_array[@]}"; do
    IFS='.' read -r name conclusion <<<"$item"
    echo "Name: $name"
    echo "Conclusion: $conclusion"
done
echo "-----------------------------------------------------------"

if $is_success_compiled; then
    echo "status=success" >>$GITHUB_OUTPUT
    echo "Compilation succeeded for at least one platform."
else
    echo "status=failed" >>$GITHUB_OUTPUT
    echo "Compilation failed for all platforms."
fi
