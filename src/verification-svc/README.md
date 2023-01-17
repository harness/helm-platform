# verification-svc

![Version: 0.2.2](https://img.shields.io/badge/Version-0.2.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.1](https://img.shields.io/badge/AppVersion-0.0.1-informational?style=flat-square)

A Helm chart for Kubernetes

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://harness.github.io/helm-common | harness-common | 1.x.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| appLogInfo | string | `"INFO"` | appLogInfo can be INFO DEBUG WARN ERROR |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| fullnameOverride | string | `""` |  |
| global.airgap | bool | `false` |  |
| global.ha | bool | `false` |  |
| global.ingress.additionalPaths | string | `nil` |  |
| global.ingress.className | string | `"harness"` |  |
| global.ingress.enabled | bool | `false` |  |
| global.ingress.hosts[0] | string | `"*"` |  |
| global.ingress.objects.annotations | object | `{}` |  |
| global.ingress.tls.enabled | bool | `false` |  |
| global.ingress.tls.secretName | string | `"harness-cert"` |  |
| global.istio.enabled | bool | `false` |  |
| global.istio.gateway.create | bool | `false` |  |
| global.istio.virtualService.gateways | string | `nil` |  |
| global.istio.virtualService.hosts | string | `nil` |  |
| global.loadbalancerURL | string | `""` |  |
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"harness/verification-service-signed"` |  |
| image.tag | string | `"77622"` |  |
| java | object | `{"memory":2048}` | Specify Java memory to be used |
| maxSurge | int | `1` |  |
| maxUnavailable | int | `0` |  |
| mongoSecrets.password.key | string | `"mongodb-root-password"` |  |
| mongoSecrets.password.name | string | `"mongodb-replicaset-chart"` |  |
| mongoSecrets.userName.key | string | `"mongodbUsername"` |  |
| mongoSecrets.userName.name | string | `"harness-secrets"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources.limits.cpu | string | `"500m"` |  |
| resources.limits.memory | string | `"3000Mi"` |  |
| resources.requests.cpu | string | `"500m"` |  |
| resources.requests.memory | string | `"3000Mi"` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| service.port | int | `7070` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `"harness-default"` |  |
| tolerations | list | `[]` |  |
| waitForInitContainer.image.digest | string | `""` |  |
| waitForInitContainer.image.pullPolicy | string | `"IfNotPresent"` |  |
| waitForInitContainer.image.registry | string | `"docker.io"` |  |
| waitForInitContainer.image.repository | string | `"harness/helm-init-container"` |  |
| waitForInitContainer.image.tag | string | `"latest"` |  |

