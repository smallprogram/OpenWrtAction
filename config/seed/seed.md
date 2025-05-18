
make menuconfig
## 修改架构，然后执行命令，注意修改最后config名称
cat ../OpenWrtAction/config/seed/immortalwrt_seed.config >> .config && make defconfig && cp -f .config ../OpenWrtAction/config/immortalwrt_config/AW1000.config
