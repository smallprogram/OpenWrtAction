# 默认源码文件夹名
openwrt_dir_front=leanlede
openwrt_dir=${openwrt_dir_front}_${openwrt_branch}_${config_name}
# 默认的config目录
config_dir=config/leanlede_config
# config列表
config_list=($(ls /home/$user_name/OpenWrtAction/$config_dir))
# feeds目录
# feeds_dir=feeds_config/lean.feeds.conf.default
# oepnwrt主源码
openwrt_source=https://github.com/coolsnowwolf/lede
openwrt_branch=master
# 编译openwrt的log日志文件夹名称
log_folder_name=lean_openwrt_log
# diy script
diy_script_1=diy_script/lean_diy/diy-part1.sh
diy_script_2=diy_script/lean_diy/diy-part2.sh
# 依赖列表
my_depends=https://raw.githubusercontent.com/smallprogram/OpenWrtAction/refs/heads/main/diy_script/lede_dependence
