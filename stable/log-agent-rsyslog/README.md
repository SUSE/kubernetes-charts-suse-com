# Log-Agent-Rsyslog

[Rsyslog](https://www.rsyslog.com/) is the rocket-fast system for log processing. You can use Log-Agent-Rsyslog to forward OS and Kubernetes cluster logs to centralized location such as Rsyslog server.

## Introduction

This chart deploys log-agent-rsyslog to all the nodes in your cluster via DaemonSet.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release suse/log-agent-rsyslog
```

After a few minutes, you should see service statuses being written to the configured output.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete log-agent-rsyslog --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the log-agent-rsyslog chart and their default values.

| Parameter | Description | Default |
| - | - | - |
| `image.repository` | The image repository to pull from | `registry.suse.com/caasp/v4/rsyslog` |
| `image.tag` | The image tag to pull | `8.39.0` |
| `server.host` | Rsyslog server host | `rsyslog-server.default.svc.cluster.local` |
| `server.port` | Rsyslog server port | `514` |
| `server.protocol` | Rsyslog server protocol | `tcp` |
| `server.tls.enabled` | Enable TLS | `false` |
| `server.tls.rootCa` | TLS rootCA |  |
| `server.tls.permittedPeer` | TLS server permitted peer | |
| `server.tls.clientCert` | TLS client cert | |
| `server.tls.clientKey` | TLS client key | |
| `resources.limits.cpu` | CPU limits | |
| `resources.limits.memory` | Memory limits | `512Mi` |
| `resources.requests.cpu` | CPU requests | `100m` |
| `resources.requests.memory` | Memory requests | `512Mi` |
| `persistStateInterval` | Rsyslog persist state interval in second | `100` |
| `resumeInverval` | Rsyslog resume interval in second | `30` |
| `resumeRetryCount` | Rsyslog resume retry count. `-1` is unlimited | `-1` |
| `queue.enabled` | Enable Rsyslog queue | `false` |
| `queue.size` | Rsyslog queue size in byte | `100000` |
| `queue.maxDiskSpace` | Rsyslog queue max disk space in byte | `2147483648` |
| `kubernetesPodLabelsEnabled` | Enable kubernetes meta labels in pod logs | `false` |
| `kubernetesPodAnnotationsEnabled` | Enable kubernetes meta annotations in pod logs | `false` |
| `logs.osSystem.enable` | Enable forwarding os system logs (auditd, kernel, wicked*, zypper) | `true` |
| `logs.kubernetesSystem.enable` | Enable forwarding kubernetes system logs (kubelet, crio) | `true` |
| `logs.kubernetesControlPlane` | Enable forwarding kubernetes control plane logs | `true` |
| `logs.kubernetesUserNamespaces.enable` | Enable forwarding kubernetes user namespaces logs | `false` |
| `logs.kubernetesUserNamespaces.exclude` | Exclude forwarding kubernetes logs for specific namespaces | `- ""` |
| `logs.kubernetesAudit.enabled` | Enables forwarding kubernetes audit logs | `false` |
| `logs.kubernetesAudit.logDir` | Kubernetes audit log directory | `/var/log/kube-apiserver` |
| `logs.kubernetesAudit.logFile` | Kubernetes audit log filename | `audit.log` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
               --set queue.enabled=true \
               suse/log-agent-rsyslog
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release \
               --values stable/log-agent-rsyslog/ci/values.yaml \
               suse/log-agent-rsyslog
```

## Testing
Go to tests folder, to verify all builtin e2e test cases

```bash
make test
```

Or run partial test cases with `bats` command. 

```bash
bats --tap k8sSystem.bats k8sControlPlane.bats
```
