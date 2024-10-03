#!/bin/bash

token=$1
repository=$2
run_id=$3

page=1
jobs_data_file=$(mktemp)  # 创建一个临时文件
release_temp_file=$(mktemp)  # 创建一个临时文件用于存储release.txt内容



if [ -f "release.txt" ]; then
    while true; do
        json_data=$(curl -s -H "Authorization: Bearer $token" "https://api.github.com/repos/$repository/actions/runs/$run_id/jobs?page=$page")
        # 检查 jobs 数组是否为空
        jobs=$(echo "$json_data" | jq '.jobs')
        job_count=$(echo "$jobs" | jq 'length')
        if [[ "$job_count" -eq 0 ]]; then
            break
        fi

        # 将当前页的 jobs 添加到 jobs_data_file 中，确保格式正确
        echo "$jobs" | jq -c '.[]' >> "$jobs_data_file"
        ((page++))  # 递增页码
    done

    # 从临时文件读取所有 jobs，并确保格式正确
    all_jobs=$(jq -s '.' "$jobs_data_file")

    # 过滤以 Build- 开头的 jobs
    filtered_jobs=$(echo "$all_jobs" | jq -c 'map(select(.name | startswith("Build-")))')

    # 读取release.txt文件内容
    cp release.txt "$release_temp_file"
    conclusion_success_count=0
    
    # 使用进程替换
    while IFS= read -r job; do
        name=$(echo "$job" | jq -r '.name')
        source_platform=$(echo "$name" | cut -d'-' -f2)
        platform=$(echo "$name" | cut -d'-' -f3-)
        conclusion=$(echo "$job" | jq -r '.conclusion')

        echo "source_platform: $source_platform"
        echo "platform: $platform"
        echo "conclusion: $conclusion"
        echo "-----------------------------"

        if [ "$conclusion" == "success" ]; then
            conclusion_success_count=$((conclusion_success_count + 1))
        fi

        echo "Current count: $conclusion_success_count"

        awk -v sp="$source_platform" -v pl="$platform" -v concl="$conclusion" '
        {
            if ($0 ~ "scp=\"" sp "\"" && $0 ~ "plm=\"" pl "\"") {
                gsub(/src="[^"]*"/, "src=\"\"", $0)  # 清除src属性的值
                if (concl == "success") {
                    gsub(/src=""/, "src=\"https://img.shields.io/badge/build-passing-green?logo=githubactions&logoColor=green&style=flat-square\"", $0)
                } else {
                    gsub(/src=""/, "src=\"https://img.shields.io/badge/build-failure-red?logo=githubactions&logoColor=red&style=flat-square\"", $0)
                }
            }
            print
        }' "$release_temp_file" > temp && mv temp "$release_temp_file"
    done < <(echo "$filtered_jobs" | jq -c '.[]') # 使用jq解析JSON并提取所需信息

    echo "Total success count: $conclusion_success_count"
    # 将更新后的内容写回release.txt文件
    cp "$release_temp_file" release.txt
    sed -i 's/src=""/\&/g' release.txt

    # 清理临时文件
    rm "$jobs_data_file"

    if [ "$conclusion_success_count" -eq 0 ]; then
        echo "status=failure" >>$GITHUB_OUTPUT
    else
        echo "status=success" >>$GITHUB_OUTPUT
    fi
else
    echo "status=failure" >>$GITHUB_OUTPUT
fi
