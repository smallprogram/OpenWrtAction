#!/bin/bash

is_wsl2op=$1
platform=$2

if [ ! -n "$is_wsl2op" ]; then
    source $GITHUB_WORKSPACE/compile_script/platforms.sh
else
    source /home/$USER/OpenWrtAction/compile_script/platforms.sh
fi

is_copy_backgroundfiles=false

for p in "${copy_backgroundfiles_platforms[@]}"; do
    if [[ "$p" == "$platform" ]]; then
        is_copy_backgroundfiles=true
        break
    fi
done

rm -rf ./package/custom_packages/luci-theme-argon/htdocs/luci-static/argon/background
mkdir -p ./package/custom_packages/luci-theme-argon/htdocs/luci-static/argon/background

if $is_copy_backgroundfiles; then
    echo "copy background files......................"
    if [ ! -n "$is_wsl2op" ]; then
        # Add default login background
        cp -a $GITHUB_WORKSPACE/source/video/* ./package/custom_packages/luci-theme-argon/htdocs/luci-static/argon/background/
        cp -a $GITHUB_WORKSPACE/source/img/* ./package/custom_packages/luci-theme-argon/htdocs/luci-static/argon/background/

        # Inject download package
        mkdir -p $GITHUB_WORKSPACE/openwrt/dl
        cp -a $GITHUB_WORKSPACE/library/* $GITHUB_WORKSPACE/openwrt/dl/

        # Fixed qmi_wwan_f complie error
        # cp -a $GITHUB_WORKSPACE/patches/qmi_wwan_f.c $GITHUB_WORKSPACE/openwrt/package/wwan/driver/fibocom_QMI_WWAN/src/qmi_wwan_f.c

    else
        # Add default login background
        cp -a /home/$USER/OpenWrtAction/source/video/* ./package/custom_packages/luci-theme-argon/htdocs/luci-static/argon/background/
        cp -a /home/$USER/OpenWrtAction/source/img/* ./package/custom_packages/luci-theme-argon/htdocs/luci-static/argon/background/

        # Inject download package
        mkdir -p dl
        cp -a /home/$USER/OpenWrtAction/library/* dl/

        # Fixed qmi_wwan_f complie error
        # cp -a ../OpenWrtAction/patches/qmi_wwan_f.c ./package/wwan/driver/fibocom_QMI_WWAN/src/qmi_wwan_f.c
    fi
else
    echo "Platform: $platform No need to copy background files"
fi
