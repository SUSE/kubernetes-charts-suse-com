# cert-exporter

[cert-exporter](https://github.com/joe-elliott/cert-exporter) is a Prometheus exporter that publishes cert expirations on disk and in Kubernetes secrets.

## Introduction

This chart deploys a cert-exporter DaemonSet to publishes cert expirations on disk and deploys a cert-exporter Deployment to publishes cert expirations in Kubernets secrets.

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

| Parameter               | Description                                                                                                                | Default                                    |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| `image.repository`      | The image repository to pull from                                                                                          | `registry.suse.com/caasp/v4/cert-exporter` |
| `image.tag`             | The image tag to pull                                                                                                      | `2.2.0`                                    |
| `image.pullPolicy`      | Image pull policy                                                                                                          | `IfNotPresent`                             |
| `imagePullSecrets`      | Name of Secret resource containing private registry credentials                                                            | `[]`                                       |
| `serviceAccount.create` | if `true`, create a service account                                                                                        | `true`                                     |
| `serviceAccount.name`   | The name of the service account to use. If not set and `create` is `true`, a name is generated using the fullname template | `""`                                       |
| `securityContext`       | DaemonSet securityContext                                                                                                  | `{"runAsUser": 0}`                         |
| `resources`             | Pod resource requests & limits                                                                                             | `{}`                                       |
| `replicaCount`          | Desired number of cert-exporter Deployment pods                                                                            | `1`                                        |
| `nodeSelector`          | Node labels for cert-exporter Deployment pod assignment                                                                    | `{}`                                       |
| `affinity`              | Affinity settings for cert-exporter Deployment pod assignment                                                              | `{}`                                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install \
    --name my-release \
    --set replicaCount=2 \
    suse/cert-exporter
```
