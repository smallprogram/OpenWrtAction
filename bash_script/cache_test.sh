#!/bin/bash

touch ../base_compilation_marker
echo "==== 1. 编译系统工具 ===="
time make tools/compile -j$(nproc) || exit 1
echo "==== 2. 编译交叉工具链 ===="
time make toolchain/compile -j$(nproc) || exit 1
echo "==== 3. 编译 Linux 内核 ===="
time make target/compile -j$(nproc) || exit 1

echo "==== 4. 编译长期存在的包 ===="
LONG_TIME_TARGETS=(
    "package/feeds/packages/golang/host/compile"
    "package/feeds/packages/rust/host/compile"
    "package/feeds/packages/ruby/host/compile"
)
for target in "${LONG_TIME_TARGETS[@]}"; do
    time make $target -j$(nproc) || exit 1
done

CHANGED_BASE=$(find build_dir staging_dir -type f -newer ../base_compilation_marker -path "*/stamp/*" 2>/dev/null | \
                          grep -E -v "staging_dir/host/stamp/\.tools_compile_|staging_dir/target-[^/]+/stamp/\.target_prereq$" | \
                          wc -l)

echo "--- Found $CHANGED_BASE newer stamp files ---"

if [ "$CHANGED_BASE" -eq 0 ]; then
    echo "🎉 Base 阶段命中旧缓存，跳过本次 Checkpoint 存档！"
    exit 0
fi


echo "⚡ 检测到 $CHANGED_BASE 个新 stamp，触发缓存更新存档..."