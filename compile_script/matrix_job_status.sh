#!/bin/bash

token=$1
repository=$2
run_id=$3
attempts=$4
jobname=$5

page=1
jobs_data_file=$(mktemp)  # 创建一个临时文件

if [ $attempts -eq 1 ]; then
    echo "status=1" >> $GITHUB_OUTPUT
    exit 0
fi
attempts=$attempts-1

while true; do
    json_data=$(curl -s -H "Authorization: Bearer $token" "https://api.github.com/repos/$repository/actions/runs/$run_id/attempts/$attempts/jobs?page=$page")

    # 检查 API 响应是否有效
    if [ -z "$json_data" ]; then
        echo "Error: No data received from API"
        break
    fi

    # 检查 jobs 数组是否为空
    jobs=$(echo "$json_data" | jq '.jobs')
    job_count=$(echo "$jobs" | jq 'length')

    if [[ "$job_count" -eq 0 ]]; then
        echo "No more jobs found, stopping..."
        echo "page: $page......."
        break
    fi

    # 过滤以 Upload- 开头的 jobs，并将结果添加到 jobs_data_file 中
    # echo "$jobs" | jq -c '.[] | select(.name | startswith("$jobname"))' >> "$jobs_data_file"
    matched_jobs=$(echo "$jobs" | jq -c --arg jobname "$jobname" '.[] | select(.name | startswith($jobname))')
    if [[ -n "$matched_jobs" ]]; then
        echo "$matched_jobs" >> "$jobs_data_file"
        echo "Found matching job(s), exiting loop..."
        break
    fi

    ((page++))  # 递增页码
    echo "Fetching page: $page"

    echo "sleep 1 second"
    sleep 1  # 等待1秒
done

if [[ ! -s "$jobs_data_file" ]]; then
    echo "No jobs starting with '$jobname' found."
    echo "status=404" >> $GITHUB_OUTPUT
else
    found_job=$(jq -s '.' "$jobs_data_file")
    echo "-------------------------------api data----------------------------"
    echo $found_job
    echo "-------------------------------------------------------------------"
    
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
        echo "status=$conclusion" >> $GITHUB_OUTPUT
    done < <(echo "$found_job" | jq -c '.[]')  # 使用jq解析JSON并提取所需信息
fi
# 清理临时文件
rm "$jobs_data_file"
