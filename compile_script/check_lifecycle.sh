#!/bin/bash
# Description: 检查并更新 150 天周期的强制重构状态

# 1. 获取脚本所在的绝对路径，并指定同目录下的 md 文件
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE_NAME="$SCRIPT_DIR/force_rebuild_data.md"

# 2. 容错防御：如果文件不存在，初始化为今天
if [ ! -f "$FILE_NAME" ]; then
  echo "$(date +%Y-%m-%d)" > "$FILE_NAME"
  echo "文件不存在，已初始化为今天日期。"
fi

# 3. 读取目标日期并获取时间戳
TARGET_DATE=$(cat "$FILE_NAME" | tr -d '[:space:]')
TARGET_TIMESTAMP=$(date -d "$TARGET_DATE" +%s)

# 4. 获取当前时间戳
CURRENT_DATE=$(date +%Y-%m-%d)
CURRENT_TIMESTAMP=$(date -d "$CURRENT_DATE" +%s)

echo "----------------------------------------"
echo "当前日期: $CURRENT_DATE"
echo "计划重构日期: $TARGET_DATE"
echo "----------------------------------------"

# 5. 核心逻辑判断
if [ "$CURRENT_TIMESTAMP" -ge "$TARGET_TIMESTAMP" ]; then
  echo "🚨 时间已达到或超过规定期限，触发强制重构！"
  # 注意：在独立脚本中，GITHUB_OUTPUT 环境变量依然有效
  echo "force_rebuild=true" >> "$GITHUB_OUTPUT"

  # 计算 180 天后的新日期并覆写文件
  NEW_DATE=$(date -d "$CURRENT_DATE + 180 days" +%Y-%m-%d)
  echo "$NEW_DATE" > "$FILE_NAME"
  echo "已将下次重构日期更新为: $NEW_DATE"

  # 6. 提交到 Git 仓库
  git config user.name "github-actions[bot]"
  git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
  
  # 使用文件的绝对路径进行 add
  git add "$FILE_NAME"
  git commit -m "Chore: Forcing cache rebuild; the next rebuild date is: $NEW_DATE"
  git push
else
  echo "✅ 未到强制重构时间，继续使用常规增量缓存。"
  echo "force_rebuild=false" >> "$GITHUB_OUTPUT"
fi