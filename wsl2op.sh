#!/bin/bash
# OP编译



echo -e  "\033[34m 注意，请确保当前linux账户为非root账户，并且已经安装相关编译依赖 \033[0m"
echo -e  "\033[34m 如果不符合上述条件，请ctrl+C退出 \033[0m"


# 默认lean源码文件夹名
ledeDir=ledex64

# 编译环境中当前账户名字
userName=$USER
# 默认OpenWrtAction的Config文件夹中的config文件名
configName=x64.config
config_list=($(ls /home/$userName/OpenWrtAction/config))
# 默认输入超时时间，单位为秒
timer=15
# 编译环境默认值，1为WSL2，2为非WSL2的Linux环境。不要修改这里
sysenv=1
# OpenWrtAction Git URL
owaUrl=https://github.com/smallprogram/OpenWrtAction.git

# 函数
function Compile_Firmware() 
{
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
    

    folder_name=编译日志${configName}_$(date "+%Y-%m-%d-%H-%M-%S")
    logfile_name=编译时间日志$(date "+%Y-%m-%d-%H-%M-%S")
    begin_date=开始时间$(date "+%Y-%m-%d-%H-%M-%S")

    echo -e  "\033[34m 创建编译日志文件夹/home/${userName}/smb_openwrt/$folder_name \033[0m"
    sleep 1s

    if [ ! -d "/home/${userName}/smb_openwrt" ];
    then
        mkdir /home/${userName}/smb_openwrt
    fi
    mkdir /home/${userName}/smb_openwrt/$folder_name
    touch /home/${userName}/smb_openwrt/$folder_name/Main1_make_defconfig-git_log.log
    touch /home/${userName}/smb_openwrt/$folder_name/Main2_make_download-git_log.log
    touch /home/${userName}/smb_openwrt/$folder_name/Main3_Compile-git_log.log
    echo -e $begin_date > /home/${userName}/smb_openwrt/$folder_name/${logfile_name}.txt

    echo -e  "\033[34m 编译日志文件夹创建成功 \033[0m"
    sleep 1s
    echo -e  "\033[34m 开始编译！！ \033[0m"
    sleep 1s


    cd /home/${userName}/${ledeDir}
    if [ -n "$isCleanCompile" ]; then
        make clean
        make dirclean
    fi
    make defconfig | tee -a /home/${userName}/smb_openwrt/$folder_name/Main1_make_defconfig-git_log.log
    make -j8 download V=s | tee -a /home/${userName}/smb_openwrt/$folder_name/Main2_make_download-git_log.log
    if [[ $sysenv == 1 ]]
    then
        # echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make -j$(($(nproc) + 1)) V=s | tee -a /home/${userName}/smb_openwrt/$folder_name/Main3_Compile-git_log.log
    else
        # $PATH
        make -j$(($(nproc) + 1)) V=s | tee -a /home/${userName}/smb_openwrt/$folder_name/Main3_Compile-git_log.log
    fi

    end_date=结束时间$(date "+%Y-%m-%d-%H-%M-%S")
    echo -e $end_date >> /home/zhusir/smb_openwrt/$folder_name/${logfile_name}.txt

    ######是否提交编译结果到github Release


    echo -e "\033[31m 是否拷贝编译固件到smb_openwrt/${folder_name}下？不输入默认不拷贝，输入任意值拷贝 \033[0m"
    echo -e  "\033[31m 将会在$timer秒后自动选择默认值 \033[0m"
    read -t $timer iscopy
    if [ ! -n "$iscopy" ]; then
        echo -e  "\033[34m OK，不拷贝 \033[0m"
    else
        echo -e  "\033[34m 开始拷贝 \033[0m"
        cp -r /home/${userName}/${ledeDir}/bin/targets /home/zhusir/smb_openwrt/$folder_name
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
            # echo $configNameInp
            # echo $configName
        fi
    fi
}

# end函数



echo -e "\033[31m 请输入默认lean源码文件夹名称,如果不输入默认$ledeDir,将在($timer秒后使用默认值) \033[0m"
echo -e  "\033[31m 将会在$timer秒后自动选择默认值 \033[0m"
read -t $timer ledeDirInp
if [ ! -n "$ledeDirInp" ]; then
    echo -e  "\033[34m OK，使用默认值ledex64 \033[0m"
else
    echo -e  "\033[34m 使用 ${ledeDirInp} 作为lean源码文件夹名。 \033[0m"
    ledeDir=$ledeDirInp
fi

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


echo
echo -e "\033[31m 开始同步lean源码.... \033[0m"
sleep 2s

cd /home/${userName}
if [ ! -d "/home/${userName}/${ledeDir}" ];
then
    git clone https://github.com/coolsnowwolf/lede ${ledeDir}
    cd ${ledeDir}/package/lean
    rm -rf luci-theme-argon  
    git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git 
    cd /home/${userName}
else 
    cd ${ledeDir}
    git pull
    cd /home/${userName}
fi

echo
echo -e "\033[31m 开始同步luci-theme-argon.... \033[0m"
sleep 2s


cd /home/${userName}/${ledeDir}/package/lean/luci-theme-argon
git pull
cd /home/${userName}

echo
echo -e "\033[31m 开始同步luci-app-argon-config.... \033[0m"
sleep 2s

if [ ! -d "/home/${userName}/${ledeDir}/package/lean/luci-app-argon-config" ];
then
    cd /home/${userName}/${ledeDir}/package/lean/
    git clone https://github.com/jerrykuku/luci-app-argon-config.git
    cd /home/${userName}
else
    cd /home/${userName}/${ledeDir}/package/lean/luci-app-argon-config
    git pull
    cd /home/${userName}
fi

echo
echo -e "\033[31m 开始同步lua-maxminddb.... \033[0m"
sleep 2s

if [ ! -d "/home/${userName}/${ledeDir}/package/lean/lua-maxminddb" ];
then
    cd /home/${userName}/${ledeDir}/package/lean/
    git clone https://github.com/jerrykuku/lua-maxminddb.git 
    cd /home/${userName}
else
    cd /home/${userName}/${ledeDir}/package/lean/lua-maxminddb
    git pull
    cd /home/${userName}
fi

echo
echo -e "\033[31m 开始同步luci-app-vssr.... \033[0m"
sleep 2s


if [ ! -d "/home/${userName}/${ledeDir}/package/lean/luci-app-vssr" ];
then
    cd /home/${userName}/${ledeDir}/package/lean/
    git clone https://github.com/jerrykuku/luci-app-vssr.git
    cd /home/${userName}
else
    cd /home/${userName}/${ledeDir}/package/lean/luci-app-vssr
    git pull
    cd /home/${userName}
fi

echo
echo -e "\033[31m 开始同步luci-app-dockerman.... \033[0m"
sleep 2s

if [ ! -d "/home/${userName}/${ledeDir}/package/lean/luci-app-dockerman" ];
then
    cd /home/${userName}/${ledeDir}/package/lean/
    git clone https://github.com/lisaac/luci-app-dockerman.git  
    cd /home/${userName}
else
    cd /home/${userName}/${ledeDir}/package/lean/luci-app-dockerman
    git pull
    cd
fi

echo
echo -e "\033[31m 开始同步OpenWrtAction.... \033[0m"
sleep 2s
cd /home/${userName}

if [ ! -d "/home/${userName}/OpenWrtAction" ];
then
    git clone $owaUrl
    cd /home/${userName}
else
    cd /home/${userName}/OpenWrtAction
    git pull
    cd /home/${userName}
fi

echo
echo -e "\033[31m 开始将OpenwrtAction中的自定义feeds与config文件注入lean源码中.... \033[0m"
sleep 2s
echo
cat /home/${userName}/OpenWrtAction/feeds_config/custom.feeds.conf.default > /home/${userName}/${ledeDir}/feeds.conf.default
cat /home/${userName}/OpenWrtAction/config/${configName} > /home/${userName}/${ledeDir}/.config

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
        git commit -m "update config"
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

