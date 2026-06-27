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

# =================================================================
# 极速拉取并注入 Feeds 树的函数
# =================================================================
inject_feed() {
    local repo_url="$1"
    local feed_dir="$2"
    shift 2
    local paths=("$@")

    echo "🚀 正在从 $repo_url 极速拉取至 $feed_dir ..."
    
    # 使用稀疏检出极速下载（不会拉取无关代码）
    git clone --filter=blob:none --sparse --depth=1 "$repo_url" temp_repo > /dev/null 2>&1
    cd temp_repo
    git sparse-checkout set "${paths[@]}" > /dev/null 2>&1
    
    # 提取上游最新的 Commit 时间戳 (作为兜底时间)
    local fallback_time=$(git log -1 --format=%cd --date=unix 2>/dev/null)
    cd ..

    for p in "${paths[@]}"; do
        if [ -d "temp_repo/$p" ]; then
            local pkg_name=$(basename "$p")
            local dest_path="$feed_dir/$pkg_name"
            
            # 1. 动态清理 OpenWrt 软链接 (防止文件类型冲突)
            local feed_name=$(echo "$feed_dir" | cut -d'/' -f2)
            local symlink_path="package/feeds/$feed_name/$pkg_name"
            if [ -h "$symlink_path" ] || [ -d "$symlink_path" ]; then
                rm -rf "$symlink_path"
            fi

            # 2. 清理并覆盖目标目录
            rm -rf "$dest_path"
            cp -r "temp_repo/$p" "$dest_path"

            # 3. 尝试提取文件真实时间戳，如果失败则使用整个库的 commit 时间
            local file_time=$(cd temp_repo && git log -1 --format=%cd --date=unix -- "$p" 2>/dev/null)
            if [ -z "$file_time" ]; then
                file_time=$fallback_time
            fi
            
            # 修改时间戳，欺骗 OpenWrt 编译缓存
            find "$dest_path" -exec touch -m -d @"$file_time" {} +
            
            echo "✅ 已成功注入并伪装时间戳: $pkg_name"
        fi
    done

    rm -rf temp_repo
}

# =================================================================
# 执行注入任务 (注意这里的目标目录直接是 feeds 对应的实际目录)
# =================================================================

# 1. 注入基础依赖包
inject_feed "https://github.com/openwrt/packages.git" "feeds/packages/lang" \
    "lang/golang" "lang/rust"

inject_feed "https://github.com/immortalwrt/packages.git" "feeds/packages/net" \
    "net/vlmcsd"

# 2. 注入 LuCI 界面
inject_feed "https://github.com/immortalwrt/luci.git" "feeds/luci/applications" \
    "applications/luci-app-homeproxy" \
    "applications/luci-app-diskman" \
    "applications/luci-app-eqos" \
    "applications/luci-app-netdata" \
    "applications/luci-app-ramfree" \
    "applications/luci-app-vlmcsd" \
    "applications/luci-app-wechatpush"

echo "🎉 所有插件注入完毕，保持了原汁原味的 Makefile 相对路径！"
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
