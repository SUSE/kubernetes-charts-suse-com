# cert-exporter

[cert-exporter](https://github.com/joe-elliott/cert-exporter) is a Prometheus exporter that exports the metrics of cert expirations on hosts and in Kubernetes secrets.

## Introduction

This chart deploys a DaemonSet to export the metrics of cert expiration on hosts and a Deployment to export the metrics of cert expiration in Kubernetes secrets.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release suse/cert-exporter
```

## Uninstalling the Chart

To uninstall/delete the chart with the release name `my-release`:

```bash
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the cert-exporter chart and their default values.

| Parameter                         | Description                                                                  | Default                                    |
| --------------------------------- | ---------------------------------------------------------------------------- | ------------------------------------------ |
| `image.repository`                | The image repository to pull from                                            | `registry.suse.com/caasp/v4/cert-exporter` |
| `image.tag`                       | The image tag to pull                                                        | `2.2.0`                                    |
| `image.pullPolicy`                | Image pull policy                                                            | `IfNotPresent`                             |
| `imagePullSecrets`                | Name of Secret resource containing private registry credentials              | `[]`                                       |
| `resources`                       | Pod resource requests & limits                                               | `{}`                                       |
| `addon.nodeSelector`              | Node labels for cert-exporter addon Deployment pod assignment                | `{}`                                       |
| `addon.affinity`                  | Affinity settings for cert-exporter addon Deployment pod assignment          | `{}`                                       |
| `customSecret.enabled`            | If true, create custom secrets Deployment                                    | `false`                                    |
| `customSecret.namespace`          | Kubernetes namespace to list custom secrets                                  | `{}`                                       |
| `customSecret.includeKeys`        | Secret globs to include when looking for custom secrets data keys            | `{}`                                       |
| `customSecret.excludeKeys`        | Secret globs to exclude when looking for custom secrets data keys            | `{}`                                       |
| `customSecret.labelSelector`      | Label selector to find custom secrets to publish as metrics                  | `{}`                                       |
| `customSecret.annotationSelector` | Annotation selector to find custom secrets to publish as metrics             | `{}`                                       |
| `customSecret.nodeSelector`       | Node labels for cert-exporter custom secrets Deployment pod assignment       | `{}`                                       |
| `customSecret.affinity`           | Affinity settings for cert-exporter custom secrets Deployment pod assignment | `{}`                                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

For example:
1. monitor cert-manager issues certificates in cert-managert-test namespace.
   ```bash
   helm install \
       --name my-release \
       --set customSecret.enabled=true \
       --set customSecret.namespace=cert-manager-test \
       --set customSecret.includeKeys="{ca.crt,tls.crt}" \
       --set customSecret.annotationSelector="{cert-manager.io/certificate-name}"
   ```
2. monitor certificates in all namespaces filtered by label selector.
   ```bash
   helm install \
       --name my-release \
       --set customSecret.enabled=true \
       --set customSecret.includeKeys="{ca.crt,tls.crt}" \
       --set customSecret.labelSelector="{key=value}"
   ```
