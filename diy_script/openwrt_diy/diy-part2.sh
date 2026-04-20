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

# =========================================================
# Golang/Rust 原生覆盖 (放入 package)
# =========================================================
rm -rf package/custom_overrides
mkdir -p package/custom_overrides
cp -a temp_resp/openwrt_packages/lang/golang package/custom_overrides/
cp -a temp_resp/openwrt_packages/lang/rust package/custom_overrides/

GOLANG_TIME=$(cd temp_resp/openwrt_packages && git log -1 --format=%cd --date=unix -- lang/golang)
RUST_TIME=$(cd temp_resp/openwrt_packages && git log -1 --format=%cd --date=unix -- lang/rust)
find package/custom_overrides/golang -exec touch -m -d @"$GOLANG_TIME" {} +
find package/custom_overrides/rust -exec touch -m -d @"$RUST_TIME" {} +


# =================================================================
# 定义极简版移植函数 (针对新增包,源仓库必须没有这个包,否则时间戳会被覆盖)
# =================================================================
port_package() {
    local src_repo="$1"
    local pkg_path="$2"
    local target_dir="$3"
    local pkg_name=$(basename "$pkg_path")
    
    # 提取上游真实时间并复制
    local commit_time=$(cd "$src_repo" && git log -1 --format=%cd --date=unix -- "$pkg_path")
    cp -a "$src_repo/$pkg_path" "$target_dir/"
    
    # 强制注入上游真实时间戳 (因为是新文件，SSoT 脚本不会碰它，这里设定的时间就是绝对权威)
    find "$target_dir/$pkg_name" -exec touch -m -d @"$commit_time" {} +
}

# 移植 ImmortalWrt LuCI 插件与依赖
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-cifs-mount" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-ddns-go" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-diskman" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-eqos" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-homeproxy" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-netdata" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-ramfree" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-vlmcsd" "feeds/luci/applications"
port_package "temp_resp/immortalwrt_luci" "applications/luci-app-wechatpush" "feeds/luci/applications"

port_package "temp_resp/immortalwrt_packages" "net/ddns-go" "feeds/packages/net"
port_package "temp_resp/immortalwrt_packages" "net/vlmcsd" "feeds/packages/net"

rm -rf temp_resp
#--------------------------------------------------------------end 移植包--------------------------------------------------------


#-----------------------------------------------修改脚本------------------------------------------------------------
# Modify default IP
sed -i 's/192.168.1.1/10.10.0.253/g' package/base-files/files/bin/config_generate

# fixed rust host build download llvm in ci error
sed -i 's/--set=llvm\.download-ci-llvm=true/--set=llvm.download-ci-llvm=false/' package/custom_overrides/rust/Makefile
grep -q -- '--ci false \\' package/custom_overrides/rust/Makefile || sed -i '/x\.py \\/a \        --ci false \\' package/custom_overrides/rust/Makefile

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

./scripts/feeds update -a
./scripts/feeds install -a

echo "DIY2 is complate!"