{{/*
Expand the name of the chart.
*/}}
{{- define "vgo-microservices.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "vgo-microservices.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "vgo-microservices.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "vgo-microservices.labels" -}}
helm.sh/chart: {{ include "vgo-microservices.chart" . }}
{{ include "vgo-microservices.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "vgo-microservices.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vgo-microservices.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "vgo-microservices.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "vgo-microservices.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
PostgreSQL fullname
*/}}
{{- define "vgo-microservices.postgresql.fullname" -}}
{{- if .Values.postgresql.enabled }}
{{- printf "%s-postgresql" (include "vgo-microservices.fullname" .) }}
{{- else }}
{{- .Values.externalPostgresql.host }}
{{- end }}
{{- end }}

{{/*
PostgreSQL secret name
*/}}
{{- define "vgo-microservices.postgresql.secretName" -}}
{{- if .Values.postgresql.enabled }}
{{- printf "%s-postgresql" (include "vgo-microservices.fullname" .) }}
{{- else }}
{{- .Values.externalPostgresql.existingSecret }}
{{- end }}
{{- end }}

{{/*
Redis fullname
*/}}
{{- define "vgo-microservices.redis.fullname" -}}
{{- if .Values.redis.enabled }}
{{- printf "%s-redis" (include "vgo-microservices.fullname" .) }}
{{- else }}
{{- .Values.externalRedis.host }}
{{- end }}
{{- end }}

{{/*
Redis secret name
*/}}
{{- define "vgo-microservices.redis.secretName" -}}
{{- if .Values.redis.enabled }}
{{- printf "%s-redis" (include "vgo-microservices.fullname" .) }}
{{- else }}
{{- .Values.externalRedis.existingSecret }}
{{- end }}
{{- end }}

{{/*
Prometheus fullname
*/}}
{{- define "vgo-microservices.prometheus.fullname" -}}
{{- printf "%s-prometheus-server" (include "vgo-microservices.fullname" .) }}
{{- end }}

{{/*
Grafana fullname
*/}}
{{- define "vgo-microservices.grafana.fullname" -}}
{{- printf "%s-grafana" (include "vgo-microservices.fullname" .) }}
{{- end }}

{{/*
Jaeger fullname
*/}}
{{- define "vgo-microservices.jaeger.fullname" -}}
{{- printf "%s-jaeger" (include "vgo-microservices.fullname" .) }}
{{- end }}

{{/*
Namespace for microservices
*/}}
{{- define "vgo-microservices.namespace" -}}
{{- default "vgo-microservices" .Values.namespace }}
{{- end }}

{{/*
Namespace for monitoring
*/}}
{{- define "vgo-microservices.monitoring.namespace" -}}
{{- default "vgo-monitoring" .Values.monitoringNamespace }}
{{- end }}

{{/*
Common environment variables
*/}}
{{- define "vgo-microservices.commonEnv" -}}
- name: ENVIRONMENT
  value: {{ .Values.environment | quote }}
- name: LOG_LEVEL
  value: {{ .Values.logLevel | default "info" | quote }}
- name: JAEGER_ENDPOINT
  value: "http://{{ include "vgo-microservices.jaeger.fullname" . }}-collector:14268/api/traces"
{{- end }}

{{/*
Database environment variables
*/}}
{{- define "vgo-microservices.databaseEnv" -}}
- name: POSTGRES_HOST
  value: {{ include "vgo-microservices.postgresql.fullname" . }}
- name: POSTGRES_PORT
  value: "5432"
- name: POSTGRES_USER
  value: {{ .Values.postgresql.auth.username | quote }}
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "vgo-microservices.postgresql.secretName" . }}
      key: password
- name: REDIS_HOST
  value: {{ include "vgo-microservices.redis.fullname" . }}-master
- name: REDIS_PORT
  value: "6379"
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "vgo-microservices.redis.secretName" . }}
      key: redis-password
{{- end }}