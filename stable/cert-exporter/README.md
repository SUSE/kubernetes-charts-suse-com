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

| Parameter          | Description                                                     | Default                                    |
| ------------------ | --------------------------------------------------------------- | ------------------------------------------ |
| `image.repository` | The image repository to pull from                               | `registry.suse.com/caasp/v4/cert-exporter` |
| `image.tag`        | The image tag to pull                                           | `2.2.0`                                    |
| `image.pullPolicy` | Image pull policy                                               | `IfNotPresent`                             |
| `imagePullSecrets` | Name of Secret resource containing private registry credentials | `[]`                                       |
| `resources`        | Pod resource requests & limits                                  | `{}`                                       |
| `nodeSelector`     | Node labels for cert-exporter Deployment pod assignment         | `{}`                                       |
| `affinity`         | Affinity settings for cert-exporter Deployment pod assignment   | `{}`                                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install \
    --name my-release \
    --set image.pullPolicy=Always \
    suse/cert-exporter
```
