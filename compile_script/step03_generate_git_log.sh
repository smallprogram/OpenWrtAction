#!/bin/bash

source_code_platform=$1

cd $GITHUB_WORKSPACE
git -C openwrt log -n 1 --format="%H" >>git_log_${source_code_platform}.txt
git -C openwrt/feeds/packages log -n 1 --format="%H" >>git_log_${source_code_platform}.txt
git -C openwrt/feeds/luci log -n 1 --format="%H" >>git_log_${source_code_platform}.txt
git -C openwrt/feeds/routing log -n 1 --format="%H" >>git_log_${source_code_platform}.txt
git -C openwrt/feeds/telephony log -n 1 --format="%H" >>git_log_${source_code_platform}.txt

git -C openwrt/feeds/passwall_packages log -n 1 --format="%H" >>git_log_common_${source_code_platform}.txt
git -C openwrt/feeds/passwall log -n 1 --format="%H" >>git_log_common_${source_code_platform}.txt
git -C openwrt/feeds/passwall2 log -n 1 --format="%H" >>git_log_common_${source_code_platform}.txt
git -C openwrt/feeds/helloworld log -n 1 --format="%H" >>git_log_common_${source_code_platform}.txt
git -C openwrt/feeds/OpenClash log -n 1 --format="%H" >>git_log_common_${source_code_platform}.txt

echo "status=success" >>$GITHUB_OUTPUT
