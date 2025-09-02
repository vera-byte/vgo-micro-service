# 监控配置

VGO微服务提供了完整的监控解决方案，包括指标收集、日志聚合、链路追踪和告警通知。本指南将详细介绍如何配置和使用这些监控组件。

## 📊 监控架构

### 监控组件图

```mermaid
graph TB
    subgraph "应用层"
        A[IAM Service]
        B[Web UI]
        C[gRPC Client]
    end
    
    subgraph "指标收集"
        D[Prometheus]
        E[Node Exporter]
        F[Postgres Exporter]
        G[Redis Exporter]
    end
    
    subgraph "日志收集"
        H[Fluent Bit]
        I[Elasticsearch]
        J[Kibana]
    end
    
    subgraph "链路追踪"
        K[Jaeger]
        L[Jaeger Collector]
        M[Jaeger Query]
    end
    
    subgraph "告警通知"
        N[AlertManager]
        O[Webhook]
        P[Email/Slack]
    end
    
    subgraph "可视化"
        Q[Grafana]
        R[Dashboard]
    end
    
    A --> D
    A --> H
    A --> K
    
    D --> N
    D --> Q
    
    H --> I
    I --> J
    
    K --> L
    L --> M
    
    N --> O
    O --> P
    
    Q --> R
```

### 监控指标分类

| 类别 | 指标类型 | 示例指标 | 用途 |
|------|----------|----------|------|
| 应用指标 | Counter, Histogram | grpc_requests_total, http_request_duration | 业务监控 |
| 系统指标 | Gauge, Counter | cpu_usage, memory_usage, disk_io | 资源监控 |
| 数据库指标 | Gauge, Counter | pg_connections, pg_query_duration | 数据库监控 |
| 缓存指标 | Gauge, Counter | redis_connected_clients, redis_memory_usage | 缓存监控 |
| 网络指标 | Counter, Histogram | network_bytes_sent, network_latency | 网络监控 |

## 🔧 Prometheus配置

### 1. Prometheus部署

#### Docker Compose配置

```yaml
# docker-compose.monitoring.yml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: vgo-prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./monitoring/prometheus:/etc/prometheus
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=200h'
      - '--web.enable-lifecycle'
      - '--web.enable-admin-api'
    networks:
      - vgo-network
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.prometheus.rule=Host(`prometheus.vgo.local`)"
      - "traefik.http.services.prometheus.loadbalancer.server.port=9090"

  node-exporter:
    image: prom/node-exporter:latest
    container_name: vgo-node-exporter
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    networks:
      - vgo-network
    restart: unless-stopped

  postgres-exporter:
    image: prometheuscommunity/postgres-exporter:latest
    container_name: vgo-postgres-exporter
    ports:
      - "9187:9187"
    environment:
      DATA_SOURCE_NAME: "postgresql://vgo_user:your_password@postgres:5432/vgo_db?sslmode=disable"
    networks:
      - vgo-network
    restart: unless-stopped
    depends_on:
      - postgres

  redis-exporter:
    image: oliver006/redis_exporter:latest
    container_name: vgo-redis-exporter
    ports:
      - "9121:9121"
    environment:
      REDIS_ADDR: "redis://redis:6379"
      REDIS_PASSWORD: "your_redis_password"
    networks:
      - vgo-network
    restart: unless-stopped
    depends_on:
      - redis

volumes:
  prometheus_data:

networks:
  vgo-network:
    external: true
```

#### Prometheus配置文件

```yaml
# monitoring/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'vgo-cluster'
    environment: 'production'

rule_files:
  - "rules/*.yml"

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093

scrape_configs:
  # Prometheus自身
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
    scrape_interval: 5s
    metrics_path: /metrics

  # VGO IAM服务
  - job_name: 'vgo-iam'
    static_configs:
      - targets: ['iam:8082']
    scrape_interval: 10s
    metrics_path: /metrics
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        replacement: 'vgo-iam'

  # 系统指标
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
    scrape_interval: 15s
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        replacement: 'vgo-host'

  # PostgreSQL指标
  - job_name: 'postgres-exporter'
    static_configs:
      - targets: ['postgres-exporter:9187']
    scrape_interval: 15s
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        replacement: 'vgo-postgres'

  # Redis指标
  - job_name: 'redis-exporter'
    static_configs:
      - targets: ['redis-exporter:9121']
    scrape_interval: 15s
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        replacement: 'vgo-redis'

  # Docker容器指标
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
    scrape_interval: 15s
    metrics_path: /metrics

  # Blackbox探测
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]
    static_configs:
      - targets:
        - http://iam:8080/health
        - http://iam:8081/ready
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackbox-exporter:9115
```

### 2. 告警规则配置

```yaml
# monitoring/prometheus/rules/vgo-alerts.yml
groups:
  - name: vgo-iam-alerts
    rules:
      # 服务可用性告警
      - alert: VGOServiceDown
        expr: up{job="vgo-iam"} == 0
        for: 1m
        labels:
          severity: critical
          service: vgo-iam
        annotations:
          summary: "VGO IAM服务不可用"
          description: "VGO IAM服务已经停止响应超过1分钟"

      # 高错误率告警
      - alert: VGOHighErrorRate
        expr: |
          (
            rate(grpc_server_handled_total{grpc_code!="OK",job="vgo-iam"}[5m])
            /
            rate(grpc_server_handled_total{job="vgo-iam"}[5m])
          ) > 0.05
        for: 5m
        labels:
          severity: warning
          service: vgo-iam
        annotations:
          summary: "VGO IAM服务错误率过高"
          description: "VGO IAM服务5分钟内错误率超过5%，当前值：{{ $value | humanizePercentage }}"

      # 高延迟告警
      - alert: VGOHighLatency
        expr: |
          histogram_quantile(0.95,
            rate(grpc_server_handling_seconds_bucket{job="vgo-iam"}[5m])
          ) > 1
        for: 5m
        labels:
          severity: warning
          service: vgo-iam
        annotations:
          summary: "VGO IAM服务延迟过高"
          description: "VGO IAM服务95%分位延迟超过1秒，当前值：{{ $value }}s"

      # 内存使用率告警
      - alert: VGOHighMemoryUsage
        expr: |
          (
            process_resident_memory_bytes{job="vgo-iam"}
            /
            (1024*1024*1024)
          ) > 1
        for: 10m
        labels:
          severity: warning
          service: vgo-iam
        annotations:
          summary: "VGO IAM服务内存使用率过高"
          description: "VGO IAM服务内存使用超过1GB，当前值：{{ $value | humanize }}B"

      # CPU使用率告警
      - alert: VGOHighCPUUsage
        expr: |
          rate(process_cpu_seconds_total{job="vgo-iam"}[5m]) * 100 > 80
        for: 10m
        labels:
          severity: warning
          service: vgo-iam
        annotations:
          summary: "VGO IAM服务CPU使用率过高"
          description: "VGO IAM服务CPU使用率超过80%，当前值：{{ $value | humanizePercentage }}"

  - name: vgo-database-alerts
    rules:
      # 数据库连接数告警
      - alert: PostgreSQLHighConnections
        expr: |
          pg_stat_database_numbackends{datname="vgo_db"} > 80
        for: 5m
        labels:
          severity: warning
          service: postgresql
        annotations:
          summary: "PostgreSQL连接数过高"
          description: "PostgreSQL数据库连接数超过80，当前值：{{ $value }}"

      # 数据库查询时间告警
      - alert: PostgreSQLSlowQueries
        expr: |
          pg_stat_activity_max_tx_duration{datname="vgo_db"} > 300
        for: 2m
        labels:
          severity: warning
          service: postgresql
        annotations:
          summary: "PostgreSQL存在慢查询"
          description: "PostgreSQL存在执行时间超过5分钟的查询，当前最长：{{ $value }}秒"

      # 数据库磁盘空间告警
      - alert: PostgreSQLDiskSpaceLow
        expr: |
          (
            pg_database_size_bytes{datname="vgo_db"}
            /
            (1024*1024*1024)
          ) > 50
        for: 5m
        labels:
          severity: critical
          service: postgresql
        annotations:
          summary: "PostgreSQL磁盘空间不足"
          description: "PostgreSQL数据库大小超过50GB，当前值：{{ $value | humanize }}B"

  - name: vgo-redis-alerts
    rules:
      # Redis内存使用告警
      - alert: RedisHighMemoryUsage
        expr: |
          (
            redis_memory_used_bytes
            /
            redis_memory_max_bytes
          ) > 0.8
        for: 5m
        labels:
          severity: warning
          service: redis
        annotations:
          summary: "Redis内存使用率过高"
          description: "Redis内存使用率超过80%，当前值：{{ $value | humanizePercentage }}"

      # Redis连接数告警
      - alert: RedisHighConnections
        expr: redis_connected_clients > 100
        for: 5m
        labels:
          severity: warning
          service: redis
        annotations:
          summary: "Redis连接数过高"
          description: "Redis连接数超过100，当前值：{{ $value }}"

  - name: vgo-system-alerts
    rules:
      # 系统CPU使用率告警
      - alert: SystemHighCPUUsage
        expr: |
          (
            100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
          ) > 80
        for: 10m
        labels:
          severity: warning
          service: system
        annotations:
          summary: "系统CPU使用率过高"
          description: "系统CPU使用率超过80%，当前值：{{ $value | humanizePercentage }}"

      # 系统内存使用率告警
      - alert: SystemHighMemoryUsage
        expr: |
          (
            (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes)
            /
            node_memory_MemTotal_bytes
          ) > 0.8
        for: 10m
        labels:
          severity: warning
          service: system
        annotations:
          summary: "系统内存使用率过高"
          description: "系统内存使用率超过80%，当前值：{{ $value | humanizePercentage }}"

      # 系统磁盘空间告警
      - alert: SystemDiskSpaceLow
        expr: |
          (
            (node_filesystem_size_bytes{fstype!="tmpfs"} - node_filesystem_free_bytes{fstype!="tmpfs"})
            /
            node_filesystem_size_bytes{fstype!="tmpfs"}
          ) > 0.8
        for: 5m
        labels:
          severity: critical
          service: system
        annotations:
          summary: "系统磁盘空间不足"
          description: "系统磁盘使用率超过80%，挂载点：{{ $labels.mountpoint }}，当前值：{{ $value | humanizePercentage }}"
```

## 📈 Grafana配置

### 1. Grafana部署

```yaml
# docker-compose.grafana.yml
version: '3.8'

services:
  grafana:
    image: grafana/grafana:latest
    container_name: vgo-grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin123
      - GF_USERS_ALLOW_SIGN_UP=false
      - GF_INSTALL_PLUGINS=grafana-piechart-panel,grafana-worldmap-panel
    volumes:
      - grafana_data:/var/lib/grafana
      - ./monitoring/grafana/provisioning:/etc/grafana/provisioning
      - ./monitoring/grafana/dashboards:/var/lib/grafana/dashboards
    networks:
      - vgo-network
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.grafana.rule=Host(`grafana.vgo.local`)"
      - "traefik.http.services.grafana.loadbalancer.server.port=3000"
    depends_on:
      - prometheus

volumes:
  grafana_data:

networks:
  vgo-network:
    external: true
```

### 2. 数据源配置

```yaml
# monitoring/grafana/provisioning/datasources/prometheus.yml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
    jsonData:
      timeInterval: 15s
      queryTimeout: 60s
      httpMethod: POST
    secureJsonData: {}

  - name: Jaeger
    type: jaeger
    access: proxy
    url: http://jaeger-query:16686
    editable: true
    jsonData:
      tracesToLogs:
        datasourceUid: 'loki'
        tags: ['job', 'instance', 'pod', 'namespace']
        mappedTags: [{ key: 'service.name', value: 'service' }]
        mapTagNamesEnabled: false
        spanStartTimeShift: '1h'
        spanEndTimeShift: '1h'
        filterByTraceID: false
        filterBySpanID: false

  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
    editable: true
    jsonData:
      maxLines: 1000
      derivedFields:
        - datasourceUid: 'jaeger'
          matcherRegex: 'trace_id=(\w+)'
          name: 'TraceID'
          url: '$${__value.raw}'
```

### 3. 仪表板配置

```yaml
# monitoring/grafana/provisioning/dashboards/dashboards.yml
apiVersion: 1

providers:
  - name: 'VGO Dashboards'
    orgId: 1
    folder: 'VGO'
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    allowUiUpdates: true
    options:
      path: /var/lib/grafana/dashboards
```

### 4. VGO服务仪表板

```json
{
  "dashboard": {
    "id": null,
    "title": "VGO IAM Service",
    "tags": ["vgo", "iam", "microservice"],
    "timezone": "browser",
    "panels": [
      {
        "id": 1,
        "title": "请求速率",
        "type": "stat",
        "targets": [
          {
            "expr": "rate(grpc_server_handled_total{job=\"vgo-iam\"}[5m])",
            "legendFormat": "RPS"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "reqps",
            "color": {
              "mode": "thresholds"
            },
            "thresholds": {
              "steps": [
                {"color": "green", "value": null},
                {"color": "yellow", "value": 100},
                {"color": "red", "value": 500}
              ]
            }
          }
        },
        "gridPos": {"h": 8, "w": 6, "x": 0, "y": 0}
      },
      {
        "id": 2,
        "title": "错误率",
        "type": "stat",
        "targets": [
          {
            "expr": "rate(grpc_server_handled_total{job=\"vgo-iam\",grpc_code!=\"OK\"}[5m]) / rate(grpc_server_handled_total{job=\"vgo-iam\"}[5m])",
            "legendFormat": "Error Rate"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "percentunit",
            "color": {
              "mode": "thresholds"
            },
            "thresholds": {
              "steps": [
                {"color": "green", "value": null},
                {"color": "yellow", "value": 0.01},
                {"color": "red", "value": 0.05}
              ]
            }
          }
        },
        "gridPos": {"h": 8, "w": 6, "x": 6, "y": 0}
      },
      {
        "id": 3,
        "title": "响应时间",
        "type": "stat",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(grpc_server_handling_seconds_bucket{job=\"vgo-iam\"}[5m]))",
            "legendFormat": "P95 Latency"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "s",
            "color": {
              "mode": "thresholds"
            },
            "thresholds": {
              "steps": [
                {"color": "green", "value": null},
                {"color": "yellow", "value": 0.5},
                {"color": "red", "value": 1}
              ]
            }
          }
        },
        "gridPos": {"h": 8, "w": 6, "x": 12, "y": 0}
      },
      {
        "id": 4,
        "title": "活跃连接数",
        "type": "stat",
        "targets": [
          {
            "expr": "grpc_server_started_total{job=\"vgo-iam\"} - grpc_server_handled_total{job=\"vgo-iam\"}",
            "legendFormat": "Active Connections"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "short",
            "color": {
              "mode": "thresholds"
            },
            "thresholds": {
              "steps": [
                {"color": "green", "value": null},
                {"color": "yellow", "value": 100},
                {"color": "red", "value": 500}
              ]
            }
          }
        },
        "gridPos": {"h": 8, "w": 6, "x": 18, "y": 0}
      },
      {
        "id": 5,
        "title": "请求速率趋势",
        "type": "timeseries",
        "targets": [
          {
            "expr": "rate(grpc_server_handled_total{job=\"vgo-iam\"}[5m])",
            "legendFormat": "{{grpc_method}}"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "reqps",
            "custom": {
              "drawStyle": "line",
              "lineInterpolation": "linear",
              "lineWidth": 1,
              "fillOpacity": 10,
              "gradientMode": "none",
              "spanNulls": false,
              "pointSize": 5,
              "stacking": {"mode": "none", "group": "A"},
              "axisPlacement": "auto",
              "axisLabel": "",
              "scaleDistribution": {"type": "linear"}
            }
          }
        },
        "gridPos": {"h": 8, "w": 12, "x": 0, "y": 8}
      },
      {
        "id": 6,
        "title": "响应时间分布",
        "type": "timeseries",
        "targets": [
          {
            "expr": "histogram_quantile(0.50, rate(grpc_server_handling_seconds_bucket{job=\"vgo-iam\"}[5m]))",
            "legendFormat": "P50"
          },
          {
            "expr": "histogram_quantile(0.95, rate(grpc_server_handling_seconds_bucket{job=\"vgo-iam\"}[5m]))",
            "legendFormat": "P95"
          },
          {
            "expr": "histogram_quantile(0.99, rate(grpc_server_handling_seconds_bucket{job=\"vgo-iam\"}[5m]))",
            "legendFormat": "P99"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "s",
            "custom": {
              "drawStyle": "line",
              "lineInterpolation": "linear",
              "lineWidth": 1,
              "fillOpacity": 10,
              "gradientMode": "none",
              "spanNulls": false,
              "pointSize": 5,
              "stacking": {"mode": "none", "group": "A"},
              "axisPlacement": "auto",
              "axisLabel": "",
              "scaleDistribution": {"type": "linear"}
            }
          }
        },
        "gridPos": {"h": 8, "w": 12, "x": 12, "y": 8}
      }
    ],
    "time": {
      "from": "now-1h",
      "to": "now"
    },
    "refresh": "5s",
    "schemaVersion": 27,
    "version": 1
  }
}
```

## 🔍 链路追踪配置

### 1. Jaeger部署

```yaml
# docker-compose.jaeger.yml
version: '3.8'

services:
  jaeger-collector:
    image: jaegertracing/jaeger-collector:latest
    container_name: vgo-jaeger-collector
    ports:
      - "14268:14268"
      - "14250:14250"
    environment:
      - SPAN_STORAGE_TYPE=elasticsearch
      - ES_SERVER_URLS=http://elasticsearch:9200
      - ES_USERNAME=elastic
      - ES_PASSWORD=changeme
    networks:
      - vgo-network
    restart: unless-stopped
    depends_on:
      - elasticsearch

  jaeger-query:
    image: jaegertracing/jaeger-query:latest
    container_name: vgo-jaeger-query
    ports:
      - "16686:16686"
    environment:
      - SPAN_STORAGE_TYPE=elasticsearch
      - ES_SERVER_URLS=http://elasticsearch:9200
      - ES_USERNAME=elastic
      - ES_PASSWORD=changeme
    networks:
      - vgo-network
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.jaeger.rule=Host(`jaeger.vgo.local`)"
      - "traefik.http.services.jaeger.loadbalancer.server.port=16686"
    depends_on:
      - elasticsearch

  jaeger-agent:
    image: jaegertracing/jaeger-agent:latest
    container_name: vgo-jaeger-agent
    ports:
      - "6831:6831/udp"
      - "6832:6832/udp"
      - "5778:5778"
    environment:
      - REPORTER_GRPC_HOST_PORT=jaeger-collector:14250
    networks:
      - vgo-network
    restart: unless-stopped
    depends_on:
      - jaeger-collector

networks:
  vgo-network:
    external: true
```

### 2. 应用链路追踪配置

```go
// internal/tracing/jaeger.go
package tracing

import (
	"context"
	"io"
	"time"

	"github.com/opentracing/opentracing-go"
	"github.com/uber/jaeger-client-go"
	"github.com/uber/jaeger-client-go/config"
	"github.com/uber/jaeger-client-go/log"
	"github.com/uber/jaeger-client-go/metrics"
)

// TracingConfig 链路追踪配置
type TracingConfig struct {
	ServiceName     string  `yaml:"service_name"`
	JaegerEndpoint  string  `yaml:"jaeger_endpoint"`
	SampleRate      float64 `yaml:"sample_rate"`
	Enabled         bool    `yaml:"enabled"`
}

// InitJaeger 初始化Jaeger追踪
func InitJaeger(cfg TracingConfig) (opentracing.Tracer, io.Closer, error) {
	if !cfg.Enabled {
		return opentracing.NoopTracer{}, &noopCloser{}, nil
	}

	// Jaeger配置
	jcfg := config.Configuration{
		ServiceName: cfg.ServiceName,
		Sampler: &config.SamplerConfig{
			Type:  jaeger.SamplerTypeConst,
			Param: cfg.SampleRate,
		},
		Reporter: &config.ReporterConfig{
			LogSpans:            true,
			BufferFlushInterval: 1 * time.Second,
			CollectorEndpoint:   cfg.JaegerEndpoint,
		},
	}

	// 创建追踪器
	tracer, closer, err := jcfg.NewTracer(
		config.Logger(log.StdLogger),
		config.Metrics(metrics.NullFactory),
	)
	if err != nil {
		return nil, nil, err
	}

	// 设置全局追踪器
	opentracing.SetGlobalTracer(tracer)

	return tracer, closer, nil
}

// StartSpan 开始一个新的span
func StartSpan(ctx context.Context, operationName string) (opentracing.Span, context.Context) {
	span, ctx := opentracing.StartSpanFromContext(ctx, operationName)
	return span, ctx
}

// FinishSpan 结束span
func FinishSpan(span opentracing.Span, err error) {
	if err != nil {
		span.SetTag("error", true)
		span.LogKV("error", err.Error())
	}
	span.Finish()
}

type noopCloser struct{}

func (n *noopCloser) Close() error {
	return nil
}
```

## 📋 日志聚合配置

### 1. ELK Stack部署

```yaml
# docker-compose.elk.yml
version: '3.8'

services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.8.0
    container_name: vgo-elasticsearch
    environment:
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - xpack.security.enabled=false
      - xpack.security.enrollment.enabled=false
    ports:
      - "9200:9200"
      - "9300:9300"
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    networks:
      - vgo-network
    restart: unless-stopped

  kibana:
    image: docker.elastic.co/kibana/kibana:8.8.0
    container_name: vgo-kibana
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    networks:
      - vgo-network
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.kibana.rule=Host(`kibana.vgo.local`)"
      - "traefik.http.services.kibana.loadbalancer.server.port=5601"
    depends_on:
      - elasticsearch

  fluent-bit:
    image: fluent/fluent-bit:latest
    container_name: vgo-fluent-bit
    volumes:
      - ./monitoring/fluent-bit/fluent-bit.conf:/fluent-bit/etc/fluent-bit.conf
      - ./monitoring/fluent-bit/parsers.conf:/fluent-bit/etc/parsers.conf
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/log:/var/log:ro
    networks:
      - vgo-network
    restart: unless-stopped
    depends_on:
      - elasticsearch

volumes:
  elasticsearch_data:

networks:
  vgo-network:
    external: true
```

### 2. Fluent Bit配置

```ini
# monitoring/fluent-bit/fluent-bit.conf
[SERVICE]
    Flush         1
    Log_Level     info
    Daemon        off
    Parsers_File  parsers.conf
    HTTP_Server   On
    HTTP_Listen   0.0.0.0
    HTTP_Port     2020

[INPUT]
    Name              tail
    Path              /var/lib/docker/containers/*/*.log
    Parser            docker
    Tag               docker.*
    Refresh_Interval  5
    Mem_Buf_Limit     50MB
    Skip_Long_Lines   On
    Skip_Empty_Lines  On

[INPUT]
    Name              systemd
    Tag               systemd.*
    Systemd_Filter    _SYSTEMD_UNIT=docker.service
    Read_From_Tail    On

[FILTER]
    Name                kubernetes
    Match               docker.*
    Kube_URL            https://kubernetes.default.svc:443
    Kube_CA_File        /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    Kube_Token_File     /var/run/secrets/kubernetes.io/serviceaccount/token
    Kube_Tag_Prefix     docker.var.lib.docker.containers.
    Merge_Log           On
    Merge_Log_Key       log_processed
    K8S-Logging.Parser  On
    K8S-Logging.Exclude Off

[FILTER]
    Name                parser
    Match               docker.*vgo*
    Key_Name            log
    Parser              vgo_json
    Reserve_Data        On

[FILTER]
    Name                nest
    Match               docker.*vgo*
    Operation           lift
    Nested_under        kubernetes
    Add_prefix          k8s_

[FILTER]
    Name                modify
    Match               docker.*vgo*
    Add                 service vgo-iam
    Add                 environment production

[OUTPUT]
    Name            es
    Match           docker.*vgo*
    Host            elasticsearch
    Port            9200
    Index           vgo-logs
    Type            _doc
    Logstash_Format On
    Logstash_Prefix vgo
    Logstash_DateFormat %Y.%m.%d
    Include_Tag_Key On
    Tag_Key         @tag
    Retry_Limit     5
    Suppress_Type_Name On

[OUTPUT]
    Name            es
    Match           systemd.*
    Host            elasticsearch
    Port            9200
    Index           system-logs
    Type            _doc
    Logstash_Format On
    Logstash_Prefix system
    Logstash_DateFormat %Y.%m.%d
    Include_Tag_Key On
    Tag_Key         @tag
    Retry_Limit     5
    Suppress_Type_Name On
```

```ini
# monitoring/fluent-bit/parsers.conf
[PARSER]
    Name        docker
    Format      json
    Time_Key    time
    Time_Format %Y-%m-%dT%H:%M:%S.%L
    Time_Keep   On

[PARSER]
    Name        vgo_json
    Format      json
    Time_Key    timestamp
    Time_Format %Y-%m-%dT%H:%M:%S.%L%z
    Time_Keep   On

[PARSER]
    Name        nginx
    Format      regex
    Regex       ^(?<remote>[^ ]*) (?<host>[^ ]*) (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^\"]*?)(?: +\S*)?)?" (?<code>[^ ]*) (?<size>[^ ]*)(?: "(?<referer>[^\"]*)" "(?<agent>[^\"]*)")
    Time_Key    time
    Time_Format %d/%b/%Y:%H:%M:%S %z
```

## 🚨 AlertManager配置

### 1. AlertManager部署

```yaml
# docker-compose.alertmanager.yml
version: '3.8'

services:
  alertmanager:
    image: prom/alertmanager:latest
    container_name: vgo-alertmanager
    ports:
      - "9093:9093"
    volumes:
      - ./monitoring/alertmanager:/etc/alertmanager
      - alertmanager_data:/alertmanager
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
      - '--storage.path=/alertmanager'
      - '--web.external-url=http://localhost:9093'
      - '--cluster.listen-address=0.0.0.0:9094'
    networks:
      - vgo-network
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.alertmanager.rule=Host(`alertmanager.vgo.local`)"
      - "traefik.http.services.alertmanager.loadbalancer.server.port=9093"

volumes:
  alertmanager_data:

networks:
  vgo-network:
    external: true
```

### 2. AlertManager配置文件

```yaml
# monitoring/alertmanager/alertmanager.yml
global:
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'alerts@vgo.example.com'
  smtp_auth_username: 'alerts@vgo.example.com'
  smtp_auth_password: 'your_app_password'
  slack_api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'

route:
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'web.hook'
  routes:
    - match:
        severity: critical
      receiver: 'critical-alerts'
      group_wait: 5s
      repeat_interval: 30m
    - match:
        severity: warning
      receiver: 'warning-alerts'
      group_wait: 30s
      repeat_interval: 2h
    - match:
        service: vgo-iam
      receiver: 'vgo-team'
      group_wait: 10s
      repeat_interval: 1h

receivers:
  - name: 'web.hook'
    webhook_configs:
      - url: 'http://webhook-service:8080/alerts'
        send_resolved: true
        http_config:
          basic_auth:
            username: 'webhook_user'
            password: 'webhook_password'

  - name: 'critical-alerts'
    email_configs:
      - to: 'oncall@vgo.example.com'
        subject: '🚨 [CRITICAL] VGO Alert: {{ .GroupLabels.alertname }}'
        body: |
          {{ range .Alerts }}
          Alert: {{ .Annotations.summary }}
          Description: {{ .Annotations.description }}
          Service: {{ .Labels.service }}
          Severity: {{ .Labels.severity }}
          Time: {{ .StartsAt.Format "2006-01-02 15:04:05" }}
          {{ end }}
    slack_configs:
      - channel: '#critical-alerts'
        title: '🚨 Critical Alert'
        text: |
          {{ range .Alerts }}
          *Alert:* {{ .Annotations.summary }}
          *Description:* {{ .Annotations.description }}
          *Service:* {{ .Labels.service }}
          *Severity:* {{ .Labels.severity }}
          {{ end }}
        send_resolved: true

  - name: 'warning-alerts'
    email_configs:
      - to: 'team@vgo.example.com'
        subject: '⚠️ [WARNING] VGO Alert: {{ .GroupLabels.alertname }}'
        body: |
          {{ range .Alerts }}
          Alert: {{ .Annotations.summary }}
          Description: {{ .Annotations.description }}
          Service: {{ .Labels.service }}
          Severity: {{ .Labels.severity }}
          Time: {{ .StartsAt.Format "2006-01-02 15:04:05" }}
          {{ end }}
    slack_configs:
      - channel: '#alerts'
        title: '⚠️ Warning Alert'
        text: |
          {{ range .Alerts }}
          *Alert:* {{ .Annotations.summary }}
          *Description:* {{ .Annotations.description }}
          *Service:* {{ .Labels.service }}
          *Severity:* {{ .Labels.severity }}
          {{ end }}
        send_resolved: true

  - name: 'vgo-team'
    email_configs:
      - to: 'vgo-team@vgo.example.com'
        subject: '[VGO] Service Alert: {{ .GroupLabels.alertname }}'
        body: |
          VGO服务告警通知：
          
          {{ range .Alerts }}
          告警名称: {{ .Annotations.summary }}
          详细描述: {{ .Annotations.description }}
          服务名称: {{ .Labels.service }}
          告警级别: {{ .Labels.severity }}
          开始时间: {{ .StartsAt.Format "2006-01-02 15:04:05" }}
          {{ if .EndsAt }}结束时间: {{ .EndsAt.Format "2006-01-02 15:04:05" }}{{ end }}
          {{ end }}
    slack_configs:
      - channel: '#vgo-alerts'
        title: 'VGO Service Alert'
        text: |
          {{ range .Alerts }}
          *服务:* {{ .Labels.service }}
          *告警:* {{ .Annotations.summary }}
          *描述:* {{ .Annotations.description }}
          *级别:* {{ .Labels.severity }}
          {{ end }}
        send_resolved: true

inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'cluster', 'service']
```

## 🔧 监控部署脚本

### 完整部署脚本

```bash
#!/bin/bash
# scripts/deploy-monitoring.sh

set -e

echo "🚀 开始部署VGO监控系统..."

# 创建监控目录
mkdir -p monitoring/{prometheus,grafana,alertmanager,fluent-bit,jaeger}
mkdir -p monitoring/grafana/{provisioning/{datasources,dashboards},dashboards}
mkdir -p monitoring/prometheus/rules

# 检查Docker和Docker Compose
if ! command -v docker &> /dev/null; then
    echo "❌ Docker未安装，请先安装Docker"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose未安装，请先安装Docker Compose"
    exit 1
fi

# 创建网络
echo "📡 创建Docker网络..."
docker network create vgo-network 2>/dev/null || echo "网络已存在"

# 部署Elasticsearch和Kibana
echo "📊 部署ELK Stack..."
docker-compose -f docker-compose.elk.yml up -d

# 等待Elasticsearch启动
echo "⏳ 等待Elasticsearch启动..."
until curl -s http://localhost:9200/_cluster/health | grep -q '"status":"green"\|"status":"yellow"'; do
    echo "等待Elasticsearch..."
    sleep 5
done
echo "✅ Elasticsearch已启动"

# 部署Jaeger
echo "🔍 部署Jaeger..."
docker-compose -f docker-compose.jaeger.yml up -d

# 部署Prometheus和相关组件
echo "📈 部署Prometheus..."
docker-compose -f docker-compose.monitoring.yml up -d

# 部署Grafana
echo "📊 部署Grafana..."
docker-compose -f docker-compose.grafana.yml up -d

# 部署AlertManager
echo "🚨 部署AlertManager..."
docker-compose -f docker-compose.alertmanager.yml up -d

# 等待所有服务启动
echo "⏳ 等待所有服务启动..."
sleep 30

# 检查服务状态
echo "🔍 检查服务状态..."
services=("prometheus:9090" "grafana:3000" "alertmanager:9093" "kibana:5601" "jaeger-query:16686")

for service in "${services[@]}"; do
    name=$(echo $service | cut -d: -f1)
    port=$(echo $service | cut -d: -f2)
    
    if curl -s -f http://localhost:$port > /dev/null; then
        echo "✅ $name 运行正常 (端口 $port)"
    else
        echo "❌ $name 启动失败 (端口 $port)"
    fi
done

# 导入Grafana仪表板
echo "📊 导入Grafana仪表板..."
sleep 10

# 创建数据源
curl -X POST \
  http://admin:admin123@localhost:3000/api/datasources \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "Prometheus",
    "type": "prometheus",
    "url": "http://prometheus:9090",
    "access": "proxy",
    "isDefault": true
  }' 2>/dev/null || echo "数据源可能已存在"

echo ""
echo "🎉 监控系统部署完成！"
echo ""
echo "📊 访问地址："
echo "  - Grafana:      http://localhost:3000 (admin/admin123)"
echo "  - Prometheus:   http://localhost:9090"
echo "  - AlertManager: http://localhost:9093"
echo "  - Kibana:       http://localhost:5601"
echo "  - Jaeger:       http://localhost:16686"
echo ""
echo "📝 下一步："
echo "  1. 配置Grafana仪表板"
echo "  2. 设置告警通知"
echo "  3. 配置日志索引模式"
echo "  4. 验证链路追踪"
echo ""
```

### 监控验证脚本

```bash
#!/bin/bash
# scripts/verify-monitoring.sh

set -e

echo "🔍 验证VGO监控系统..."

# 检查Prometheus指标
echo "📈 检查Prometheus指标..."
if curl -s http://localhost:9090/api/v1/query?query=up | grep -q '"status":"success"'; then
    echo "✅ Prometheus API正常"
else
    echo "❌ Prometheus API异常"
fi

# 检查VGO服务指标
echo "🎯 检查VGO服务指标..."
if curl -s http://localhost:9090/api/v1/query?query=grpc_server_handled_total | grep -q 'grpc_server_handled_total'; then
    echo "✅ VGO服务指标正常"
else
    echo "⚠️ VGO服务指标未找到，请确保服务正在运行"
fi

# 检查告警规则
echo "🚨 检查告警规则..."
if curl -s http://localhost:9090/api/v1/rules | grep -q 'VGOServiceDown'; then
    echo "✅ 告警规则已加载"
else
    echo "❌ 告警规则未加载"
fi

# 检查Grafana
echo "📊 检查Grafana..."
if curl -s -u admin:admin123 http://localhost:3000/api/health | grep -q '"database":"ok"'; then
    echo "✅ Grafana正常"
else
    echo "❌ Grafana异常"
fi

# 检查Elasticsearch
echo "🔍 检查Elasticsearch..."
if curl -s http://localhost:9200/_cluster/health | grep -q '"status":"green"\|"status":"yellow"'; then
    echo "✅ Elasticsearch正常"
else
    echo "❌ Elasticsearch异常"
fi

# 检查Jaeger
echo "🔗 检查Jaeger..."
if curl -s http://localhost:16686/api/services | grep -q '"data"'; then
    echo "✅ Jaeger正常"
else
    echo "❌ Jaeger异常"
fi

echo ""
echo "✅ 监控系统验证完成！"
```

## 📚 相关文档

- [Docker Compose部署](./docker-compose.md) - 基础部署方案
- [Kubernetes部署](./kubernetes.md) - 生产环境部署
- [故障排除](./troubleshooting.md) - 问题诊断指南
- [性能调优](./performance.md) - 性能优化建议
- [安全配置](./security.md) - 安全最佳实践

---

::: tip 提示
监控系统需要一定的资源，建议在生产环境中为监控组件分配足够的CPU和内存。
:::

::: warning 注意
请根据实际环境调整告警阈值和通知配置，避免告警风暴。
:::