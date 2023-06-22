{{/*
Expand the name of the chart.
*/}}
{{- define "change-data-capture.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "change-data-capture.fullname" -}}
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
{{- define "change-data-capture.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "change-data-capture.labels" -}}
helm.sh/chart: {{ include "change-data-capture.chart" . }}
{{ include "change-data-capture.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "change-data-capture.selectorLabels" -}}
app.kubernetes.io/name: {{ include "change-data-capture.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "change-data-capture.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "change-data-capture.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "change-data-capture.pullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.waitForInitContainer.image) "global" .Values.global ) }}
{{- end -}}


{{/* Generates TimeScale environment variables
{{ include "harnesscommon.dbconnection.timescaleEnv" (dict "passwordVariableName" "TIMESCALEDB_PASSWORD" "userVariableName" "TIMESCALEDB_USERNAME" "context" $) | nident 10 }}
*/}}
{{- define "harnesscommon.dbconnection.timescaleEnv" }}
{{- $type := "timescaledb" }}
{{- $dbType := upper $type }}
{{- $passwordSecret := (pluck $type .context.Values.global.database | first ).secretName }}
{{- $passwordKey := (pluck $type .context.Values.global.database | first).passwordKey }}
{{- $userKey := (pluck $type .context.Values.global.database | first).userKey }}
{{- $installed := (pluck $type .context.Values.global.database | first).installed }}
{{- $userVariableName := default (printf "%s_USER" $dbType) .userVariableName -}}
{{- $passwordVariableName := default (printf "%s_PASSWORD" $dbType) .passwordVariableName -}}
{{- if $installed }}
{{- include "harnesscommon.dbconnection.dbenvuser" (dict "type" $type "variableName" $userVariableName "secret" $passwordSecret "userValue" "postgres" ) }}
{{- include "harnesscommon.dbconnection.dbenvpassword" (dict "type" $type "variableName" $passwordVariableName "secret" "harness-secrets" "passwordKey" "timescaledbPostgresPassword" ) }}
{{- else }}
{{- include "harnesscommon.dbconnection.dbenvuser" (dict "type" $type "variableName" $userVariableName "secret" $passwordSecret  "userKey" $userKey ) }}
{{- include "harnesscommon.dbconnection.dbenvpassword" (dict "type" $type "variableName" $passwordVariableName "secret" $passwordSecret "passwordKey" $passwordKey ) }}
{{- end }}
{{- end }}

{{/* Generates TimeScale environment variables
{{ include "harnesscommon.dbconnection.timescaleSslEnv" . | nident 10 }}
*/}}
{{- define "harnesscommon.dbconnection.timescaleSslEnv" }}
{{- $type := "timescaledb" }}
{{- $dbType := upper $type }}
{{- $certSecret := (pluck $type .context.Values.global.database | first ).certName }}
{{- $certKey := (pluck $type .context.Values.global.database | first).certKey }}
{{- $installed := (pluck $type .context.Values.global.database | first).installed }}
{{- if not $installed }}
{{- if .certPathValue }}
{{- $certPathVariableName := default (printf "%s_SSL_CERT_PATH" $dbType) .certPathVariableName -}}
- name: {{ $certPathVariableName }}
  value: {{ printf "%s\n" .certPathValue }}
{{- end }}
{{- if .enableSslVariableName }}
- name: {{ printf "%s" .enableSslVariableName }}
  value: {{ (printf "%s\n" "'true'") }} 
{{- end }}
{{- if .certVariableName }}
- name: {{ .certVariableName  }}
  valueFrom:
    secretKeyRef:
      name: {{ printf "%s" $certSecret }}
      key: {{ printf "%s\n" $certKey }}
{{- end }}
{{- if .sslModeValue }}
{{- $sslModeVariableName := default (printf "%s_SSL_MODE" $dbType) .sslModeVariableName -}}
- name: {{ $sslModeVariableName }}
  value: {{ printf "%s\n" .sslModeValue }}
{{- end }}
{{- end }}
{{- end }}

{{- define "harnesscommon.dbconnection.timescaleHost" }}
{{- $connectionString := "" }}
{{- $type := "timescaledb" }}
{{- $installed := (pluck $type .context.Values.global.database | first).installed }}
{{- if $installed }}
{{- printf "%s.%s" "timescaledb-single-chart" .context.Release.Namespace }}
{{- else }}
{{- printf "%s"  (split ":" (index .context.Values.global.database.timescaledb.hosts 0))._0 }}
{{- end }}
{{- end }}

{{- define "harnesscommon.dbconnection.timescalePort" }}
{{- $connectionString := "" }}
{{- $type := "timescaledb" }}
{{- $installed := (pluck $type .context.Values.global.database | first).installed }}
{{- if $installed }}
{{- printf "%s" "5432" }}
{{- else }}
{{- printf "%s" (split ":" (index .context.Values.global.database.timescaledb.hosts 0))._1 }}
{{- end }}
{{- end }}

{{/* Generates Timescale Connection string
{{ include "harnesscommon.dbconnection.timescaleConnection" (dict "database" "foo" "args" "bar" "context" $) }}
*/}}
{{- define "harnesscommon.dbconnection.timescaleConnection" }}
{{- $host := include "harnesscommon.dbconnection.timescaleHost" (dict "context" .context ) }}
{{- $port := include "harnesscommon.dbconnection.timescalePort" (dict "context" .context ) }}
{{- $connectionString := "" }}
{{- if empty .protocol }}
{{- $connectionString = (printf "%s:%s" $host $port) }}
{{- else }}
{{- $connectionString = (printf "%s://%s:%s/%s" .protocol $host $port .database) }}
{{- end }}
{{- if .args }}
{{- $connectionString = (printf "%s?%s" $connectionString .args) }}
{{- end }}
{{- printf "%s" $connectionString -}}
{{- end }}