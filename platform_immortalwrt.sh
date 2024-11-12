# 默认源码文件夹名
openwrt_dir_front=immortalwrt_
openwrt_dir=${openwrt_dir_front}${config_name}
# 默认的config目录
config_dir=config/immortalwrt_config
# config列表
config_list=($(ls /home/$user_name/OpenWrtAction/$config_dir))
# feeds目录
feeds_dir=feeds_config/immortalwrt.feeds.conf.default
# oepnwrt主源码
openwrt_source=https://github.com/immortalwrt/immortalwrt.git
openwrt_branch=master
# 编译openwrt的log日志文件夹名称
log_folder_name=immortalwrt_openwrt_log
# diy script
diy_script_1=diy_script/immortalwrt_diy/diy-part1.sh
diy_script_2=diy_script/immortalwrt_diy/diy-part2.sh
# 依赖列表
my_depends=https://github.com/smallprogram/OpenWrtAction/blob/main/diy_script/immortalwrt_dependence