#!/bin/bash
# OP编译



echo -e  "\033[34m 注意，请确保当前linux账户为非root账户，并且已经安装相关编译依赖 \033[0m"
echo -e  "\033[34m 如果不符合上述条件，请ctrl+C退出 \033[0m"



# 编译环境中当前账户名字
userName=$USER
# 默认OpenWrtAction的Config文件夹中的config文件名
configName=x64.config

# 默认lean源码文件夹名
ledeDir=lede_$configName

config_list=($(ls /home/$userName/OpenWrtAction/config))
# 默认输入超时时间，单位为秒
timer=15
# 编译环境默认值，1为WSL2，2为非WSL2的Linux环境。不要修改这里
sysenv=1
# OpenWrtAction Git URL
owaUrl=https://github.com/smallprogram/OpenWrtAction.git
# 是否首次编译 0否，1是
isFirstCompile=0
# 编译openwrt的log日志文件夹名称
log_folder_name=openwrt_log
# 编译子文件夹名称
folder_name=log_Compile_${configName}_$(date "+%Y-%m-%d-%H-%M-%S")
# logfile名称
log_feeds_update_filename=Main1_feeds_update-git_log.log
log_feeds_install_filename=Main2_feeds_install-git_log.log
log_make_defconfig_filename=Main3_make_defconfig-git_log.log
log_make_down_filename=Main4_make_download-git_log.log
log_Compile_filename=Main5_Compile-git_log.log
log_Compile_time_filename=Main6_Compile_Time-git_log.log

# defconfig操作之前的config文件名
log_before_defconfig_config=.config_old
# defconfig操作之后的config文件名
log_after_defconfig_config=.config_new
# 两个config的差异文件名
log_diff_config=.config_diff

#清理超过多少天的日志文件
clean_day=3

# 扩展luci插件地址
luci_apps=(
    https://github.com/jerrykuku/luci-theme-argon.git
    https://github.com/jerrykuku/luci-app-argon-config.git
    # https://github.com/jerrykuku/lua-maxminddb.git
    # https://github.com/jerrykuku/luci-app-vssr.git
    https://github.com/lisaac/luci-app-dockerman.git
)

# 将编译的固件提交到GitHubRelease
# function UpdateFileToGithubRelease(){
#     # 没思路
# }

# 检测代码更新函数
# function CheckUpdate(){
#     # todo 感觉没啥必要先不写了
# }

# 获取自定插件函数
function Get_luci_apps(){
    for luci_app in "${luci_apps[@]}"; do

        temp=${luci_app##*/} # xxx.git
        dir=${temp%%.*}  # xxx

        echo
        echo -e "\033[31m 开始同步$dir.... \033[0m"
        sleep 2s

        if [[ $isFirstCompile == 1 && $dir == luci-theme-argon ]]; then
            cd /home/${userName}/${ledeDir}/package/lean/
            rm -rf $dir
            git clone -b 18.06 $luci_app
            continue
        fi

        if [ ! -d "/home/${userName}/${ledeDir}/package/lean/$dir" ];
        then
            cd /home/${userName}/${ledeDir}/package/lean/
            git clone $luci_app
            cd /home/${userName}
        else
            cd /home/${userName}/${ledeDir}/package/lean/$dir
            git pull
            cd /home/${userName}
        fi
    done
}

# 编译函数
function Compile_Firmware() {

    # CheckUpdate

    begin_date=开始时间$(date "+%Y-%m-%d-%H-%M-%S")

    echo -e "\033[31m 是否启用Clean编译，如果不输入任何值默认否，输入任意值启用Clean编译，Clean操作适用于大版本更新 \033[0m"
    echo -e  "\033[31m 将会在$timer秒后自动选择默认值 \033[0m"
    read -t $timer isCleanCompile
    if [ ! -n "$isCleanCompile" ]; then
        echo -e  "\033[34m OK，不执行make clean && make dirclean  \033[0m"
    else
        echo -e  "\033[34m OK，配置为Clean编译。 \033[0m"
        echo -e  "\033[34m 准备开始编译 \033[0m"
        sleep 1s
    fi
    
    echo -e  "\033[34m 创建编译日志文件夹/home/${userName}/${log_folder_name}/${folder_name} \033[0m"
    sleep 1s

    if [ ! -d "/home/${userName}/${log_folder_name}" ];
    then
        mkdir /home/${userName}/${log_folder_name}
    fi
    if [ ! -d "/home/${userName}/${log_folder_name}/${folder_name}" ];
    then
        mkdir /home/${userName}/${log_folder_name}/${folder_name}
    fi
    touch /home/${userName}/${log_folder_name}/${folder_name}/${log_feeds_update_filename}
    touch /home/${userName}/${log_folder_name}/${folder_name}/${log_feeds_install_filename}
    touch /home/${userName}/${log_folder_name}/${folder_name}/${log_make_defconfig_filename}
    touch /home/${userName}/${log_folder_name}/${folder_name}/${log_make_down_filename}
    touch /home/${userName}/${log_folder_name}/${folder_name}/${log_Compile_filename}
    echo -e $begin_date > /home/${userName}/${log_folder_name}/${folder_name}/${log_Compile_time_filename}

    echo -e  "\033[34m 编译日志文件夹创建成功 \033[0m"
    sleep 1s
    echo -e  "\033[34m 开始编译！！ \033[0m"
    sleep 1s


    cd /home/${userName}/${ledeDir}
    if [ -n "$isCleanCompile" ]; then
        make clean
        make dirclean
    fi
    echo
    echo -e "\033[31m 开始将OpenwrtAction中的自定义feeds注入lean源码中.... \033[0m"
    sleep 2s
    echo
    cat /home/${userName}/OpenWrtAction/feeds_config/custom.feeds.conf.default > /home/${userName}/${ledeDir}/feeds.conf.default


    echo -e "\033[31m 开始update feeds.... \033[0m"
    sleep 1s
    ./scripts/feeds update -a | tee -a /home/${userName}/${log_folder_name}/${folder_name}/${log_feeds_update_filename}
    echo -e "\033[31m 开始install feeds.... \033[0m"
    sleep 1s
    ./scripts/feeds install -a | tee -a /home/${userName}/${log_folder_name}/${folder_name}/${log_feeds_install_filename}

    echo
    echo -e "\033[31m 开始将OpenwrtAction中的自定义config文件注入lean源码中.... \033[0m"
    sleep 2s
    echo
    cat /home/${userName}/OpenWrtAction/config/${configName} > /home/${userName}/${ledeDir}/.config
    cat /home/${userName}/${ledeDir}/.config > /home/${userName}/${log_folder_name}/${folder_name}/${log_before_defconfig_config}
    # if [[ $isFirstCompile == 1 ]]; then
    #     echo -e  "\033[34m 由于你是首次编译，需要make menuconfig配置，如果保持原有config不做更改，请在进入菜单后直接exit即可 \033[0m"
    #     sleep 6s
    #     make menuconfig
    # fi
    # if [[ $isFirstCompile == 0 ]]; then
    #     echo -e  "\033[34m 开始执行make defconfig! \033[0m"
    #     make defconfig | tee -a /home/${userName}/${log_folder_name}/${folder_name}/Main1_make_defconfig-git_log.log

    # fi

    echo -e  "\033[34m 开始执行make defconfig! \033[0m"
    sleep 1s
    make defconfig | tee -a /home/${userName}/${log_folder_name}/${folder_name}/${log_make_defconfig_filename}
    cat /home/${userName}/${ledeDir}/.config > /home/${userName}/${log_folder_name}/${folder_name}/${log_after_defconfig_config}

    diff  /home/${userName}/${log_folder_name}/${folder_name}/${log_before_defconfig_config} /home/${userName}/${log_folder_name}/${folder_name}/${log_after_defconfig_config} -y -W 200 > /home/${userName}/${log_folder_name}/${folder_name}/${log_diff_config}

    echo -e  "\033[34m 开始执行make download! \033[0m"
    sleep 1s
    make -j8 download V=s | tee -a /home/${userName}/${log_folder_name}/${folder_name}/${log_make_down_filename}

    echo -e  "\033[34m 开始执行make编译! \033[0m"
    sleep 1s
    if [[ $sysenv == 1 ]]
    then
        # echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make -j$(($(nproc) + 1)) V=s | tee -a /home/${userName}/${log_folder_name}/${folder_name}/${log_Compile_filename}
    else
        # $PATH
        make -j$(($(nproc) + 1)) V=s | tee -a /home/${userName}/${log_folder_name}/${folder_name}/${log_Compile_filename}
    fi

    echo -e  "\033[34m make编译结束! \033[0m"
    sleep 1s

    end_date=结束时间$(date "+%Y-%m-%d-%H-%M-%S")
    echo -e $end_date >> /home/${userName}/${log_folder_name}/${folder_name}/${log_Compile_time_filename}

    ######是否提交编译结果到github Release
    # UpdateFileToGithubRelease

    echo -e "\033[31m 是否拷贝编译固件到${log_folder_name}/${folder_name}下？不输入默认不拷贝，输入任意值拷贝 \033[0m"
    echo -e  "\033[31m 将会在$timer秒后自动选择默认值 \033[0m"
    read -t $timer iscopy
    if [ ! -n "$iscopy" ]; then
        echo -e  "\033[34m OK，不拷贝 \033[0m"
    else
        echo -e  "\033[34m 开始拷贝 \033[0m"
        cp -r /home/${userName}/${ledeDir}/bin/targets /home/${userName}/${log_folder_name}/${folder_name}
        echo -e  "\033[34m 拷贝完成 \033[0m"
    fi
    exit
}

# function timer(){
#     seconds_left=5
#     echo "等待${seconds_left}秒后，使用默认值继续……"
#     while [ $seconds_left -gt 0 ];do
#       if 
#       echo -n $seconds_left
#       sleep 1
#       seconds_left=$(($seconds_left - 1))
#       echo -ne "\r     \r" #清除本行文字
#     done
# }

# config文件夹的config文件列表函数
function configList(){
    key=0
    for conf in ${config_list[*]}; 
    do 
        key=$((${key} + 1))
        echo "$key: $conf"; 
        # echo "129 key的值："$key
    done
    read -t $timer configNameInp
    if [ ! -n "$configNameInp" ]; then
        i=1
        configName=x64.config
        ledeDir=lede_$configName
        # echo "135 configName的值："$configName
        for context in ${config_list[*]}; 
        do 
            if [[ $context == $configName ]]; then
                break
            fi
            i=$((${i} + 1))
            # echo "142 i的值："$i
        done
        configNameInp=$i
        # echo "145 configNameInp的值："$configNameInp
        echo -e "\033[34m 输入超时使用默认值$configName \033[0m"
    else 
        if [[ $configNameInp -ge 1 && $configNameInp -le $key ]]; then
            configName=${config_list[$(($configNameInp-1))]}
            ledeDir=lede_$configName
            # echo $configNameInp
            # echo $configName
        fi
    fi
}

#清理日志文件夹函数
function CleanLogFolder(){
    if [ -d "/home/${userName}/${log_folder_name}" ];
    then
        echo -e "\033[31m 是否清理存储超过$clean_day天的日志文件，默认删除，如果录入任意值不删除 \033[0m"
        echo -e  "\033[31m 将会在$timer秒后自动选择默认值 \033[0m"
        read -t $timer isclean
        if [ ! -n "$isclean" ]; then
            cd /home/${userName}/${log_folder_name}
            find -mtime +$clean_day | xargs rm -rf
            echo -e  "\033[31m 清理成功 \033[0m"
        else
            echo -e  "\033[34m OK，不清理超过$clean_day天的日志文件 \033[0m"
        fi
    fi
}


CleanLogFolder
sleep 2s

echo
echo -e "\033[31m 请输入默认OpenwrtAction中的config文件名，默认为$configName \033[0m"
echo -e  "\033[31m 将会在$timer秒后自动选择默认值 \033[0m"

configList
until [[ $configNameInp -ge 1 && $configNameInp -le $key ]]
do
    echo -e "\033[34m 你输入的 ${configNameInp} 是啥玩应啊，看好了序号，输入数值就行了。 \033[0m"
    echo -e "\033[31m 请输入默认OpenwrtAction中的config文件名，默认为$configName \033[0m"
    configList
done


echo -e "\033[31m 请输入默认lean源码文件夹名称,如果不输入默认$ledeDir,将在($timer秒后使用默认值) \033[0m"
echo -e  "\033[31m 将会在$timer秒后自动选择默认值 \033[0m"
read -t $timer ledeDirInp
if [ ! -n "$ledeDirInp" ]; then
    echo -e  "\033[34m OK，使用默认值$ledeDir \033[0m"
else
    echo -e  "\033[34m 使用 ${ledeDirInp} 作为lean源码文件夹名。 \033[0m"
    ledeDir=$ledeDirInp
fi


echo
echo -e "\033[31m 开始同步lean源码.... \033[0m"
sleep 2s

cd /home/${userName}
if [ ! -d "/home/${userName}/${ledeDir}" ];
then
    git clone https://github.com/coolsnowwolf/lede ${ledeDir}
    cd ${ledeDir}/package/lean
    cd /home/${userName}
    isFirstCompile=1
else 
    cd ${ledeDir}
    git pull
    cd /home/${userName}
    isFirstCompile=0
fi

# if [ ! -f "/home/${userName}/${ledeDir}/.config" ]; then
#     isFirstCompile=1
# else
#     isFirstCompile=0
# fi

# echo $isFirstCompile "dfffffffffffffffffffffffffffff"


Get_luci_apps


echo 
echo -e "\033[31m 准备就绪，请按照导航选择操作.... \033[0m"
sleep 2s


echo -e "\033[31m 你的编译环境是WSL2吗？ \033[0m"
echo -e  "\033[31m 将会在$timer秒后自动选择默认值 \033[0m"
echo -e "\033[34m 1. 是(默认) \033[0m"
echo -e "\033[34m 2. 不是 \033[0m"
read -t $timer sysenv
if [ ! -n "$sysenv" ]; then
        sysenv=1
        echo -e "\033[34m 输入超时使用默认值 \033[0m"
fi
until [[ $sysenv -ge 1 && $sysenv -le 2 ]]
do
    echo -e  "\033[34m 你输入的 ${sysenv} 是啥玩应啊，看好了序号，输入数值就行了。 \033[0m"
    echo -e "\033[31m 你的编译环境是WSL2吗？ \033[0m"
    echo -e "\033[34m 1. 是(默认) \033[0m"
    echo -e "\033[34m 2. 不是 \033[0m"
    read -t $timer sysenv
    if [ ! -n "$sysenv" ]; then
        sysenv=1
        echo -e "\033[34m 使用默认值 \033[0m"
    fi
done
echo 


echo -e "\033[31m 你接下来要干啥？？？ \033[0m"
echo -e  "\033[31m 将会在$timer秒后自动选择默认值 \033[0m"
echo -e "\033[34m 1. 根据config自动编译固件。(默认) \033[0m"
echo -e "\033[34m 2. 我要配置config，配置完毕后自动同步回OpenwrtAction。 \033[0m"
read -t $timer num
if [ ! -n "$num" ]; then
        num=1
        echo -e "\033[34m 使用默认值 \033[0m"
fi
# echo $num
until [[ $num -ge 1 && $num -le 2 ]]
do
    echo -e "\033[34m 你输入的 ${num} 是啥玩应啊，看好了序号，输入数值就行了。 \033[0m"
    echo -e "\033[31m 你接下来要干啥？？？ \033[0m"
    echo -e  "\033[31m 将会在$timer秒后自动选择默认值 \033[0m"
    echo -e "\033[34m 1. 根据config自动编译固件。(默认) \033[0m"
    echo -e "\033[34m 2. 我要配置config，配置完毕后自动同步回OpenwrtAction。 \033[0m"
    read -t $timer num
    if [ ! -n "$num" ]; then
        num=1
        echo -e "\033[34m 使用默认值 \033[0m"
    fi
done

if [[ $num == 1 ]]
then
    Compile_Firmware
fi



if [[ $num == 2 ]]
then
    echo
    echo -e "\033[31m 开始将OpenwrtAction中的自定义feeds注入lean源码中.... \033[0m"
    sleep 2s
    echo
    cat /home/${userName}/OpenWrtAction/feeds_config/custom.feeds.conf.default > /home/${userName}/${ledeDir}/feeds.conf.default

    cd /home/${userName}/${ledeDir}
    echo -e "\033[31m 开始update feeds.... \033[0m"
    sleep 1s
    ./scripts/feeds update -a 
    echo -e "\033[31m 开始install feeds.... \033[0m"
    sleep 1s
    ./scripts/feeds install -a 

    echo
    echo -e "\033[31m 开始将OpenwrtAction中的自定义config文件注入lean源码中.... \033[0m"
    sleep 2s
    echo
    cat /home/${userName}/OpenWrtAction/config/${configName} > /home/${userName}/${ledeDir}/.config

    cd /home/${userName}/${ledeDir}
    make menuconfig
    cat /home/${userName}/${ledeDir}/.config > /home/${userName}/OpenWrtAction/config/${configName}
    cd /home/${userName}/OpenWrtAction
    
    if [ ! -n "$(git config --global user.email)" ]; then
        echo "请输入git Global user.email:"
        read  gitUserEmail
        until [[ -n "$gitUserEmail" ]]
        do
            echo -e "\033[34m 不能输入空值 \033[0m"
            read  gitUserEmail
        done
        git config --global user.email "$gitUserEmail"
    fi

    if [ ! -n "$(git config --global user.name)" ]; then
        echo "请输入git Global user.name:"
        read  gitUserName
        until [[ -n "$gitUserName" ]]
        do
            echo -e "\033[34m 不能输入空值 \033[0m"
            read  gitUserName
        done
        git config --global user.email "$gitUserName"
    fi


    if [ -n "$(git status -s)" ]; then 
        git add .
        git commit -m "update from local"
        git push origin
        echo -e "\033[31m 已将新配置的config同步回OpenwrtAction \033[0m"
        sleep 2s
    fi

    echo -e "\033[31m 是否根据新的config编译？ \033[0m"
    echo -e  "\033[31m 将会在$timer秒后自动选择默认值 \033[0m"
    echo -e "\033[34m 1. 是(默认值) \033[0m"
    echo -e "\033[34m 2. 不编译了。退出 \033[0m"
    read -t $timer num_continue
    if [ ! -n "$num_continue" ]; then
        num_continue=1
    fi
    until [[ $num_continue -ge 1 && $num_continue -le 2 ]]
    do
        echo -e "\033[34m 你输入的 ${num_continue} 是啥玩应啊，看好了序号，输入数值就行了。 \033[0m"
        echo -e "\033[31m 是否根据新的config编译？ \033[0m"
        echo -e  "\033[31m 将会在$timer秒后自动选择默认值 \033[0m"
        echo -e "\033[34m 1. 是(默认值) \033[0m"
        echo -e "\033[34m 2. 不编译了。退出 \033[0m"
        read -t $timer num_continue
            if [ ! -n "$num_continue" ]; then
                num_continue=1
                echo -e "\033[34m 使用默认值 \033[0m"
            fi
    done
    
    if [[ $num_continue == 1 ]]; then
        Compile_Firmware
    else
        exit
    fi

fi

echo

