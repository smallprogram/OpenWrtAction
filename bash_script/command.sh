# git clone https://github.com/coolsnowwolf/lede.git lede_X86.config
cd lede_X86.config
git pull
# cp -r ../OpenWrtAction/feeds_config/custom.feeds.conf.default ./feeds.conf.default

cat << 'EOF' | cat - feeds.conf.default > temp && mv temp feeds.conf.default
src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main
src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main
src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main
src-git helloworld https://github.com/fw876/helloworld;master
src-git OpenClash https://github.com/vernesong/OpenClash;master
EOF

./scripts/feeds clean
./scripts/feeds update -a
./scripts/feeds install -a
cp -r ../OpenWrtAction/config/X86.config .config
bash ../OpenWrtAction/diy_script/diy-part1.sh
bash ../OpenWrtAction/diy_script/diy-part2.sh 1
make defconfig
make download -j8
find dl -size -1024c -exec ls -l {} \;
find dl -size -1024c -exec rm -f {} \;
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make -j$(nproc)
