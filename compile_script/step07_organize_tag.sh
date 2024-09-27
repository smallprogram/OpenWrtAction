#!/bin/bash

token=$1
repository=$2
run_id=$3

source $GITHUB_WORKSPACE/compile_script/platforms.sh

if [ -f "release.txt" ]; then

    json_data=$(curl -s -H "Authorization: Bearer $token" "https://api.github.com/repos/$repository/actions/runs/$run_id/jobs")
    name_conclusion_array=($(echo "$json_data" | jq -r '.jobs[] | select(.name | startswith("Build-")) | "\(.name).\(.conclusion)"'))

    # 创建一个数组存储执行状态
    declare -A status_map

    # 填充状态映射
    for item in "${name_conclusion_array[@]}"; do
        IFS='.' read -r name conclusion <<<"$item"

        # 动态提取 platform 和 source platform
        platform=$(echo "$name" | sed -E 's/^Build-//; s/-.*//')  # 提取 Build- 后第一个 - 之前的部分
        source_platform=$(echo "$name" | sed -E 's/^Build-[^-]+-//; s/-.*//')  # 提取第二个 - 后的内容

        # 根据 Conclusion 设置对应的状态
        if [[ "$conclusion" == "success" ]]; then
            status_map["$platform-$source_platform"]="![](https://img.shields.io/badge/build-passing-green?logo=githubactions&logoColor=green&style=flat-square)"
        else
            status_map["$platform-$source_platform"]="![](https://img.shields.io/badge/build-failure-red?logo=githubactions&logoColor=red&style=flat-square)"
        fi
    done

    # 更新 release.txt 文件中的 compile status
    while IFS= read -r line; do
        if [[ "$line" =~ <td><strong>(.*)</strong></td> ]]; then
            platform_name="${BASH_REMATCH[1]}"

            # 提取当前行的 source platform
            source_platform=$(echo "$line" | sed -E 's/.*<td><strong>([^<]*)<\/strong>.*/\1/')  # 提取 source platform

            # 提取平台名并根据映射更新 compile status
            compile_status_key="$platform_name-$source_platform"
            if [[ -n "${status_map[$compile_status_key]}" ]]; then
                new_status="${status_map[$compile_status_key]}"
                line=$(echo "$line" | sed "s|<td>.*</td>|<td>$new_status</td>|")
            fi
        fi
        echo "$line" >> updated_release.txt  # 输出到新的文件中
    done < release.txt

    # 替换原文件
    mv updated_release.txt release.txt

    echo "status=success" >>$GITHUB_OUTPUT
    echo "-----------------------release.txt------------------------"
    cat release.txt

else
    echo "status=failure" >>$GITHUB_OUTPUT
fi
