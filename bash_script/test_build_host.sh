#!/bin/bash

# 获取所有需要host comile的目标
# make -nw package/compile | grep -E "host-(compile|install)"

build_toolchain=${1:-1}
# 定义你要编译的目标列表
All_TARGETS=(
    "tools/compile"
    "toolchain/compile"
    "target/compile"
    "package/utils/lua/host/compile"
    "package/system/apk/host/compile"
    "package/libs/ncurses/host/compile"
    "package/system/fwtool/host/compile"
    "package/libs/libjson-c/host/compile"
    "package/libs/libubox/host/compile"
    "package/system/usign/host/compile"
    "package/system/ucert/host/compile"
    "package/boot/grub2/host/compile"
    "package/feeds/luci/luci-base/host/compile"
    "package/feeds/packages/golang-bootstrap/host/compile"
    "package/feeds/packages/golang1.26/host/compile"
    "package/feeds/packages/golang/host/compile"
    "package/feeds/packages/libffi/host/compile"
    "package/utils/bzip2/host/compile"
    "package/feeds/packages/python3/host/compile"
    "package/feeds/packages/python-flit-core/host/compile"
    "package/feeds/packages/python-installer/host/compile"
    "package/feeds/packages/python-packaging/host/compile"
    "package/feeds/packages/python-pyproject-hooks/host/compile"
    "package/feeds/packages/python-build/host/compile"
    "package/feeds/packages/python-wheel/host/compile"
    "package/feeds/packages/yaml/host/compile"
    "package/feeds/packages/ruby/host/compile"
    "package/feeds/packages/rust/host/compile"
    "package/feeds/packages/python-setuptools/host/compile"
    "package/feeds/packages/boost/host/compile"
    "package/devel/gperf/host/compile"
    "package/libs/gnulib-l10n/host/compile"
    "package/libs/libiconv-full/host/compile"
    "package/libs/libunistring/host/compile"
    "package/libs/libxml2/host/compile"
    "package/libs/gettext-full/host/compile"
    "package/feeds/packages/protobuf/host/compile"
    "package/feeds/packages/node/host/compile"
    "package/feeds/packages/rust-bindgen/host/compile"
    "package/libs/pcre2/host/compile"
    "package/feeds/packages/glib2/host/compile"
    "package/feeds/packages/rpcsvc-proto/host/compile"
)

TOOLCHAIN_TARGETS=(
    "tools/compile"
    "toolchain/compile"
    "target/compile"
)

LONG_TIME_TARGETS=(
    "package/feeds/packages/golang/host/compile"
    "package/feeds/packages/rust/host/compile"
    "package/feeds/packages/ruby/host/compile"
    "package/feeds/packages/boost/host/compile"
    "package/libs/libunistring/host/compile"
    "package/libs/gettext-full/host/compile"
)

TARGETS=()

# 初始化/清空 time.md
echo "# OpenWrt Build Time Report" > time.md
echo "生成时间: $(date)" >> time.md
echo "" >> time.md

case "$build_toolchain" in
    1)
        # 对应原来的 if [ $build_toolchain -eq 1 ]
        echo "当前模式: 1 (编译 Toolchain)"
        TARGETS=("${TOOLCHAIN_TARGETS[@]}")
        ;;
    2)
        # 这里预留了选项 2 的逻辑
        echo "当前模式: 2 (编译 耗时包)"
        TARGETS=("${LONG_TIME_TARGETS[@]}")
        ;;
    3)
        # 这里预留了选项 3 的逻辑
        echo "当前模式: 3 (编译 Toolchain + 耗时包)"
        TARGETS=("${TOOLCHAIN_TARGETS[@]}" "${LONG_TIME_TARGETS[@]}")
        ;;
    4)
        # 对应原来的 else (当输入不是 1, 2, 3，或者是空值时的默认行为)
        echo "编译所有host包"
        TARGETS=("${All_TARGETS[@]}")
        ;;
    *) 
        exit 0
        ;;
esac

for target in "${TARGETS[@]}"; do
    echo "正在编译: $target ..."
    
    # 将 target 名称写入文件
    echo "### $target" >> time.md
    
    # 核心逻辑：
    # 1. { time ... } 2>&1 捕获 time 的 stderr 并转为 stdout
    # 2. grep 提取包含 real/user/sys 的行
    # 3. >> 追加到 time.md
    { time make -j$(nproc) "$target" ; } 2>&1 | grep -E "real|user|sys" >> time.md
    
    echo "---" >> time.md
    echo "" >> time.md
done

echo "✅ 统计完成！请查看 time.md"
cat time.md