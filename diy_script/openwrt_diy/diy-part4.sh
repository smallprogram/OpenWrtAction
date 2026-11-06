
#!/bin/bash

# ================================================================
# diy-part4.sh
#
# RustDesk Server 自动集成脚本
# 执行时机：OpenWrt make 编译之前
#
# 功能：
# 1. 自动识别 OpenWrt 核心架构
# 2. GitHub Token API 认证
# 3. GitHub API 自动重试
# 4. 下载失败自动重试
# 5. ZIP 文件完整性检查
# 6. 自动查找 hbbs / hbbr
# 7. 自动复制到 files/usr/bin
# 8. 所有集成错误均不影响 OpenWrt 编译
#
# GitHub Actions 环境变量：
# GITHUB_TOKEN: GitHub Actions 自带 Token
# ================================================================


install_rustdesk_server() {

    echo ""
    echo "============================================================"
    echo "       开始集成最新版 RustDesk Server"
    echo "============================================================"

    # ------------------------------------------------------------
    # 1. 基础配置
    # ------------------------------------------------------------

    local FILES_DIR="./files"
    local BIN_DIR="${FILES_DIR}/usr/bin"
    local TMP_DIR="/tmp/rustdesk_install_${BASHPID:-$$}"

    local API_URL="https://api.github.com/repos/rustdesk/rustdesk-server/releases/latest"

    local OPENWRT_ARCH=""
    local ARCH_KEYWORD=""
    local API_FILE="${TMP_DIR}/release.json"
    local ZIP_FILE="${TMP_DIR}/rustdesk-server.zip"

    local TARGET_URL=""
    local HBBS_PATH=""
    local HBBR_PATH=""

    local ATTEMPT
    local HTTP_CODE
    local API_OK=0
    local DOWNLOAD_OK=0

    # ------------------------------------------------------------
    # 2. 统一失败处理
    # ------------------------------------------------------------

    _rustdesk_skip() {

        echo ""
        echo "[RustDesk] 警告：$1"
        echo "[RustDesk] 跳过 RustDesk Server 集成。"
        echo "[RustDesk] 不影响 OpenWrt 后续编译。"

        rm -rf "${TMP_DIR}" 2>/dev/null || true

        echo "============================================================"
        echo ""

        return 0
    }

    # ------------------------------------------------------------
    # 3. 检查 .config
    # ------------------------------------------------------------

    if [ ! -f "./.config" ]; then
        _rustdesk_skip "未找到 OpenWrt .config 文件。"
        return 0
    fi

    OPENWRT_ARCH=$(sed -n 's/^CONFIG_ARCH="\([^"]*\)"/\1/p' ./.config | head -n 1) || OPENWRT_ARCH=""

    if [ -z "${OPENWRT_ARCH}" ]; then
        _rustdesk_skip "无法读取 CONFIG_ARCH。"
        return 0
    fi

    echo "[RustDesk] OpenWrt 核心架构：${OPENWRT_ARCH}"

    # ------------------------------------------------------------
    # 4. 架构映射
    # ------------------------------------------------------------

    case "${OPENWRT_ARCH}" in

        x86_64)
            ARCH_KEYWORD="linux-amd64.zip"
            ;;

        aarch64)
            ARCH_KEYWORD="linux-arm64v8.zip"
            ;;

        arm)
            ARCH_KEYWORD="linux-armv7.zip"
            ;;

        i386)
            ARCH_KEYWORD="linux-i386.zip"
            ;;

        *)
            _rustdesk_skip "官方暂不支持当前架构：${OPENWRT_ARCH}"
            return 0
            ;;

    esac

    echo "[RustDesk] 目标文件：${ARCH_KEYWORD}"

    # ------------------------------------------------------------
    # 5. 检查必要工具
    # ------------------------------------------------------------

    local TOOL

    for TOOL in curl python3 unzip find; do

        if ! command -v "${TOOL}" >/dev/null 2>&1; then
            _rustdesk_skip "缺少必要工具：${TOOL}"
            return 0
        fi

    done

    # ------------------------------------------------------------
    # 6. 创建临时目录
    # ------------------------------------------------------------

    if ! mkdir -p "${TMP_DIR}" "${BIN_DIR}"; then
        _rustdesk_skip "无法创建临时目录或目标目录。"
        return 0
    fi

    # ------------------------------------------------------------
    # 7. GitHub Token 认证配置
    # ------------------------------------------------------------

    local CURL_AUTH=()

    if [ -n "${GITHUB_TOKEN:-}" ]; then

        CURL_AUTH=(
            -H "Authorization: Bearer ${GITHUB_TOKEN}"
        )

        echo "[RustDesk] 已启用 GitHub Token API 认证。"

    else

        echo "[RustDesk] 警告：未检测到 GITHUB_TOKEN，将使用匿名 API 请求。"

    fi

    # ------------------------------------------------------------
    # 8. 获取 GitHub 最新 Release
    # ------------------------------------------------------------

    echo "[RustDesk] 正在查询 GitHub 最新 Release..."

    for ATTEMPT in $(seq 1 8); do

        echo "[RustDesk] API 请求：第 ${ATTEMPT}/8 次"

        HTTP_CODE=$(curl \
            --silent \
            --show-error \
            --location \
            --connect-timeout 20 \
            --max-time 90 \
            --retry 2 \
            --retry-all-errors \
            --retry-delay 3 \
            --output "${API_FILE}" \
            --write-out '%{http_code}' \
            -H "Accept: application/vnd.github+json" \
            -H "User-Agent: OpenWrt-RustDesk-Installer" \
            "${CURL_AUTH[@]}" \
            "${API_URL}" 2>/dev/null) || HTTP_CODE="000"

        if [ "${HTTP_CODE}" = "200" ] && [ -s "${API_FILE}" ]; then

            API_OK=1
            break

        fi

        echo "[RustDesk] API 请求失败，HTTP：${HTTP_CODE:-unknown}"

        if [ "${ATTEMPT}" -lt 8 ]; then
            sleep $((ATTEMPT * 3))
        fi

    done

    if [ "${API_OK}" -ne 1 ]; then
        _rustdesk_skip "GitHub API 连续请求失败。"
        return 0
    fi

    echo "[RustDesk] GitHub Release 信息获取成功。"

    # ------------------------------------------------------------
    # 9. 解析 JSON 并匹配架构
    # ------------------------------------------------------------

    TARGET_URL=$(python3 -c '
import json
import sys

try:
    with open(sys.argv[1], "r", encoding="utf-8") as f:
        data = json.load(f)

    if "message" in data:
        print("GitHub API: " + str(data["message"]), file=sys.stderr)

    suffix = sys.argv[2]

    for asset in data.get("assets", []):
        name = asset.get("name", "")
        url = asset.get("browser_download_url", "")

        if name.endswith(suffix) and url:
            print(url)
            sys.exit(0)

    sys.exit(1)

except Exception as e:
    print("JSON parsing error: " + str(e), file=sys.stderr)
    sys.exit(1)
' "${API_FILE}" "${ARCH_KEYWORD}" 2>/dev/null) || TARGET_URL=""

    if [ -z "${TARGET_URL}" ]; then

        echo "[RustDesk] 未找到匹配的下载文件。"

        echo "[RustDesk] 当前 Release 资产列表："

        python3 -c '
import json, sys

try:
    with open(sys.argv[1], encoding="utf-8") as f:
        data = json.load(f)

    for asset in data.get("assets", []):
        print("  - " + asset.get("name", "unknown"))

    if "message" in data:
        print("  API: " + data["message"])

except Exception:
    print("  无法解析 Release JSON")
' "${API_FILE}" 2>/dev/null || true

        _rustdesk_skip "没有找到架构 ${ARCH_KEYWORD} 对应的下载文件。"
        return 0

    fi

    echo "[RustDesk] 匹配到下载地址："
    echo "${TARGET_URL}"

    # ------------------------------------------------------------
    # 10. 下载 RustDesk Server
    # ------------------------------------------------------------

    echo "[RustDesk] 开始下载 RustDesk Server..."

    for ATTEMPT in $(seq 1 8); do

        echo "[RustDesk] 下载尝试：第 ${ATTEMPT}/8 次"

        rm -f "${ZIP_FILE}"

        if curl \
            --fail \
            --silent \
            --show-error \
            --location \
            --connect-timeout 30 \
            --max-time 600 \
            --retry 3 \
            --retry-all-errors \
            --retry-delay 3 \
            --output "${ZIP_FILE}" \
            "${TARGET_URL}"; then

            if [ -s "${ZIP_FILE}" ]; then
                DOWNLOAD_OK=1
                break
            fi

        fi

        echo "[RustDesk] 下载失败，准备重试。"

        if [ "${ATTEMPT}" -lt 8 ]; then
            sleep $((ATTEMPT * 3))
        fi

    done

    if [ "${DOWNLOAD_OK}" -ne 1 ]; then
        _rustdesk_skip "RustDesk Server 下载连续失败。"
        return 0
    fi

    echo "[RustDesk] 下载完成。"

    # ------------------------------------------------------------
    # 11. ZIP 完整性检查
    # ------------------------------------------------------------

    echo "[RustDesk] 正在检查 ZIP 文件..."

    if ! unzip -tq "${ZIP_FILE}" >/dev/null 2>&1; then
        _rustdesk_skip "ZIP 文件完整性校验失败。"
        return 0
    fi

    echo "[RustDesk] ZIP 文件校验通过。"

    # ------------------------------------------------------------
    # 12. 解压
    # ------------------------------------------------------------

    echo "[RustDesk] 正在解压..."

    if ! unzip -q "${ZIP_FILE}" -d "${TMP_DIR}/extract"; then
        _rustdesk_skip "RustDesk Server 解压失败。"
        return 0
    fi

    # ------------------------------------------------------------
    # 13. 查找 hbbs 和 hbbr
    # ------------------------------------------------------------

    HBBS_PATH=$(find "${TMP_DIR}/extract" -type f -name "hbbs" -print -quit 2>/dev/null) || HBBS_PATH=""

    HBBR_PATH=$(find "${TMP_DIR}/extract" -type f -name "hbbr" -print -quit 2>/dev/null) || HBBR_PATH=""

    if [ -z "${HBBS_PATH}" ] || [ -z "${HBBR_PATH}" ]; then

        echo "[RustDesk] 解压目录结构："

        ls -laR "${TMP_DIR}/extract" 2>/dev/null || true

        _rustdesk_skip "未能找到 hbbs 或 hbbr 文件。"
        return 0

    fi

    echo "[RustDesk] 找到服务端程序："
    echo "  hbbs: ${HBBS_PATH}"
    echo "  hbbr: ${HBBR_PATH}"

    # ------------------------------------------------------------
    # 14. 安装文件
    # ------------------------------------------------------------

    echo "[RustDesk] 正在安装文件..."

    if ! cp -f "${HBBS_PATH}" "${BIN_DIR}/hbbs"; then
        _rustdesk_skip "复制 hbbs 失败。"
        return 0
    fi

    if ! cp -f "${HBBR_PATH}" "${BIN_DIR}/hbbr"; then
        _rustdesk_skip "复制 hbbr 失败。"
        return 0
    fi

    if ! chmod 0755 "${BIN_DIR}/hbbs" "${BIN_DIR}/hbbr"; then
        _rustdesk_skip "设置文件执行权限失败。"
        return 0
    fi

    # ------------------------------------------------------------
    # 15. 清理临时目录
    # ------------------------------------------------------------

    rm -rf "${TMP_DIR}" 2>/dev/null || true

    # ------------------------------------------------------------
    # 16. 集成成功
    # ------------------------------------------------------------

    echo ""
    echo "============================================================"
    echo "       RustDesk Server 集成成功！"
    echo "============================================================"

    echo "[RustDesk] 架构：${OPENWRT_ARCH}"
    echo "[RustDesk] 安装目录：${BIN_DIR}"

    ls -lh "${BIN_DIR}/hbbs" "${BIN_DIR}/hbbr" 2>/dev/null || true

    echo "============================================================"
    echo ""

    return 0
}
