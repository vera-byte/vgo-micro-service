#!/bin/bash

# VGO微服务部署脚本
# 使用方法: ./deploy.sh [docker-compose|k8s] [start|stop|restart|status]

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查依赖
check_dependencies() {
    local platform=$1
    
    if [ "$platform" = "docker-compose" ]; then
        if ! command -v docker &> /dev/null; then
            log_error "Docker is not installed"
            exit 1
        fi
        
        if ! command -v docker-compose &> /dev/null; then
            log_error "Docker Compose is not installed"
            exit 1
        fi
    elif [ "$platform" = "k8s" ]; then
        if ! command -v kubectl &> /dev/null; then
            log_error "kubectl is not installed"
            exit 1
        fi
        
        # 检查kubectl连接
        if ! kubectl cluster-info &> /dev/null; then
            log_error "Cannot connect to Kubernetes cluster"
            exit 1
        fi
    fi
}

# Docker Compose 部署函数
docker_compose_start() {
    log_info "Starting VGO microservices with Docker Compose..."
    
    # 构建镜像
    log_info "Building Docker images..."
    docker-compose build
    
    # 启动服务
    log_info "Starting services..."
    docker-compose up -d
    
    # 等待服务启动
    log_info "Waiting for services to be ready..."
    sleep 30
    
    # 检查服务状态
    docker_compose_status
}

docker_compose_stop() {
    log_info "Stopping VGO microservices..."
    docker-compose down
    log_success "Services stopped"
}

docker_compose_restart() {
    log_info "Restarting VGO microservices..."
    docker-compose restart
    sleep 10
    docker_compose_status
}

docker_compose_status() {
    log_info "Checking service status..."
    docker-compose ps
    
    # 检查健康状态
    log_info "Health check results:"
    
    # 检查PostgreSQL
    if docker-compose exec -T postgres pg_isready -U vgo_user -d vgo_iam &> /dev/null; then
        log_success "PostgreSQL is healthy"
    else
        log_error "PostgreSQL is not healthy"
    fi
    
    # 检查Redis
    if docker-compose exec -T redis redis-cli -a vgo_redis_password ping &> /dev/null; then
        log_success "Redis is healthy"
    else
        log_error "Redis is not healthy"
    fi
    
    # 检查VGO-IAM
    if curl -f http://localhost:8080/health &> /dev/null; then
        log_success "VGO-IAM is healthy"
    else
        log_warning "VGO-IAM health check failed"
    fi
    
    # 显示访问地址
    echo ""
    log_info "Service URLs:"
    echo "  VGO-IAM HTTP: http://localhost:8080"
    echo "  VGO-IAM gRPC: localhost:9090"
    echo "  VGO-NOTIFY HTTP: http://localhost:8082"
    echo "  VGO-NOTIFY gRPC: localhost:9092"
    echo "  Prometheus: http://localhost:9090"
    echo "  Grafana: http://localhost:3000 (admin/admin123)"
    echo "  Jaeger: http://localhost:16686"
}

# Kubernetes 部署函数
k8s_start() {
    log_info "Deploying VGO microservices to Kubernetes..."
    
    # 创建命名空间
    log_info "Creating namespaces..."
    kubectl apply -f k8s/namespace.yaml
    
    # 部署数据库和缓存
    log_info "Deploying PostgreSQL..."
    kubectl apply -f k8s/postgres.yaml
    
    log_info "Deploying Redis..."
    kubectl apply -f k8s/redis.yaml
    
    # 等待数据库就绪
    log_info "Waiting for database to be ready..."
    kubectl wait --for=condition=ready pod -l app=postgres -n vgo-microservices --timeout=300s
    kubectl wait --for=condition=ready pod -l app=redis -n vgo-microservices --timeout=300s
    
    # 部署微服务
    log_info "Deploying VGO-IAM..."
    kubectl apply -f k8s/vgo-iam.yaml
    
    log_info "Deploying VGO-NOTIFY..."
    kubectl apply -f k8s/vgo-notify.yaml
    
    # 部署监控栈
    log_info "Deploying monitoring stack..."
    kubectl apply -f k8s/monitoring/prometheus.yaml
    kubectl apply -f k8s/monitoring/grafana.yaml
    kubectl apply -f k8s/monitoring/jaeger.yaml
    kubectl apply -f k8s/monitoring/node-exporter.yaml
    
    # 部署Ingress
    log_info "Deploying Ingress..."
    kubectl apply -f k8s/ingress.yaml
    
    # 等待服务就绪
    log_info "Waiting for services to be ready..."
    kubectl wait --for=condition=ready pod -l app=vgo-iam -n vgo-microservices --timeout=300s
    kubectl wait --for=condition=ready pod -l app=prometheus -n vgo-monitoring --timeout=300s
    
    k8s_status
}

k8s_stop() {
    log_info "Stopping VGO microservices in Kubernetes..."
    
    # 删除Ingress
    kubectl delete -f k8s/ingress.yaml --ignore-not-found=true
    
    # 删除监控栈
    kubectl delete -f k8s/monitoring/ --ignore-not-found=true
    
    # 删除微服务
    kubectl delete -f k8s/vgo-iam.yaml --ignore-not-found=true
    kubectl delete -f k8s/vgo-notify.yaml --ignore-not-found=true
    
    # 删除数据库和缓存
    kubectl delete -f k8s/redis.yaml --ignore-not-found=true
    kubectl delete -f k8s/postgres.yaml --ignore-not-found=true
    
    # 删除命名空间
    kubectl delete -f k8s/namespace.yaml --ignore-not-found=true
    
    log_success "Services stopped"
}

k8s_restart() {
    log_info "Restarting VGO microservices in Kubernetes..."
    
    # 重启微服务
    kubectl rollout restart deployment/vgo-iam -n vgo-microservices
    kubectl rollout restart deployment/vgo-notify -n vgo-microservices
    
    # 等待重启完成
    kubectl rollout status deployment/vgo-iam -n vgo-microservices
    kubectl rollout status deployment/vgo-notify -n vgo-microservices
    
    k8s_status
}

k8s_status() {
    log_info "Checking Kubernetes deployment status..."
    
    echo ""
    log_info "Namespaces:"
    kubectl get namespaces | grep vgo
    
    echo ""
    log_info "Microservices (vgo-microservices namespace):"
    kubectl get pods,svc -n vgo-microservices
    
    echo ""
    log_info "Monitoring (vgo-monitoring namespace):"
    kubectl get pods,svc -n vgo-monitoring
    
    echo ""
    log_info "Ingress:"
    kubectl get ingress -A | grep vgo
    
    echo ""
    log_info "Service URLs (add to /etc/hosts):"
    echo "  127.0.0.1 vgo-iam.local"
    echo "  127.0.0.1 vgo-notify.local"
    echo "  127.0.0.1 api.vgo.local"
    echo "  127.0.0.1 prometheus.vgo.local"
    echo "  127.0.0.1 grafana.vgo.local"
    echo "  127.0.0.1 jaeger.vgo.local"
    echo "  127.0.0.1 monitoring.vgo.local"
}

# 构建Docker镜像
build_images() {
    log_info "Building Docker images..."
    
    # 构建VGO-IAM镜像
    if [ -d "vgo-iam" ]; then
        log_info "Building VGO-IAM image..."
        cd vgo-iam
        docker build -t vgo-iam:latest .
        cd ..
        log_success "VGO-IAM image built"
    else
        log_warning "VGO-IAM directory not found, skipping image build"
    fi
    
    # 构建VGO-NOTIFY镜像（如果存在）
    if [ -d "vgo-notify" ]; then
        log_info "Building VGO-NOTIFY image..."
        cd vgo-notify
        docker build -t vgo-notify:latest .
        cd ..
        log_success "VGO-NOTIFY image built"
    else
        log_warning "VGO-NOTIFY directory not found, skipping image build"
    fi
}

# 显示帮助信息
show_help() {
    echo "VGO微服务部署脚本"
    echo ""
    echo "使用方法:"
    echo "  $0 [platform] [action]"
    echo ""
    echo "平台 (platform):"
    echo "  docker-compose    使用Docker Compose部署"
    echo "  k8s              使用Kubernetes部署"
    echo ""
    echo "操作 (action):"
    echo "  start            启动服务"
    echo "  stop             停止服务"
    echo "  restart          重启服务"
    echo "  status           查看服务状态"
    echo "  build            构建Docker镜像"
    echo ""
    echo "示例:"
    echo "  $0 docker-compose start"
    echo "  $0 k8s status"
    echo "  $0 build"
}

# 主函数
main() {
    local platform=$1
    local action=$2
    
    # 检查参数
    if [ -z "$platform" ] || [ -z "$action" ]; then
        if [ "$platform" = "build" ]; then
            build_images
            return
        fi
        show_help
        exit 1
    fi
    
    # 检查平台参数
    if [ "$platform" != "docker-compose" ] && [ "$platform" != "k8s" ]; then
        log_error "Invalid platform: $platform"
        show_help
        exit 1
    fi
    
    # 检查操作参数
    if [ "$action" != "start" ] && [ "$action" != "stop" ] && [ "$action" != "restart" ] && [ "$action" != "status" ]; then
        log_error "Invalid action: $action"
        show_help
        exit 1
    fi
    
    # 检查依赖
    check_dependencies $platform
    
    # 执行操作
    case $platform in
        "docker-compose")
            case $action in
                "start") docker_compose_start ;;
                "stop") docker_compose_stop ;;
                "restart") docker_compose_restart ;;
                "status") docker_compose_status ;;
            esac
            ;;
        "k8s")
            case $action in
                "start") k8s_start ;;
                "stop") k8s_stop ;;
                "restart") k8s_restart ;;
                "status") k8s_status ;;
            esac
            ;;
    esac
}

# 执行主函数
main "$@"