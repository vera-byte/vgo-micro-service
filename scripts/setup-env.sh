#!/bin/bash

# VGO微服务环境配置脚本
# 使用方法: ./setup-env.sh [dev|staging|prod]

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

# 创建环境配置文件
create_env_file() {
    local env=$1
    local env_file=".env.$env"
    
    log_info "Creating environment file: $env_file"
    
    case $env in
        "dev")
            cat > $env_file << EOF
# VGO微服务开发环境配置
ENVIRONMENT=development

# 数据库配置
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=vgo_user
POSTGRES_PASSWORD=vgo_password
POSTGRES_DB_IAM=vgo_iam
POSTGRES_DB_NOTIFY=vgo_notify

# Redis配置
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=vgo_redis_password
REDIS_DB=0

# VGO-IAM配置
VGO_IAM_HTTP_PORT=8080
VGO_IAM_GRPC_PORT=9090
VGO_IAM_METRICS_PORT=8081
VGO_IAM_JWT_SECRET=dev_jwt_secret_key_change_in_production
VGO_IAM_JWT_EXPIRY=24h
VGO_IAM_RATE_LIMIT=1000
VGO_IAM_ACCESS_KEY_ROTATION_DAYS=90

# VGO-NOTIFY配置
VGO_NOTIFY_HTTP_PORT=8082
VGO_NOTIFY_GRPC_PORT=9092
VGO_NOTIFY_METRICS_PORT=8083

# 邮件配置
SMTP_HOST=localhost
SMTP_PORT=1025
SMTP_USERNAME=
SMTP_PASSWORD=
SMTP_FROM=noreply@vgo.local

# SMS配置
SMS_PROVIDER=mock
SMS_API_KEY=
SMS_API_SECRET=

# Webhook配置
WEBHOOK_TIMEOUT=30s
WEBHOOK_RETRY_COUNT=3

# 监控配置
PROMETHEUS_PORT=9090
GRAFANA_PORT=3000
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=admin123
JAEGER_PORT=16686
JAEGER_AGENT_PORT=6831

# 日志配置
LOG_LEVEL=debug
LOG_FORMAT=json

# 追踪配置
JAEGER_ENDPOINT=http://localhost:14268/api/traces
JAEGER_SAMPLER_TYPE=const
JAEGER_SAMPLER_PARAM=1

# Nginx配置
NGINX_PORT=80
NGINX_SSL_PORT=443
EOF
            ;;
        "staging")
            cat > $env_file << EOF
# VGO微服务预发布环境配置
ENVIRONMENT=staging

# 数据库配置
POSTGRES_HOST=postgres-staging.vgo.internal
POSTGRES_PORT=5432
POSTGRES_USER=vgo_user
POSTGRES_PASSWORD=staging_postgres_password_change_me
POSTGRES_DB_IAM=vgo_iam
POSTGRES_DB_NOTIFY=vgo_notify

# Redis配置
REDIS_HOST=redis-staging.vgo.internal
REDIS_PORT=6379
REDIS_PASSWORD=staging_redis_password_change_me
REDIS_DB=0

# VGO-IAM配置
VGO_IAM_HTTP_PORT=8080
VGO_IAM_GRPC_PORT=9090
VGO_IAM_METRICS_PORT=8081
VGO_IAM_JWT_SECRET=staging_jwt_secret_key_change_in_production
VGO_IAM_JWT_EXPIRY=12h
VGO_IAM_RATE_LIMIT=500
VGO_IAM_ACCESS_KEY_ROTATION_DAYS=60

# VGO-NOTIFY配置
VGO_NOTIFY_HTTP_PORT=8082
VGO_NOTIFY_GRPC_PORT=9092
VGO_NOTIFY_METRICS_PORT=8083

# 邮件配置
SMTP_HOST=smtp.staging.vgo.com
SMTP_PORT=587
SMTP_USERNAME=staging_smtp_user
SMTP_PASSWORD=staging_smtp_password
SMTP_FROM=noreply@staging.vgo.com

# SMS配置
SMS_PROVIDER=aliyun
SMS_API_KEY=staging_sms_api_key
SMS_API_SECRET=staging_sms_api_secret

# Webhook配置
WEBHOOK_TIMEOUT=30s
WEBHOOK_RETRY_COUNT=3

# 监控配置
PROMETHEUS_PORT=9090
GRAFANA_PORT=3000
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=staging_grafana_password
JAEGER_PORT=16686
JAEGER_AGENT_PORT=6831

# 日志配置
LOG_LEVEL=info
LOG_FORMAT=json

# 追踪配置
JAEGER_ENDPOINT=http://jaeger-collector.vgo-monitoring.svc.cluster.local:14268/api/traces
JAEGER_SAMPLER_TYPE=probabilistic
JAEGER_SAMPLER_PARAM=0.1

# Nginx配置
NGINX_PORT=80
NGINX_SSL_PORT=443
EOF
            ;;
        "prod")
            cat > $env_file << EOF
# VGO微服务生产环境配置
ENVIRONMENT=production

# 数据库配置
POSTGRES_HOST=postgres-prod.vgo.internal
POSTGRES_PORT=5432
POSTGRES_USER=vgo_user
POSTGRES_PASSWORD=CHANGE_ME_PRODUCTION_POSTGRES_PASSWORD
POSTGRES_DB_IAM=vgo_iam
POSTGRES_DB_NOTIFY=vgo_notify

# Redis配置
REDIS_HOST=redis-prod.vgo.internal
REDIS_PORT=6379
REDIS_PASSWORD=CHANGE_ME_PRODUCTION_REDIS_PASSWORD
REDIS_DB=0

# VGO-IAM配置
VGO_IAM_HTTP_PORT=8080
VGO_IAM_GRPC_PORT=9090
VGO_IAM_METRICS_PORT=8081
VGO_IAM_JWT_SECRET=CHANGE_ME_PRODUCTION_JWT_SECRET_KEY
VGO_IAM_JWT_EXPIRY=8h
VGO_IAM_RATE_LIMIT=200
VGO_IAM_ACCESS_KEY_ROTATION_DAYS=30

# VGO-NOTIFY配置
VGO_NOTIFY_HTTP_PORT=8082
VGO_NOTIFY_GRPC_PORT=9092
VGO_NOTIFY_METRICS_PORT=8083

# 邮件配置
SMTP_HOST=smtp.vgo.com
SMTP_PORT=587
SMTP_USERNAME=CHANGE_ME_PRODUCTION_SMTP_USER
SMTP_PASSWORD=CHANGE_ME_PRODUCTION_SMTP_PASSWORD
SMTP_FROM=noreply@vgo.com

# SMS配置
SMS_PROVIDER=aliyun
SMS_API_KEY=CHANGE_ME_PRODUCTION_SMS_API_KEY
SMS_API_SECRET=CHANGE_ME_PRODUCTION_SMS_API_SECRET

# Webhook配置
WEBHOOK_TIMEOUT=30s
WEBHOOK_RETRY_COUNT=3

# 监控配置
PROMETHEUS_PORT=9090
GRAFANA_PORT=3000
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=CHANGE_ME_PRODUCTION_GRAFANA_PASSWORD
JAEGER_PORT=16686
JAEGER_AGENT_PORT=6831

# 日志配置
LOG_LEVEL=warn
LOG_FORMAT=json

# 追踪配置
JAEGER_ENDPOINT=http://jaeger-collector.vgo-monitoring.svc.cluster.local:14268/api/traces
JAEGER_SAMPLER_TYPE=probabilistic
JAEGER_SAMPLER_PARAM=0.01

# Nginx配置
NGINX_PORT=80
NGINX_SSL_PORT=443
EOF
            ;;
    esac
    
    log_success "Environment file created: $env_file"
}

# 创建Kubernetes Secret
create_k8s_secrets() {
    local env=$1
    local env_file=".env.$env"
    
    if [ ! -f "$env_file" ]; then
        log_error "Environment file $env_file not found"
        return 1
    fi
    
    log_info "Creating Kubernetes secrets for $env environment..."
    
    # 创建数据库密钥
    kubectl create secret generic postgres-secret \
        --from-env-file=$env_file \
        --dry-run=client -o yaml | \
        kubectl apply -f - -n vgo-microservices
    
    # 创建Redis密钥
    kubectl create secret generic redis-secret \
        --from-env-file=$env_file \
        --dry-run=client -o yaml | \
        kubectl apply -f - -n vgo-microservices
    
    # 创建应用密钥
    kubectl create secret generic app-secret \
        --from-env-file=$env_file \
        --dry-run=client -o yaml | \
        kubectl apply -f - -n vgo-microservices
    
    # 创建监控密钥
    kubectl create secret generic monitoring-secret \
        --from-env-file=$env_file \
        --dry-run=client -o yaml | \
        kubectl apply -f - -n vgo-monitoring
    
    log_success "Kubernetes secrets created"
}

# 验证环境配置
validate_env() {
    local env=$1
    local env_file=".env.$env"
    
    if [ ! -f "$env_file" ]; then
        log_error "Environment file $env_file not found"
        return 1
    fi
    
    log_info "Validating environment configuration..."
    
    # 检查必需的变量
    local required_vars=(
        "POSTGRES_HOST"
        "POSTGRES_PASSWORD"
        "REDIS_HOST"
        "REDIS_PASSWORD"
        "VGO_IAM_JWT_SECRET"
    )
    
    source $env_file
    
    local missing_vars=()
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            missing_vars+=("$var")
        fi
    done
    
    if [ ${#missing_vars[@]} -gt 0 ]; then
        log_error "Missing required environment variables:"
        for var in "${missing_vars[@]}"; do
            echo "  - $var"
        done
        return 1
    fi
    
    # 检查生产环境的安全配置
    if [ "$env" = "prod" ]; then
        local insecure_vars=()
        
        if [[ "$POSTGRES_PASSWORD" == *"CHANGE_ME"* ]]; then
            insecure_vars+=("POSTGRES_PASSWORD")
        fi
        
        if [[ "$REDIS_PASSWORD" == *"CHANGE_ME"* ]]; then
            insecure_vars+=("REDIS_PASSWORD")
        fi
        
        if [[ "$VGO_IAM_JWT_SECRET" == *"CHANGE_ME"* ]]; then
            insecure_vars+=("VGO_IAM_JWT_SECRET")
        fi
        
        if [ ${#insecure_vars[@]} -gt 0 ]; then
            log_error "Production environment has insecure default values:"
            for var in "${insecure_vars[@]}"; do
                echo "  - $var"
            done
            log_error "Please update these values before deploying to production"
            return 1
        fi
    fi
    
    log_success "Environment configuration is valid"
}

# 生成随机密码
generate_password() {
    local length=${1:-32}
    openssl rand -base64 $length | tr -d "=+/" | cut -c1-$length
}

# 更新生产环境密码
update_prod_passwords() {
    local env_file=".env.prod"
    
    if [ ! -f "$env_file" ]; then
        log_error "Production environment file not found"
        return 1
    fi
    
    log_info "Updating production passwords..."
    
    # 生成新密码
    local postgres_password=$(generate_password 32)
    local redis_password=$(generate_password 32)
    local jwt_secret=$(generate_password 64)
    local grafana_password=$(generate_password 16)
    
    # 更新环境文件
    sed -i.bak "s/CHANGE_ME_PRODUCTION_POSTGRES_PASSWORD/$postgres_password/g" $env_file
    sed -i.bak "s/CHANGE_ME_PRODUCTION_REDIS_PASSWORD/$redis_password/g" $env_file
    sed -i.bak "s/CHANGE_ME_PRODUCTION_JWT_SECRET_KEY/$jwt_secret/g" $env_file
    sed -i.bak "s/CHANGE_ME_PRODUCTION_GRAFANA_PASSWORD/$grafana_password/g" $env_file
    
    # 删除备份文件
    rm -f $env_file.bak
    
    log_success "Production passwords updated"
    log_warning "Please securely store these passwords and update your secret management system"
}

# 显示帮助信息
show_help() {
    echo "VGO微服务环境配置脚本"
    echo ""
    echo "使用方法:"
    echo "  $0 [environment] [action]"
    echo ""
    echo "环境 (environment):"
    echo "  dev              开发环境"
    echo "  staging          预发布环境"
    echo "  prod             生产环境"
    echo ""
    echo "操作 (action):"
    echo "  create           创建环境配置文件"
    echo "  validate         验证环境配置"
    echo "  k8s-secrets      创建Kubernetes密钥"
    echo "  update-passwords 更新生产环境密码（仅限prod）"
    echo ""
    echo "示例:"
    echo "  $0 dev create"
    echo "  $0 prod validate"
    echo "  $0 staging k8s-secrets"
    echo "  $0 prod update-passwords"
}

# 主函数
main() {
    local env=$1
    local action=$2
    
    # 检查参数
    if [ -z "$env" ] || [ -z "$action" ]; then
        show_help
        exit 1
    fi
    
    # 检查环境参数
    if [ "$env" != "dev" ] && [ "$env" != "staging" ] && [ "$env" != "prod" ]; then
        log_error "Invalid environment: $env"
        show_help
        exit 1
    fi
    
    # 检查操作参数
    case $action in
        "create")
            create_env_file $env
            ;;
        "validate")
            validate_env $env
            ;;
        "k8s-secrets")
            create_k8s_secrets $env
            ;;
        "update-passwords")
            if [ "$env" != "prod" ]; then
                log_error "Password update is only available for production environment"
                exit 1
            fi
            update_prod_passwords
            ;;
        *)
            log_error "Invalid action: $action"
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"