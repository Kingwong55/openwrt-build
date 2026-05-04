#!/bin/bash
# ============================================
# 一键编译 ImmortalWrt 旁路由固件
# 用法: ./scripts/build.sh
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }
log_step()  { echo -e "${BLUE}[STEP]${NC}  $*"; }

# 检查 Docker
check_docker() {
    log_step "检查 Docker 环境..."
    if ! command -v docker &>/dev/null; then
        log_error "Docker 未安装，请先安装 Docker Desktop"
        exit 1
    fi

    if ! docker info &>/dev/null; then
        log_error "Docker 未运行，请先启动 Docker Desktop"
        exit 1
    fi

    log_info "Docker 环境正常 ✅"
}

# 创建输出目录
prepare() {
    log_step "准备编译环境..."
    mkdir -p "$PROJECT_DIR/output"
    mkdir -p "$PROJECT_DIR/files/etc/uci-defaults"
    log_info "输出目录已就绪 ✅"
}

# 构建 Docker 镜像
build_image() {
    log_step "构建 Docker 编译镜像（首次需要较长时间）..."
    cd "$PROJECT_DIR"
    docker compose build --progress=plain
    log_info "Docker 镜像构建完成 ✅"
}

# 执行编译
compile() {
    log_step "开始编译固件..."
    echo ""
    log_info "📦 基础固件: ImmortalWrt 24.10"
    log_info "🎯 目标架构: x86/64 (EFI)"
    log_info "🧩 预装插件: OpenClash, AdGuard Home, Argon, ttyd"
    echo ""
    log_warn "首次编译预计需要 1-3 小时，请耐心等待..."
    echo ""

    cd "$PROJECT_DIR"
    docker compose run --rm builder

    log_info "编译完成 ✅"
}

# 检查输出
check_output() {
    log_step "检查编译产物..."
    echo ""

    if ls "$PROJECT_DIR/output/"*combined-efi* &>/dev/null; then
        log_info "🎉 固件编译成功！"
        echo ""
        echo "固件文件:"
        ls -lh "$PROJECT_DIR/output/"*combined-efi* 2>/dev/null
        echo ""
        log_info "刷入方式:"
        echo "  1. LuCI 网页升级: http://10.10.10.2 → 系统 → 备份/升级"
        echo "  2. 命令行: scp output/*.img.gz root@10.10.10.2:/tmp/"
        echo "            ssh root@10.10.10.2 'sysupgrade -v /tmp/*.img.gz'"
    else
        log_warn "未找到固件文件，请检查编译日志"
        echo "查看详细日志: docker compose logs builder"
    fi
}

# 主流程
main() {
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║   🛡️  ImmortalWrt 旁路由固件编译器    ║"
    echo "║   Target: x86/64 EFI                 ║"
    echo "╚══════════════════════════════════════╝"
    echo ""

    check_docker
    prepare
    build_image
    compile
    check_output

    echo ""
    log_info "全部完成！🎉"
}

main "$@"
