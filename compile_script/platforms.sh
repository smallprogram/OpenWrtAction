#!/bin/bash

source_code_platforms=(immortalwrt openwrt lede)

immortalwrt_value='{"REPO_URL": "https://github.com/immortalwrt/immortalwrt.git","REPO_BRANCH": "master","FEEDS_CONF": "feeds_config/immortalwrt.feeds.conf.default","CONFIGS": "config/immortalwrt_config","DIY_P1_SH": "diy_script/immortalwrt_diy/diy-part1.sh","DIY_P2_SH": "diy_script/immortalwrt_diy/diy-part2.sh","OS": "ubuntu-22.04"}'

openwrt_value='{"REPO_URL": "https://github.com/openwrt/openwrt.git","REPO_BRANCH": "master","FEEDS_CONF": "feeds_config/openwrt.feeds.conf.default","CONFIGS": "config/openwrt_config","DIY_P1_SH": "diy_script/openwrt_diy/diy-part1.sh","DIY_P2_SH": "diy_script/openwrt_diy/diy-part2.sh","OS": "ubuntu-24.04"}'

lede_value='{"REPO_URL": "https://github.com/coolsnowwolf/lede","REPO_BRANCH": "master","FEEDS_CONF": "feeds_config/lean.feeds.conf.default","CONFIGS": "config/leanlede_config","DIY_P1_SH": "diy_script/lean_diy/diy-part1.sh","DIY_P2_SH": "diy_script/lean_diy/diy-part2.sh","OS": "ubuntu-22.04"}'


immortalwrt_platforms=(X86 R2C R2CPLUS R2S R4S R4SE R4SENT R5C R5S R6C R6S R66S R68S)


openwrt_platforms=(X86 R2C R2CPLUS R2S R4S R4SE R5C R5S R6S)


lede_platforms=(X86 R2C R2S R4S R4SE R5C R5S H66K H68K H69K R66S R68S R_PI_3b R_PI_4b)
# R_PI_3b R_PI_4b Asus_TUF_AX4200 JDCloud_AX6000 Phicomm_N1 Thunder_OneCloud RedMi_AX5 XiaoMi_AX6S XiaoMi_AX3000T XiaoMi_AX3600 XiaoMi_AX6000 XiaoMi_AX9000

copy_backgroundfiles_platforms=(X86 R5S R5C R4S R4SE R2S R2C H66K H68K H69K R66S R68S R_PI_3b R_PI_4b)

matrix_json="["
source_matrix_json="["

for source_platform in "${source_code_platforms[@]}"; do
    

    platforms_var="${source_platform}_platforms[@]"
    platforms=("${!platforms_var}")
    value_var="${source_platform}_value"
    value="${!value_var}"

    source_matrix_json+="{\"source_code_platform\":\"${source_platform}\",\"value\":${value}},"
    
    for platform in "${platforms[@]}"; do
        matrix_json+="{\"source_code_platform\":\"${source_platform}\",\"platform\":\"${platform}\",\"value\":${value}},"
    done
done

matrix_json="${matrix_json%,}]"
source_matrix_json="${source_matrix_json%,}]"


echo $matrix_json
echo $source_matrix_json
echo "matrix=$matrix_json" >> $GITHUB_OUTPUT
echo "source_matrix_json=$source_matrix_json" >> $GITHUB_OUTPUT