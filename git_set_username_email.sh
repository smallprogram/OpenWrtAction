#!/bin/bash

# 设置 Git config
git config --global user.name "David Mandy"
git config --global user.email "smallprogramzhusir@gmail.com"

# 创建模板文件（Git Bash 支持 $HOME）
cat > "$HOME/.git-commit-template.txt" << 'EOF'

# 请在上面写 commit 标题和详细描述

Signed-off-by: David Mandy <smallprogramzhusir@gmail.com>
EOF

# 设置模板（用 $HOME 路径）
git config --global commit.template "$HOME/.git-commit-template.txt"

echo "全局 Git 配置和 Signed-off-by 模板已设置！"