#!/bin/bash

source_code_platform=$1

cd $GITHUB_WORKSPACE
echo "${source_code_platform}:$(git -C openwrt log -n 1 --format="%H")" >>git_log_${source_code_platform}.txt
echo "packages:$(git -C openwrt/feeds/packages log -n 1 --format="%H")" >>git_log_${source_code_platform}.txt
echo "luci:$(git -C openwrt/feeds/luci log -n 1 --format="%H")" >>git_log_${source_code_platform}.txt


echo "routing:$(git -C openwrt/feeds/routing log -n 1 --format="%H")" >>git_log_${source_code_platform}.txt
echo "telephony:$(git -C openwrt/feeds/telephony log -n 1 --format="%H")" >>git_log_${source_code_platform}.txt
echo "openwrt-passwall-packages:$(git -C openwrt/feeds/passwall_packages log -n 1 --format="%H")" >>git_log_${source_code_platform}.txt
echo "openwrt-passwall:$(git -C openwrt/feeds/passwall log -n 1 --format="%H")" >>git_log_${source_code_platform}.txt
echo "openwrt-passwall2:$(git -C openwrt/feeds/passwall2 log -n 1 --format="%H")" >>git_log_${source_code_platform}.txt
echo "helloworld:$(git -C openwrt/feeds/helloworld log -n 1 --format="%H")" >>git_log_${source_code_platform}.txt
echo "OpenClash:$(git -C openwrt/feeds/OpenClash log -n 1 --format="%H")" >>git_log_${source_code_platform}.txt

echo "status=success" >>$GITHUB_OUTPUT
