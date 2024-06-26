{{/*
Expand the name of the chart.
*/}}
{{- define "alertmanager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "alertmanager.fullname" -}}
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
{{- define "alertmanager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "alertmanager.labels" -}}
helm.sh/chart: {{ include "alertmanager.chart" . }}
{{ include "alertmanager.selectorLabels" . }}
app.kubernetes.io/component: alert-router
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Alertmanager Pod labels
*/}}
{{- define "alertmanager.pod.labels" -}}
helm.sh/chart: {{ include "alertmanager.chart" . }}
app.kubernetes.io/component: alert-router
{{- end }}

{{/*
Selector labels
*/}}
{{- define "alertmanager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "alertmanager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Pod Selector labels.
This is separate from the Alertmanager custom resource labels and other labels.
This is because Alertmanager operator has some reserved labels for the Alertmanager
Pods and those reserved labels CANNOT be overridden
*/}}
{{- define "alertmanager.pod.selectorLabels" -}}
alertmanager: {{ include "alertmanager.fullname" . }}
app.kubernetes.io/instance: {{ include "alertmanager.fullname" . }}
app.kubernetes.io/managed-by: prometheus-operator
app.kubernetes.io/name: alertmanager
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "alertmanager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "alertmanager.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Alertmanager Version
*/}}
{{- define "alertmanager.image.tag" -}}
{{- default (printf "v%s" .Chart.AppVersion) .Values.image.tag }}
{{- end }}

{{/*
Alertmanager Web API and Web Console Port
*/}}
{{- define "alertmanager.web.port" -}}
{{- 9093 }}
{{- end }}
