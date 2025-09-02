#!/bin/bash

# VGO微服务版本发布脚本
# 用途：统一管理vgo-gateway、vgo-iam、vgo-kit的版本发布
# 作者：VGO团队
# 版本：1.0.0

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目配置
PROJECTS=("vgo-kit" "vgo-iam" "vgo-gateway")
REPO_BASE="https://github.com/vera-byte"
REGISTRY="ghcr.io/vera-byte"

# 函数：打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 函数：显示帮助信息
show_help() {
    cat << EOF
VGO微服务版本发布脚本

用法:
    $0 [选项] <命令> [参数]

命令:
    release <project> <version>     发布指定项目的版本
    release-all <version>           发布所有项目的版本
    check <project>                 检查项目状态
    check-all                       检查所有项目状态
    list                           列出所有项目
    help                           显示此帮助信息

项目:
    vgo-kit                        基础库项目
    vgo-iam                        身份认证服务
    vgo-gateway                    API网关服务
    all                            所有项目

选项:
    -h, --help                     显示帮助信息
    -v, --verbose                  详细输出
    -d, --dry-run                  模拟运行，不执行实际操作
    -f, --force                    强制执行，跳过确认
    -s, --skip-tests               跳过测试执行

示例:
    $0 release vgo-kit v1.0.0      发布vgo-kit v1.0.0版本
    $0 release-all v1.0.0          发布所有项目v1.0.0版本
    $0 release vgo-kit v1.0.0 -s   发布vgo-kit v1.0.0版本（跳过测试）
    $0 check vgo-iam               检查vgo-iam项目状态
    $0 check vgo-iam --skip-tests  检查vgo-iam项目状态（跳过测试）
    $0 check-all                   检查所有项目状态
    $0 list                        列出所有项目

EOF
}

# 函数：验证版本格式
validate_version() {
    local version=$1
    if [[ ! $version =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?$ ]]; then
        print_error "版本格式无效: $version"
        print_info "正确格式: v1.0.0 或 v1.0.0-beta"
        return 1
    fi
    return 0
}

# 函数：检查项目是否存在
validate_project() {
    local project=$1
    for p in "${PROJECTS[@]}"; do
        if [[ "$p" == "$project" ]]; then
            return 0
        fi
    done
    print_error "未知项目: $project"
    print_info "可用项目: ${PROJECTS[*]}"
    return 1
}

# 函数：检查Git状态
check_git_status() {
    local project=$1
    print_info "检查 $project 的Git状态..."
    
    # 如果强制模式，跳过Git检查
    if [[ "$FORCE" == "true" ]]; then
        print_warning "强制模式：跳过Git状态检查"
        return 0
    fi
    
    if [[ ! -d "$project" ]]; then
        print_error "项目目录不存在: $project"
        return 1
    fi
    
    cd "$project"
    
    # 检查是否有未提交的更改
    if [[ -n $(git status --porcelain) ]]; then
        print_warning "$project 有未提交的更改"
        git status --short
        cd ..
        return 1
    fi
    
    # 检查是否在main分支
    local current_branch=$(git branch --show-current)
    if [[ "$current_branch" != "main" ]]; then
        print_warning "$project 当前不在main分支 (当前: $current_branch)"
        cd ..
        return 1
    fi
    
    # 检查是否与远程同步
    git fetch origin
    local local_commit=$(git rev-parse HEAD)
    local remote_commit=$(git rev-parse origin/main)
    
    if [[ "$local_commit" != "$remote_commit" ]]; then
        print_warning "$project 与远程分支不同步"
        cd ..
        return 1
    fi
    
    cd ..
    print_success "$project Git状态检查通过"
    return 0
}

# 函数：检查项目状态
check_project() {
    local project=$1
    print_info "检查项目: $project"
    
    # 检查Git状态
    if ! check_git_status "$project"; then
        return 1
    fi
    
    # 检查Go模块
    cd "$project"
    if [[ -f "go.mod" ]]; then
        print_info "验证Go模块..."
        if ! go mod verify; then
            print_error "Go模块验证失败"
            cd ..
            return 1
        fi
        
        print_info "检查Go模块整理..."
        go mod tidy
        if [[ -n $(git status --porcelain go.mod go.sum) ]]; then
            print_warning "go.mod或go.sum需要更新"
            cd ..
            return 1
        fi
    fi
    
    # 运行测试（可选）
    if [[ -f "go.mod" && "$SKIP_TESTS" != "true" ]]; then
        print_info "运行测试..."
        if ! go test ./...; then
            print_error "测试失败"
            cd ..
            return 1
        fi
    elif [[ "$SKIP_TESTS" == "true" ]]; then
        print_warning "跳过测试执行"
    fi
    
    cd ..
    print_success "$project 状态检查通过"
    return 0
}

# 函数：创建Git标签
create_git_tag() {
    local project=$1
    local version=$2
    
    print_info "为 $project 创建标签 $version..."
    
    cd "$project"
    
    # 检查标签是否已存在
    if git tag -l | grep -q "^$version$"; then
        print_error "标签 $version 已存在"
        cd ..
        return 1
    fi
    
    # 创建标签
    git tag -a "$version" -m "Release $version"
    
    # 推送标签
    if [[ "$DRY_RUN" != "true" ]]; then
        git push origin "$version"
        print_success "标签 $version 已推送到远程仓库"
    else
        print_info "[DRY RUN] 将推送标签: $version"
    fi
    
    cd ..
    return 0
}

# 函数：发布单个项目
release_project() {
    local project=$1
    local version=$2
    
    print_info "开始发布 $project $version..."
    
    # 检查项目状态
    if ! check_project "$project"; then
        print_error "$project 状态检查失败，取消发布"
        return 1
    fi
    
    # 确认发布
    if [[ "$FORCE" != "true" ]]; then
        echo
        read -p "确认发布 $project $version? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "取消发布"
            return 1
        fi
    fi
    
    # 创建标签
    if ! create_git_tag "$project" "$version"; then
        return 1
    fi
    
    print_success "$project $version 发布完成！"
    print_info "GitHub Actions将自动构建和发布Docker镜像"
    print_info "查看发布状态: ${REPO_BASE}/${project}/actions"
    
    return 0
}

# 函数：发布所有项目
release_all_projects() {
    local version=$1
    local failed_projects=()
    
    print_info "开始发布所有项目 $version..."
    
    # 首先检查所有项目状态
    for project in "${PROJECTS[@]}"; do
        if ! check_project "$project"; then
            failed_projects+=("$project")
        fi
    done
    
    if [[ ${#failed_projects[@]} -gt 0 ]]; then
        print_error "以下项目状态检查失败: ${failed_projects[*]}"
        print_error "请修复问题后重试"
        return 1
    fi
    
    # 确认发布
    if [[ "$FORCE" != "true" ]]; then
        echo
        print_warning "即将发布以下项目的 $version 版本:"
        for project in "${PROJECTS[@]}"; do
            echo "  - $project"
        done
        echo
        read -p "确认继续? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "取消发布"
            return 1
        fi
    fi
    
    # 按顺序发布项目（vgo-kit优先）
    for project in "${PROJECTS[@]}"; do
        if ! release_project "$project" "$version"; then
            failed_projects+=("$project")
        fi
        echo
    done
    
    if [[ ${#failed_projects[@]} -gt 0 ]]; then
        print_error "以下项目发布失败: ${failed_projects[*]}"
        return 1
    fi
    
    print_success "所有项目 $version 发布完成！"
    return 0
}

# 函数：检查所有项目
check_all_projects() {
    local failed_projects=()
    
    print_info "检查所有项目状态..."
    
    for project in "${PROJECTS[@]}"; do
        echo
        if ! check_project "$project"; then
            failed_projects+=("$project")
        fi
    done
    
    echo
    if [[ ${#failed_projects[@]} -gt 0 ]]; then
        print_error "以下项目状态检查失败: ${failed_projects[*]}"
        return 1
    fi
    
    print_success "所有项目状态检查通过！"
    return 0
}

# 函数：列出所有项目
list_projects() {
    print_info "VGO微服务项目列表:"
    echo
    for project in "${PROJECTS[@]}"; do
        if [[ -d "$project" ]]; then
            cd "$project"
            local latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "无标签")
            local current_branch=$(git branch --show-current)
            cd ..
            printf "  %-15s 最新标签: %-10s 当前分支: %s\n" "$project" "$latest_tag" "$current_branch"
        else
            printf "  %-15s %s\n" "$project" "[目录不存在]"
        fi
    done
    echo
}

# 解析命令行参数
VERBOSE=false
DRY_RUN=false
FORCE=false
SKIP_TESTS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -s|--skip-tests)
            SKIP_TESTS=true
            shift
            ;;
        release)
            COMMAND="release"
            PROJECT="$2"
            VERSION="$3"
            shift 3
            ;;
        release-all)
            COMMAND="release-all"
            VERSION="$2"
            shift 2
            ;;
        check)
            COMMAND="check"
            PROJECT="$2"
            shift 2
            ;;
        check-all)
            COMMAND="check-all"
            shift
            ;;
        list)
            COMMAND="list"
            shift
            ;;
        help)
            show_help
            exit 0
            ;;
        *)
            print_error "未知参数: $1"
            show_help
            exit 1
            ;;
    esac
done

# 检查是否在项目根目录
if [[ ! -f "go.work" ]]; then
    print_error "请在项目根目录运行此脚本"
    exit 1
fi

# 执行命令
case "$COMMAND" in
    release)
        if [[ -z "$PROJECT" || -z "$VERSION" ]]; then
            print_error "缺少参数"
            print_info "用法: $0 release <project> <version>"
            exit 1
        fi
        
        if ! validate_project "$PROJECT"; then
            exit 1
        fi
        
        if ! validate_version "$VERSION"; then
            exit 1
        fi
        
        release_project "$PROJECT" "$VERSION"
        ;;
    release-all)
        if [[ -z "$VERSION" ]]; then
            print_error "缺少版本参数"
            print_info "用法: $0 release-all <version>"
            exit 1
        fi
        
        if ! validate_version "$VERSION"; then
            exit 1
        fi
        
        release_all_projects "$VERSION"
        ;;
    check)
        if [[ -z "$PROJECT" ]]; then
            print_error "缺少项目参数"
            print_info "用法: $0 check <project>"
            exit 1
        fi
        
        if ! validate_project "$PROJECT"; then
            exit 1
        fi
        
        check_project "$PROJECT"
        ;;
    check-all)
        check_all_projects
        ;;
    list)
        list_projects
        ;;
    "")
        print_error "缺少命令"
        show_help
        exit 1
        ;;
    *)
        print_error "未知命令: $COMMAND"
        show_help
        exit 1
        ;;
esac