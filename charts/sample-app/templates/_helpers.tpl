{{/* Fully qualified app name, combining release name and chart name */}}
{{- define "sample-app.fullname" -}}
{{- .Release.Name -}}
{{- end -}}

{{/* Common labels applied to every resource this chart creates */}}
{{- define "sample-app.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}
