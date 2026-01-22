#!/bin/bash

# 这里改成你的目标配置
NEW_NAME="David Mandy"
NEW_EMAIL="smallprogramzhusir@gmail.com"

git config --global user.name "$NEW_NAME"
git config --global user.email "$NEW_EMAIL"

echo "Git 配置已更新："
echo "Name:  $(git config --global user.name)"
echo "Email: $(git config --global user.email)"

git config --global --list