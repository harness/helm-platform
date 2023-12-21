{{/*
Expand the name of the chart.
*/}}
{{- define "manager-iterator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "manager-iterator.fullname" -}}
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
{{- define "manager-iterator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "manager-iterator.labels" -}}
helm.sh/chart: {{ include "manager-iterator.chart" . }}
{{ include "manager-iterator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "manager-iterator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "manager-iterator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "manager-iterator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "manager-iterator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the delegate image to use
*/}}
{{- define "manager-iterator.delegate_docker_image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.delegate_docker_image.image "global" .Values.global) }}
{{- end }}

{{/*
Create the name of the immutable delegate image to use
*/}}
{{- define "manager-iterator.immutable_delegate_docker_image" -}}
{{- $tag := printf "%s" .Values.immutable_delegate_docker_image.image.tag }}
{{- if .Values.global.useMinimalDelegateImage }}
{{- $tag = printf "%s.minimal" $tag }}
{{- end }}
{{- $image := dict "registry" .Values.immutable_delegate_docker_image.image.registry "repository" .Values.immutable_delegate_docker_image.image.repository "tag" $tag "digest" .Values.immutable_delegate_docker_image.image.digest -}}
{{ include "common.images.image" (dict "imageRoot" $image "global" .Values.global) }}
{{- end }}

{{/*
Create the name of the delegate upgrader image to use
*/}}
{{- define "manager-iterator.upgrader_docker_image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.upgrader_docker_image.image "global" .Values.global) }}
{{- end }}


## Generate ffString based of feature flag values and globally enabled features
{{- define "manager-iterator.ffString" -}}
{{- $flags := .Values.featureFlags.Base }}
{{- if .Values.global.gitops.enabled }}
{{- $flags = printf "%s,%s" $flags $.Values.featureFlags.GitOps }}
{{- end }}
{{- if .Values.global.opa.enabled }}
{{- $flags = printf "%s,%s" $flags $.Values.featureFlags.OPA }}
{{- end }}
{{- if not .Values.global.ngGitSync.enabled }}
{{- $flags = printf "%s,%s" $flags $.Values.featureFlags.OLDGITSYNC }}
{{- end }}
{{- if .Values.global.cd.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.CD }}
{{- end }}
{{- if .Values.global.ci.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.CI }}
{{- end }}
{{- if .Values.global.sto.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.STO }}
{{- end }}
{{- if .Values.global.srm.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.SRM }}
{{- end }}
{{- if .Values.global.ngcustomdashboard.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.CDB }}
{{- end }}
{{- if .Values.global.ff.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.FF }}
{{- end }}
{{- if .Values.global.ccm.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.CCM }}
{{- end }}
{{- if .Values.global.saml.autoaccept }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.SAMLAutoAccept }}
{{- end }}
{{- $length := len .Values.global.license.ng }}
{{- if gt $length 0}}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.LICENSE }}
{{- end }}
{{- if .Values.global.ng.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.NG }}
{{- end }}
{{- if .Values.global.chaos.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.CHAOS }}
{{- end }}
{{- if .Values.global.cet.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.CET }}
{{- end }}
{{- $length2 := len .Values.featureFlags.ADDITIONAL }}
{{- if gt $length2 0}}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.ADDITIONAL }}
{{- end }}
{{- printf "%s" $flags }}
{{- end }}

{{- define "manager-iterator.pullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.waitForInitContainer.image) "global" .Values.global ) }}
{{- end -}}
