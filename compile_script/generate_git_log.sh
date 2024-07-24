#!/bin/bash

cd $GITHUB_WORKSPACE
git -C openwrt log -n 1 --format="%H" >>git_log.txt
git -C openwrt/feeds/packages log -n 1 --format="%H" >>git_log.txt
git -C openwrt/feeds/luci log -n 1 --format="%H" >>git_log.txt
git -C openwrt/feeds/routing log -n 1 --format="%H" >>git_log.txt
git -C openwrt/feeds/telephony log -n 1 --format="%H" >>git_log.txt
git -C openwrt/feeds/helloworld log -n 1 --format="%H" >>git_log.txt
git -C openwrt/feeds/passwall_packages log -n 1 --format="%H" >>git_log.txt
git -C openwrt/feeds/passwall log -n 1 --format="%H" >>git_log.txt
git -C openwrt/feeds/passwall2 log -n 1 --format="%H" >>git_log.txt
git -C openwrt/feeds/OpenClash log -n 1 --format="%H" >>git_log.txt
git -C openwrt/package/custom_packages/luci-theme-argon log -n 1 --format="%H" >>git_log.txt
git -C openwrt/package/custom_packages/luci-app-argon-config log -n 1 --format="%H" >>git_log.txt
git -C openwrt/package/custom_packages/luci-app-adguardhome log -n 1 --format="%H" >>git_log.txt
git -C openwrt/package/custom_packages/mosdns log -n 1 --format="%H" >>git_log.txt
echo "status=success" >>$GITHUB_OUTPUT
