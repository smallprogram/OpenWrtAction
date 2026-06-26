#!/bin/bash
#
# Copyright (c) 2019-2025 SmallProgram <https://github.com/smallprogram>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/smallprogram/OpenWrtAction
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Add patches
if [ "$GITHUB_ACTIONS" = "true" ] && [ -n "$GITHUB_RUN_ID" ] && [ -n "$GITHUB_WORKFLOW" ]; then
    PATCHES_SRC_DIR="$GITHUB_WORKSPACE"
else
    PATCHES_SRC_DIR="../OpenWrtAction"
fi


#------------------------------------------------------移植包------------------------------------------------------------
# --- 拉取上游仓库 ---
rm -rf temp_resp
git clone -b master --single-branch https://github.com/openwrt/packages.git temp_resp/openwrt_packages
git clone -b master --single-branch https://github.com/immortalwrt/luci.git temp_resp/immortalwrt_luci
git clone -b master --single-branch https://github.com/immortalwrt/packages.git temp_resp/immortalwrt_packages


# =================================================================
# 定义极简版移植函数 (针对新增包,源仓库必须没有这个包,否则时间戳会被覆盖)
# =================================================================
port_package() {
    local src_repo="$1"
    local pkg_path="$2"
    local target_dir="$3"
    local pkg_name=$(basename "$pkg_path")
    local dest_path="$target_dir/$pkg_name"

    # 1. 安全检查：确保源目录确实存在
    if [ ! -d "$src_repo/$pkg_path" ]; then
        echo "❌ 错误: 源目录 $src_repo/$pkg_path 不存在，跳过！"
        return 1
    fi

    # 2. 删除目标目录（真实文件），避免旧版本废弃文件残留
    if [ -d "$dest_path" ]; then
        rm -rf "$dest_path"
    fi

    # 3. 动态清理 OpenWrt 软链接 (模拟 ./scripts/feeds uninstall)
    # 解析 target_dir 提取 feed 名称，例如从 feeds/packages/lang 提取出 packages
    local feed_name=$(echo "$target_dir" | cut -d'/' -f2)
    local symlink_path="package/feeds/$feed_name/$pkg_name"
    
    if [ -h "$symlink_path" ] || [ -d "$symlink_path" ]; then
        rm -rf "$symlink_path"
        echo "🗑️  已清理残留软链接: $symlink_path"
    fi

    # 4. 统一执行复制操作
    cp -a "$src_repo/$pkg_path" "$target_dir/"

    # 5. 提取上游真实时间并修改时间戳
    local commit_time=$(cd "$src_repo" && git log -1 --format=%cd --date=unix -- "$pkg_path" 2>/dev/null)
    
    if [ -n "$commit_time" ]; then
        find "$dest_path" -exec touch -m -d @"$commit_time" {} +
        echo "✅ 同步成功: $pkg_name (保留了原始时间戳)"
    else
        echo "⚠️ 警告: 无法提取 $pkg_path 的时间戳，已作为普通文件复制"
    fi
}

# 移植 插件与依赖
port_package "temp_resp/openwrt_packages" "lang/golang" "feeds/packages/lang"
port_package "temp_resp/openwrt_packages" "lang/rust" "feeds/packages/lang"

port_package "temp_resp/immortalwrt_luci" "applications/luci-app-diskman" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-eqos" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-homeproxy" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-netdata" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-ramfree" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-vlmcsd" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-wechatpush" "feeds/luci/applications"

port_package "temp_resp/immortalwrt_packages" "net/vlmcsd" "feeds/packages/net"

# 清理临时目录
rm -rf temp_resp
#--------------------------------------------------------------end 移植包--------------------------------------------------------


#-----------------------------------------------修改脚本------------------------------------------------------------
# Modify default IP
sed -i 's/192.168.1.1/10.10.0.253/g' package/base-files/files/bin/config_generate

# fixed rust host build download llvm in ci error
# sed -i 's/--set=llvm\.download-ci-llvm=true/--set=llvm.download-ci-llvm=false/' package/custom_overrides/rust/Makefile
# grep -q -- '--ci false \\' package/custom_overrides/rust/Makefile || sed -i '/x\.py \\/a \        --ci false \\' package/custom_overrides/rust/Makefile

# inject download package
mkdir -p dl
cp -r $PATCHES_SRC_DIR/library/* ./dl/

# --- Modify SSH Configuration (Dropbear -> 2222, OpenSSH -> 22) ---
# 1. 确保 files 目录存在 (在 OpenWrt 源码根目录下)
mkdir -p files/etc/uci-defaults

# 2. 生成首次启动脚本
cat << 'EOF' > files/etc/uci-defaults/99-custom-ssh-config
#!/bin/sh

# --- 1. 停止服务 ---
# 先停掉 Dropbear，确保它彻底释放 22 端口
# (在首次启动脚本中执行这步是安全的，不会导致用户掉线，因为此时还没人登录)
/etc/init.d/dropbear stop
/etc/init.d/sshd stop 2>/dev/null  # 加上这句以防万一 sshd 已经尝试自启

# --- 2. 配置 Dropbear (UCI) ---
# 将 Dropbear 端口移至 2222
uci set dropbear.@dropbear[0].Port='2222'
uci commit dropbear

# --- 3. 配置 OpenSSH (sshd_config) ---
SSHD_CONFIG="/etc/ssh/sshd_config"
if [ -f "$SSHD_CONFIG" ]; then
    # 允许 Root 登录
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' "$SSHD_CONFIG"
    # 显式指定端口 22
    sed -i 's/^#*Port.*/Port 22/' "$SSHD_CONFIG"
fi

# --- 4. 同步密钥 (可选) ---
# mkdir -p /root/.ssh
# if [ ! -L /root/.ssh/authorized_keys ]; then
#     [ -f /root/.ssh/authorized_keys ] && mv /root/.ssh/authorized_keys /root/.ssh/authorized_keys.bak
#     ln -s /etc/dropbear/authorized_keys /root/.ssh/authorized_keys
# fi

# --- 5. 按顺序启动服务 ---

# 第一步：启动 Dropbear
# 此时配置已生效，它会乖乖去占 2222，绝对不会碰 22
/etc/init.d/dropbear start

# 第二步：启动 OpenSSH
# 此时 22 端口绝对是空闲的，OpenSSH 可以顺利接管
/etc/init.d/sshd enable
/etc/init.d/sshd start

exit 0
EOF

# 3. 赋予脚本执行权限
chmod +x files/etc/uci-defaults/99-custom-ssh-config
# --- End Modify SSH Configuration ---

#------------------------------------------------end 修改脚本-------------------------------------------------------


echo "DIY2 is complate!"