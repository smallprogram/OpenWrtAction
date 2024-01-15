# git clone https://github.com/coolsnowwolf/lede.git lede_X86.config
cd lede_X86.config
git pull
cp -r ../OpenWrtAction/feeds_config/custom.feeds.conf.default ./feeds.conf.default
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