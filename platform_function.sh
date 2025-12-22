#!/bin/bash

# OP编译
# Copyright (c) 2019-2024 smallprogram
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/smallprogram/OpenWrtAction
# File: wsl2op_function.sh
# Description: WSL automatically compiles Openwrt script code

function Func_LogMessage() {
    Begin="\033[1;96m"
    End="\033[0m"

    if [ ! -n "$isChinese" ]; then
        echo -e "${Begin}$1${End}"
    else
        echo -e "${Begin}$2${End}"
    fi
}

function Func_LogSuccess() {
    Begin="\033[1;92m"
    End="\033[0m"

    if [ ! -n "$isChinese" ]; then
        echo -e "${Begin}$1${End}"
    else
        echo -e "${Begin}$2${End}"
    fi
}

function Func_LogError() {
    Begin="\033[1;91m"
    End="\033[0m"

    if [ ! -n "$isChinese" ]; then
        echo -e "${Begin}$1${End}"
    else
        echo -e "${Begin}$2${End}"
    fi
}
# DIY Script函数


function Func_Copy_Backgroundfiles() {
    local is_wsl2op=$1
    local platform_config=$2
    local platform="${platform_config%%.config}"

    # Func_LogMessage "开始执行背景文件生成脚本" "Start executing copy background files script"
    # sleep 1s

    # bash ../OpenWrtAction/compile_script/step04_copy_backgroundfiles.sh "$is_wsl2op" "$platform"

    # Func_LogSuccess "背景文件生成脚本执行完成" "copy background files script execution completed"
    # sleep 2s
}

# function Func_ZH_CN_Init(){
#     sed -i '/^# .*zh-cn.* is not set$/ { s/^# //; s/ is not set$/=y/ }' "$1"
# }

#GIT设置
function Func_GitSetting() {
    git config --global user.email "${git_email}"
    git config --global user.name "${git_user}"
    export GIT_SSL_NO_VERIFY=1
}

# 编译报错检查函数
check_compile_error() {
    local is_compile_error=$1
    local messages=$2

    if [ "$is_compile_error" -ne 0 ]; then
        Func_LogError "${messages},的编译状态:${is_compile_error}" "${messages}，Compile Status Code:${is_complie_error}"
        exit $1
    else
        Func_LogSuccess "${messages},的编译状态:${is_compile_error}" "${messages}，Compile Status Code:${is_complie_error}"
    fi
}

# config文件夹的config文件列表函数
function Func_ConfigList() {
    key=0
    for conf in ${config_list[*]}; do
        key=$((${key} + 1))
        echo "$key: $conf"
        # echo "129 key的值："$key
    done
    read -t $timer configNameInp
    if [ ! -n "$configNameInp" ]; then
        i=1
        for context in ${config_list[*]}; do
            if [[ $context == $config_name ]]; then
                break
            fi
            i=$((${i} + 1))
            # echo "142 i的值："$i
        done
        configNameInp=$i
        # echo "145 configNameInp的值："$configNameInp
        Func_LogError "输入超时使用默认值$config_name" "Use the default value $config_name for input timeout"
    else
        if [[ $configNameInp -ge 1 && $configNameInp -le $key ]]; then
            config_name=${config_list[$(($configNameInp - 1))]}
            openwrt_dir=${openwrt_dir_front}_${openwrt_branch}_${config_name}
            # echo $configNameInp
            # echo $configName
        fi
    fi
}

#清理日志文件夹函数
function Func_CleanLogFolder() {
    if [ -d "/home/${user_name}/${log_folder_name}" ]; then
        Func_LogMessage "是否清理存储超过$clean_day天的日志文件，默认删除，如果录入任意值不删除" "Whether to clean up the log files stored for more than $clean_day days, delete by default, if you enter any value, it will not be deleted"
        Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
        read -t $timer isclean
        if [ ! -n "$isclean" ]; then
            cd /home/${user_name}/${log_folder_name}
            find -mtime +$clean_day -type d | xargs rm -rf
            find -mtime +$clean_day -type f | xargs rm -rf
            Func_LogSuccess "清理成功" "Cleaned up successfully"
        else
            Func_LogSuccess "OK，不清理超过$clean_day天的日志文件" "OK, do not clean up log files older than $clean_day"
        fi
    fi

}

# 同步源码函数
function Func_SyncGitSource(){
    echo
    Func_LogMessage "开始同步源码...." "Start to synchronize source code..."
    sleep 2s

    cd /home/${user_name}
    if [ ! -d "/home/${user_name}/${openwrt_dir}" ]; then
        git clone -b ${openwrt_branch} --single-branch $openwrt_source  ${openwrt_dir}
        cd /home/${user_name}
        is_first_compile=1
    else
        cd ${openwrt_dir}
        
        git fetch --prune origin

        git reset --hard origin/${openwrt_branch}


        cd /home/${user_name}
        is_first_compile=0
    fi
}

# make clean函数
function Func_CleanCompile(){
    # CheckUpdate
    cd /home/${user_name}/${openwrt_dir}
    begin_date=开始时间$(date "+%Y-%m-%d-%H-%M-%S")
    folder_name=log_Compile_${config_name}_$(date "+%Y-%m-%d-%H-%M-%S")
    Func_LogMessage "是否启用Clean编译，如果不输入任何值默认否，输入任意值启用Clean编译，Clean操作适用于大版本更新" "Whether to enable Clean compilation, if you do not enter any value, the default is No, enter any value to enable Clean compilation, Clean operation is suitable for major version updates"
    Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
    read -t $timer is_clean_compile
    if [ ! -n "$is_clean_compile" ]; then
        Func_LogMessage "不执行make clean && make dirclean " "OK, do not execute make clean && make dirclean "
    else
        Func_LogMessage "配置为Clean编译。执行make clean && make dirclean" "OK, configure for Clean compilation."
        # make clean
        # make dirclean
        make distclean
        Func_LogSuccess "执行make clean && make dirclean完毕，准备开始编译" "Ready to compile"
        sleep 1s
    fi
    Func_LogMessage "创建编译日志文件夹/home/${user_name}/${log_folder_name}/${folder_name}" "Create compilation log folder /home/${user_name}/${log_folder_name}/${folder_name}"
    sleep 1s

    mkdir -p /home/${user_name}/${log_folder_name}
    mkdir -p /home/${user_name}/${log_folder_name}/${folder_name}

    echo -e $begin_date >/home/${user_name}/${log_folder_name}/${folder_name}/Func_Main6_Compile_Time-git_log.log

    Func_LogSuccess "编译日志文件夹创建成功" "The compilation log folder was created successfully"
    sleep 1s
    Func_LogMessage "开始编译！！" "Start compiling! !"
    sleep 1s
}

# DIY1 Script函数
function Func_DIY1_Script() {
    Func_LogMessage "开始执行DIY1设置脚本" "Start executing the DIY1 setup script"
    sleep 1s

    bash ../OpenWrtAction/$diy_script_1

    Func_LogSuccess "DIY1脚本执行完成" "DIY script execution completed"
    sleep 2s
}

# feeds更新函数，防止feeds force push导致feeds无法更新
function Func_FeedsUpdate() {

    Func_LogMessage "是否清理feeds，如果不输入任何值默认否，输入任意值清理feeds" "Whether to clean up feeds. If no value is entered, the default is "no". If any value is entered, the feeds are cleaned up."
    Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
    read -t $timer is_clean_feeds
    if [ ! -n "$is_clean_feeds" ]; then
        Func_LogSuccess "OK，不清理feeds " "OK, do not clean up feeds"
    else
        Func_LogMessage "开始clean feeds...." "begin update feeds...."
        ./scripts/feeds clean
    fi
    echo


    Func_LogMessage "强制同步 feeds 到远程最新状态..." "Force syncing feeds to latest remote..."

    for d in feeds/*; do
        if [ -d "$d/.git" ]; then
            echo "Syncing feed: $d"

            # 清理过时引用 + 拉取最新
            git -C "$d" fetch --prune origin

            # 强制重置到当前分支的远程最新版本（@{u} 是 upstream 的简写）
            git -C "$d" reset --hard @{u}

            # 彻底清理残留文件（-x 会连 .gitignore 里的也删掉，更干净）
            git -C "$d" clean -fdx
        fi
    done

    Func_LogMessage "开始 update feeds..." "Updating feeds..."
    sleep 1
    ./scripts/feeds update -a | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/Func_Main1_feeds_update-git_log.log
    echo

    Func_LogMessage "开始 install feeds..." "Installing feeds..."
    sleep 1
    ./scripts/feeds install -a | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/Func_Main2_feeds_install-git_log.log
    echo
}

# DIY2 Script函数
function Func_DIY2_Script() {
    Func_LogMessage "开始执行DIY2设置脚本" "Start executing the DIY2 setup script"
    sleep 1s

    bash ../OpenWrtAction/$diy_script_2

    Func_LogSuccess "DIY2脚本执行完成" "DIY script execution completed"
    sleep 2s
}

# make defconfig函数
function Func_Defconfig(){
    echo
    Func_LogMessage "开始将OpenwrtAction中config文件夹下的${config_name}注入源码中,准备make toolchain...." "Start to inject ${config_name} under the config folder in OpenwrtAction into source code..."
    sleep 2s
    echo
    cp /home/${user_name}/OpenWrtAction/$config_dir/${config_name} /home/${user_name}/${openwrt_dir}/.config

    cp /home/${user_name}/${openwrt_dir}/.config /home/${user_name}/${log_folder_name}/${folder_name}/.config_old
    # echo -e "\nCONFIG_ALL=y" >> .config
    # echo -e "\nCONFIG_ALL_NONSHARED=y" >> .config

    Func_LogMessage "开始执行make defconfig!" "Start to execute make defconfig!"
    sleep 1s
    make defconfig | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/Func_Main3_make_defconfig-git_log.log

    cp /home/${user_name}/${openwrt_dir}/.config /home/${user_name}/${log_folder_name}/${folder_name}/.config_new
    diff /home/${user_name}/${log_folder_name}/${folder_name}/.config_old /home/${user_name}/${log_folder_name}/${folder_name}/.config_new -y -W 200 >/home/${user_name}/${log_folder_name}/${folder_name}/.config_diff

}

# make download函数
function Func_MakeDownload() {
    Func_LogMessage "开始执行make download!" "Start to execute make download!"
    sleep 1s
    make -j8 download | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/Func_Main4_make_download-git_log.log
    is_complie_error=${PIPESTATUS[0]}
    check_compile_error "$is_complie_error" "make download"

    Func_LogMessage "开始清理download残留!" "Start cleaning up download residue!"
    find dl -mindepth 1 -type d -exec rm -rf {} \;
    find dl -size -1024c -exec ls -l {} \;
    find dl -size -1024c -exec rm -f {} \;
}

# make toolchain函数
function Func_MakeToolchain() {
        echo
    Func_LogMessage "开始make toolchain." "Begin make toolchain"
    sleep 2s
    echo
    if [[ $sysenv == 1 ]]; then
        Func_LogMessage "是否启用单线程编译，如果不输入任何值默认否，输入任意值启用单线程编译" "Whether to enable single-threaded compilation, if you do not enter any value, the default is No, enter any value to enable single-threaded compilation"
        Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
        read -t $timer is_single_compile
        if [ ! -n "$is_single_compile" ]; then
            Func_LogSuccess "OK，不执行单线程编译 " "OK, do not perform single-threaded compilation "
            sleep 1s
            # echo "PATH=$wsl_path"
            PATH=$wsl_path make toolchain/compile -j$(nproc) $is_VS | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile2_toolchain.log
            is_complie_error=${PIPESTATUS[0]}
        else
            Func_LogSuccess "OK，执行单线程编译。" "OK, execute single-threaded compilation."
            Func_LogMessage "准备开始编译" "Ready to compile"
            sleep 1s
            PATH=$wsl_path make toolchain/compile -j1 $is_VS | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile2_toolchain.log
            is_complie_error=${PIPESTATUS[0]}
        fi

    else
        Func_LogMessage "是否启用单线程编译，如果不输入任何值默认否，输入任意值启用单线程编译" "Whether to enable single-threaded compilation, if you do not enter any value, the default is No, enter any value to enable single-threaded compilation"
        Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
        read -t $timer is_single_compile
        if [ ! -n "$is_single_compile" ]; then
            Func_LogSuccess "OK，不执行单线程编译 " "OK, do not perform single-threaded compilation "
            sleep 1s
            # echo "PATH=$wsl_path"
            make toolchain/compile -j$(nproc) $is_VS | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile2_toolchain.log
            is_complie_error=${PIPESTATUS[0]}
        else
            Func_LogSuccess "OK，执行单线程编译。" "OK, execute single-threaded compilation."
            Func_LogMessage "准备开始编译" "Ready to compile"
            sleep 1s
            make toolchain/compile -j1 $is_VS | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile2_toolchain.log
            is_complie_error=${PIPESTATUS[0]}
        fi
        # $PATH
    fi

    check_compile_error "$is_complie_error" "make toolchain"
}

# make固件函数
function Func_MakeFirmware() {
    Func_LogMessage "开始执行生成固件" "Start to Generate Frimware!"
    sleep 1s
    if [[ $sysenv == 1 ]]; then
        Func_LogMessage "是否启用单线程编译，如果不输入任何值默认否，输入任意值启用单线程编译" "Whether to enable single-threaded compilation, if you do not enter any value, the default is No, enter any value to enable single-threaded compilation"
        Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
        read -t $timer is_single_compile
        if [ ! -n "$is_single_compile" ]; then
            Func_LogSuccess "OK，不执行单线程编译 " "OK, do not perform single-threaded compilation "
            sleep 1s
            # echo "PATH=$wsl_path"
            if [ ! -n "$is_VS" ]; then
                if [ ! -n "$is_showTime" ]; then
                    PATH=$wsl_path make -j$(nproc) | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile6_Generate_Frimware.log
                    is_complie_error=${PIPESTATUS[0]}
                else
                    PATH=$wsl_path stdbuf -oL  make -j$(nproc) | perl -nE 'state $last = time(); $now = time(); chomp; print "[⬆" . ($now - $last) . "s] $_\n"; $last = $now' | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile6_Generate_Frimware.log
                    is_complie_error=${PIPESTATUS[0]}
                fi
            else
                PATH=$wsl_path make -j$(nproc) $is_VS | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile6_Generate_Frimware.log
                is_complie_error=${PIPESTATUS[0]}
            fi
        else
            Func_LogSuccess "OK，执行单线程编译。" "OK, execute single-threaded compilation."
            Func_LogMessage "准备开始编译" "Ready to compile"
            sleep 1s
            if [ ! -n "$is_VS" ]; then
                if [ ! -n "$is_showTime" ]; then
                    PATH=$wsl_path make -j1 | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile6_Generate_Frimware.log
                    is_complie_error=${PIPESTATUS[0]}
                else
                    PATH=$wsl_path stdbuf -oL  make -j1 | perl -nE 'state $last = time(); $now = time(); chomp; print "[⬆" . ($now - $last) . "s] $_\n"; $last = $now' | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile6_Generate_Frimware.log
                    is_complie_error=${PIPESTATUS[0]}
                fi               
            else
                PATH=$wsl_path make -j1 $is_VS | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile6_Generate_Frimware.log
                is_complie_error=${PIPESTATUS[0]}
            fi
        fi

    else
        Func_LogMessage "是否启用单线程编译，如果不输入任何值默认否，输入任意值启用单线程编译" "Whether to enable single-threaded compilation, if you do not enter any value, the default is No, enter any value to enable single-threaded compilation"
        Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
        read -t $timer is_single_compile
        if [ ! -n "$is_single_compile" ]; then
            Func_LogSuccess "OK，不执行单线程编译 " "OK, do not perform single-threaded compilation "
            sleep 1s
            if [ ! -n "$is_VS" ]; then
                if [ ! -n "$is_showTime" ]; then
                    make -j$(nproc) | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile6_Generate_Frimware.log
                    is_complie_error=${PIPESTATUS[0]}
                else
                    stdbuf -oL  make -j$(nproc) | perl -nE 'state $last = time(); $now = time(); chomp; print "[⬆" . ($now - $last) . "s] $_\n"; $last = $now' | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile6_Generate_Frimware.log
                    is_complie_error=${PIPESTATUS[0]}
                fi
            else
                make -j$(nproc) $is_VS | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile6_Generate_Frimware.log
                is_complie_error=${PIPESTATUS[0]}
            fi
        else
            Func_LogSuccess "OK，执行单线程编译。" "OK, execute single-threaded compilation."
            Func_LogMessage "准备开始编译" "Ready to compile"
            sleep 1s
            if [ ! -n "$is_VS" ]; then
                if [ ! -n "$is_showTime" ]; then
                    make -j1 | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile6_Generate_Frimware.log
                    is_complie_error=${PIPESTATUS[0]}
                else
                    stdbuf -oL  make -j1 | perl -nE 'state $last = time(); $now = time(); chomp; print "[⬆" . ($now - $last) . "s] $_\n"; $last = $now' | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile6_Generate_Frimware.log
                    is_complie_error=${PIPESTATUS[0]}
                fi
                
            else
                make -j1 $is_VS | tee -a /home/${user_name}/${log_folder_name}/${folder_name}/log_Compile6_Generate_Frimware.log
                is_complie_error=${PIPESTATUS[0]}
            fi
        fi
        # $PATH
    fi

    check_compile_error "$is_complie_error" "Generate Frimware"

    Func_LogMessage "编译状态:${is_complie_error}" "Compile Status Code:${is_complie_error}"

    Func_LogMessage "make编译结束!" "Make compilation is over!"
    sleep 1s

    end_date=结束时间$(date "+%Y-%m-%d-%H-%M-%S")
    echo -e $end_date >>/home/${user_name}/${log_folder_name}/${folder_name}/Func_Main6_Compile_Time-git_log.log
}

# 编译函数
function Func_Compile_Firmware() {
    
    Func_SyncGitSource

    Func_CleanCompile

    Func_DIY1_Script
    
    Func_FeedsUpdate

    Func_DIY2_Script

    Func_Copy_Backgroundfiles "1" "${config_name}"

    Func_Defconfig
    
    Func_MakeDownload

    Func_MakeToolchain

    Func_MakeFirmware
    
    Func_LogMessage "是否拷贝编译固件到${log_folder_name}/${folder_name}下？不输入默认不拷贝，输入任意值拷贝" "Do you want to copy and compile the firmware to ${log_folder_name}/${folder_name}? Don’t copy by default, input any value to copy"
    Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
    read -t $timer iscopy
    if [ ! -n "$iscopy" ]; then
        Func_LogSuccess "OK，不拷贝" "OK, don't copy"
    else
        Func_LogMessage "开始拷贝" "Start copying"
        cp -r /home/${user_name}/${openwrt_dir}/bin/targets /home/${user_name}/${log_folder_name}/${folder_name}
        Func_LogSuccess "拷贝完成" "Copy completed"
    fi
}

function Func_Wsl2Check(){
    echo
    Func_LogMessage "准备就绪，请按照导航选择操作...." "Ready, please follow the navigation options..."
    sleep 2s

    Func_LogMessage "你的编译环境是WSL2并且没有配置appendWindowsPath吗？" "Is your compilation environment WSL2?"
    Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
    Func_LogError "关于WSL2如何通过配置屏蔽Windows宿主机的环境变量，请参考:https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config ，配置wsl.conf的appendWindowsPath值" "Regarding how WSL2 shields the environment variables of the Windows host through configuration, please refer to: https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config and configure the appendWindowsPath value of wsl.conf"
    Func_LogMessage "1. 是" "1. Yes"
    Func_LogMessage "2. 不是(默认) " "2. NO (default)"
    read -t $timer sysenv
    if [ ! -n "$sysenv" ]; then
        sysenv=1
        Func_LogError "输入超时使用默认值" "Use default value for input timeout"
    fi
    until [[ $sysenv -ge 1 && $sysenv -le 2 ]]; do
        Func_LogMessage "你的编译环境是WSL2并且没有配置appendWindowsPath吗？" "Is your compilation environment WSL2?"
        Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
        Func_LogError "关于WSL2如何通过配置屏蔽Windows宿主机的环境变量，请参考:https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config ，配置wsl.conf的appendWindowsPath值" "Regarding how WSL2 shields the environment variables of the Windows host through configuration, please refer to: https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config and configure the appendWindowsPath value of wsl.conf"
        Func_LogMessage "1. 是" "1. Yes"
        Func_LogMessage "2. 不是(默认) " "2. NO (default)"
        read -t $timer sysenv
        if [ ! -n "$sysenv" ]; then
            sysenv=1
            Func_LogSuccess "使用默认值" "Use default"
        fi
    done
    echo
}

#主函数
function Func_Main() {
    # GitSetting
    Func_GitSetting
    # 默认语言中文，其他英文
    echo -e "请选择默认语言，输入任意字符为英文，不输入默认中文"
    echo -e "Please select the default language, enter any character as English, and do not enter the default Chinese."
    read -t $timer isChinese

    Func_LogMessage "注意，请确保当前linux账户为非root账户，并且已经安装相关编译依赖" "Note, please make sure that the current linux account is a non-root account, and the relevant compilation dependencies have been installed"
    Func_LogMessage "如果不符合上述条件，请安装依赖或ctrl+C退出" "If the above conditions are not met, please Install dependencies or ctrl+C to exit"
    Func_LogMessage "是否安装编译依赖，不输入默认不安装，输入任意值安装，将会在$timer秒后自动选择默认值" "Whether to install the compilation dependencies. Do not enter the default. Do not install. Enter any value to install. The default value will be automatically selected after $timer seconds"
    read -t $timer dependencies
    if [ ! -n "$dependencies" ]; then
        Func_LogSuccess "OK，不安装" "OK, Not installed"
    else
        Func_LogMessage "开始安装" "Start installation"
        sudo apt update -y
        sudo apt full-upgrade -y
        sleep 5s
        sudo apt -y install $(curl -fsSL $my_depends)
        sleep 5s
        git config --global http.sslverify false
        git config --global https.sslverify false
        Func_LogSuccess "安装完成" "Installation Completed"
    fi

    Func_Wsl2Check
    Func_CleanLogFolder
    sleep 2s

    Func_LogMessage "是否创建新的编译配置，默认否，输入任意字符将创建新的配置" "Whether to create a new compilation configuration, the default is no, input any character will create a new configuration"
    Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
    read -t $timer isCreateNewConfig
    if [ ! -n "$isCreateNewConfig" ]; then
        Func_LogSuccess "OK，不创建新的编译配置" "OK, do not create a new compilation configuration"
        openwrt_dir=${openwrt_dir_front}_${openwrt_branch}_${config_name}

        echo
        Func_LogMessage "请输入默认OpenwrtAction中的config文件名，默认为$config_name" "Please enter the config file name in the default OpenwrtAction, the default is $config_name"
        Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
        Func_ConfigList
        until [[ $configNameInp -ge 1 && $configNameInp -le $key ]]; do
            Func_LogError "你输入的 ${configNameInp} 是啥玩应啊，看好了序号，输入数值就行了。" "What is the function of the ${configNameInp} you entered? Just take a good look at the serial number and just enter the value."
            Func_LogMessage "请输入默认OpenwrtAction中的config文件名，默认为$config_name" "Please enter the config file name in the default OpenwrtAction, the default is $config_name"
            Func_ConfigList
        done

        Func_LogMessage "请输入默认源码文件夹名称,如果不输入默认$openwrt_dir,将在($timer秒后使用默认值)" "Please enter the default source folder name, if you do not enter the default $openwrt_dir, the default value will be used after ($timer seconds)"
        Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
        read -t $timer openwrt_dirInp
        if [ ! -n "$openwrt_dirInp" ]; then
            Func_LogSuccess "OK，使用默认值$openwrt_dir" "OK, use the default value $openwrt_dir"
        else
            Func_LogMessage "使用 ${openwrt_dir_front}_${openwrt_branch}_${config_name} 作为源码文件夹名。" "Use ${openwrt_dir_front}${config_name} as the source folder name."
            echo -e
            openwrt_dir=${openwrt_dir_front}_${openwrt_branch}_${config_name}
        fi

        Func_LogMessage "你接下来要干啥？？？" "What are you going to do next? ? ?"
        Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
        Func_LogMessage "1. 根据config自动编译固件。(默认)" "1. Automatically compile the firmware according to config. (default) "
        Func_LogMessage "2. 我要配置config，配置完毕后自动同步回OpenwrtAction。" "2. I want to configure config, and automatically synchronize back to OpenwrtAction after configuration."
        read -t $timer num
        if [ ! -n "$num" ]; then
            num=1
            Func_LogSuccess "使用默认值" "Use default"
        fi
        # echo $num
        until [[ $num -ge 1 && $num -le 2 ]]; do
            Func_LogMessage "你输入的 ${num} 是啥玩应啊，看好了序号，输入数值就行了。" "What is the function of the ${num} you entered? Just enter the number after you are optimistic about the serial number."
            Func_LogMessage "你接下来要干啥？？？" "What are you going to do next? ? ?"
            Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
            Func_LogMessage "1. 根据config自动编译固件。(默认)" "1.Automatically compile the firmware according to config. (default)"
            Func_LogMessage "2. 我要配置config，配置完毕后自动同步回OpenwrtAction。" "2.I want to configure config, and automatically synchronize back to OpenwrtAction after configuration."
            read -t $timer num
            if [ ! -n "$num" ]; then
                num=1
                Func_LogSuccess "使用默认值" "Use default"
            fi
        done

        if [[ $num == 1 ]]; then
            Func_Compile_Firmware
        fi

        if [[ $num == 2 ]]; then
            echo
            cd /home/${user_name}/${openwrt_dir}

            Func_LogMessage "创建编译日志文件夹/home/${user_name}/${log_folder_name}/${folder_name}" "Create compilation log folder /home/${user_name}/${log_folder_name}/${folder_name}"
            sleep 1s

            mkdir -p /home/${user_name}/${log_folder_name}
            mkdir -p /home/${user_name}/${log_folder_name}/${folder_name}

            echo -e $begin_date >/home/${user_name}/${log_folder_name}/${folder_name}/Func_Main6_Compile_Time-git_log.log

            Func_LogSuccess "编译日志文件夹创建成功" "The compilation log folder was created successfully"
            sleep 1s


            Func_SyncGitSource
            cd /home/${user_name}/${openwrt_dir}
            Func_DIY1_Script
            Func_FeedsUpdate
            Func_DIY2_Script
            Func_Copy_Backgroundfiles "1" "${config_name}"

            echo
            Func_LogMessage "开始将OpenwrtAction中config文件夹下的${config_name}注入源码中...." "Start to inject ${config_name} under the config folder in OpenwrtAction into source code..."
            sleep 2s
            echo
            cp /home/${user_name}/OpenWrtAction/$config_dir/${config_name} /home/${user_name}/${openwrt_dir}/.config

            


            cd /home/${user_name}/${openwrt_dir}
            make menuconfig
            cp /home/${user_name}/${openwrt_dir}/.config /home/${user_name}/OpenWrtAction/$config_dir/${config_name}
            cd /home/${user_name}/OpenWrtAction

            if [ ! -n "$(git config --global user.email)" ]; then
                Func_LogSuccess "请输入git Global user.email:" "Please enter git Global user.email:"
                read gitUserEmail
                until [[ -n "$gitUserEmail" ]]; do
                    Func_LogError "不能输入空值" "Cannot enter a null value"
                    read gitUserEmail
                done
                git config --global user.email "$gitUserEmail"
            fi

            if [ ! -n "$(git config --global user.name)" ]; then
                Func_LogSuccess "请输入git Global user.name:" "Please enter git Global user.name:"
                read gitUserName
                until [[ -n "$gitUserName" ]]; do
                    Func_LogError "不能输入空值" "Cannot enter a null value"
                    read gitUserName
                done
                git config --global user.email "$gitUserName"
            fi

            if [ -n "$(git status -s)" ]; then
                git add .
                git commit -m "update $config_name from local bash"
                git push origin
                Func_LogSuccess "已将新配置的config同步回OpenwrtAction" "The newly configured config has been synchronized back to OpenwrtAction"
                sleep 2s
            fi

            Func_LogMessage "是否根据新的config编译？" "Is it compiled according to the new config?"
            Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
            Func_LogMessage "1. 是(默认值)" "1.Yes(Default)"
            Func_LogMessage "2. 不编译了。退出" "2.NO, Exit"
            read -t $timer num_continue
            if [ ! -n "$num_continue" ]; then
                num_continue=1
            fi
            until [[ $num_continue -ge 1 && $num_continue -le 2 ]]; do
                Func_LogMessage "你输入的 ${num_continue} 是啥玩应啊，看好了序号，输入数值就行了。" "What's the answer for the ${num_continue} you entered? Just enter the number after you are optimistic about the serial number."
                Func_LogMessage "是否根据新的config编译？" "Is it compiled according to the new config?"
                Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
                Func_LogMessage "1. 是(默认值)" "1. Yes(Default)"
                Func_LogMessage "2. 不编译了。退出  NO, Exit" "2.NO, Exit"
                read -t $timer num_continue
                if [ ! -n "$num_continue" ]; then
                    num_continue=1
                    Func_LogSuccess "使用默认值" "Use default"
                fi
            done

            if [[ $num_continue == 1 ]]; then
                Func_Compile_Firmware
            else
                exit
            fi
        fi
    else
        Func_LogMessage "请输入新的Config文件名，请以xxx.config命名，例如xiaomi3.config" "Please enter the new Config file name, please name it after xxx.config, for example xiaomi3.config"
        read newConfigName
        for conf in ${config_list[*]}; do
            if [[ $newConfigName = $conf ]]; then
                newConfigName=''
            fi
        done
        until [[ -n "$newConfigName" ]]; do
            Func_LogError "你输入的值为空或者与现有config文件名重复,请重新输入！" "The value you entered is empty or duplicates the name of the existing config file, please re-enter!"
            read newConfigName
            for conf in ${config_list[*]}; do
                if [[ $newConfigName = $conf ]]; then
                    newConfigName=''
                fi
            done
        done
        config_name=$newConfigName
        openwrt_dir=${openwrt_dir_front}_${openwrt_branch}_${config_name}

        Func_SyncGitSource
        Func_CleanCompile
        Func_DIY1_Script
        Func_FeedsUpdate
        Func_DIY2_Script
        rm -rf .config
        make menuconfig

        Func_LogMessage "是否加载seed" "Is it add seed?"
        Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
        Func_LogMessage "1. 是(默认值)" "1.Yes(Default)"
        Func_LogMessage "2. 不加载seed" "2.NO"
        read -t $timer is_add_seed
        if [ ! -n "$is_add_seed" ]; then
            is_add_seed=1
        fi
        until [[ $is_add_seed -ge 1 && $is_add_seed -le 2 ]]; do
            Func_LogMessage "你输入的 ${is_add_seed} 是啥玩应啊，看好了序号，输入数值就行了。" "What's the answer for the ${is_add_seed} you entered? Just enter the number after you are optimistic about the serial number."
            Func_LogMessage "是否加载seed" "Is it add seed?"
            Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
            Func_LogMessage "1. 是(默认值)" "1.Yes(Default)"
            Func_LogMessage "2. 不加载seed" "2.NO"
            read -t $timer is_add_seed
            if [ ! -n "$is_add_seed" ]; then
                is_add_seed=1
                Func_LogSuccess "使用默认值" "Use default"
            fi
        done
        if [[ $is_add_seed == 1 ]]; then
            cat ../OpenWrtAction/config/seed/${openwrt_dir_front}_seed.config >> .config
            make defconfig
        fi
        


        cp -f .config ../OpenWrtAction/config/${openwrt_dir_front}_config/${config_name}
        if [ -n "$(git status -s)" ]; then
            git add .
            git commit -m "add $config_name from local bash"
            git push origin
            Func_LogSuccess "已将新配置的config同步回OpenwrtAction" "The newly configured config has been synchronized back to OpenwrtAction"
            sleep 2s
        fi

        Func_LogMessage "是否根据新的config编译？" "Is it compiled according to the new config?"
        Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
        Func_LogMessage "1. 是(默认值)" "1.Yes(Default)"
        Func_LogMessage "2. 不编译了。退出" "2.NO, Exit"
        read -t $timer num_continue
        if [ ! -n "$num_continue" ]; then
            num_continue=1
        fi
        until [[ $num_continue -ge 1 && $num_continue -le 2 ]]; do
            Func_LogMessage "你输入的 ${num_continue} 是啥玩应啊，看好了序号，输入数值就行了。" "What's the answer for the ${num_continue} you entered? Just enter the number after you are optimistic about the serial number."
            Func_LogMessage "是否根据新的config编译？" "Is it compiled according to the new config?"
            Func_LogMessage "将会在$timer秒后自动选择默认值" "The default value will be automatically selected after $timer seconds"
            Func_LogMessage "1. 是(默认值)" "1. Yes(Default)"
            Func_LogMessage "2. 不编译了。退出  NO, Exit" "2.NO, Exit"
            read -t $timer num_continue
            if [ ! -n "$num_continue" ]; then
                num_continue=1
                Func_LogSuccess "使用默认值" "Use default"
            fi
        done

        if [[ $num_continue == 1 ]]; then
            Func_Copy_Backgroundfiles "1" "${config_name}"

            Func_Defconfig
            
            Func_MakeDownload

            Func_MakeToolchain

            Func_MakeFirmware
        else
            exit
        fi
    fi
}
