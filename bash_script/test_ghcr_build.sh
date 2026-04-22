#!/bin/bash
set -e

echo "=== 1. 准备配置 ==="
make defconfig


echo "=== 2. 还原 Git 源码真实历史时间戳 ==="
current_path=$(pwd)
find . -name ".git" -type d | while read gitdir; do
        repo_dir=$(dirname "$gitdir")
        echo "-> 正在处理 Git 仓库: $repo_dir"
        cd "$current_path/$repo_dir"
        git log --format=%at --name-only | perl -ane '
        if (/^(\d+)$/) { $t = $1; }
        elsif (/^(\S+)$/) {
            $f = $1;
            if (-e $f && !-d $f && !$seen{$f}) {
            utime($t, $t, $f);
            $seen{$f} = 1;
            }
        }
        '
        cd "$current_path"
    done

echo "=== 3. 清理旧数据并拉取最新缓存 ==="
rm -rf build_dir staging_dir
docker rm -f temp_bin 2>/dev/null || true

docker pull ghcr.io/smallprogram/openwrt-base-cache-immortalwrt-x86:latest
docker create --name temp_bin ghcr.io/smallprogram/openwrt-base-cache-immortalwrt-x86:latest /bin/true
docker export temp_bin > cache_exported.tar

echo "=== 4. 解压并合并缓存分块 ==="
mkdir -p immcache
tar -xf cache_exported.tar -C immcache --wildcards "op_cache_raw_*" || true

if ls immcache/op_cache_raw_* 1> /dev/null 2>&1; then
   echo "==== 按顺序合并分块并释放到当前目录 ===="
   cat immcache/op_cache_raw_* | tar -I "zstd -T0" -xf -
   rm -f cache_exported.tar
   rm -rf immcache
   echo "✅ 缓存合并恢复完成！"
else
   echo "⚠️ 未找到有效缓存分块！"
   rm -rf immcache
   exit 1
fi

echo "=== 5. 解决配置文件的幽灵时间戳悖论 ===="
# 这是最核心的一步：让配置文件回到过去，假装它们是没有被修改过的旧配置
BUILD_TIME=$(stat -c %Y build_dir)
TARGET_TIME=$((BUILD_TIME - 60))
find tmp/ -exec touch -c -h -d "@$TARGET_TIME" {} + 2>/dev/null || true
touch -c -h -d "@$TARGET_TIME" tmp/
if [ -f ".config" ]; then
    touch -c -h -d "@$TARGET_TIME" .config
fi

echo "=== 6. 开始智能编译 ===="
# 加上 V=s 可以更清晰地看到它是瞬间跳过了编译步骤
time make tools/compile -j$(nproc)
time make toolchain/compile -j$(nproc)
time make target/compile -j$(nproc)