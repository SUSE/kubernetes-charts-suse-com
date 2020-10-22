# cert-exporter

[cert-exporter](https://github.com/joe-elliott/cert-exporter) is a Prometheus exporter that exports the metrics of cert expirations on hosts and in Kubernetes secrets.

## Introduction

This chart deploys a DaemonSet to export the metrics of cert expiration on hosts and a Deployment to export the metrics of cert expiration in Kubernetes secrets.

## Installing the Chart

### Using Helm 2

To install the chart with the release name <RELEASE_NAME>:

```bash
$ helm install \
      --name <RELEASE_NAME> \
      suse/cert-exporter
```

### Using Helm 3

```bash
$ helm install <RELEASE_NAME> \
      suse/cert-exporter
```

## Uninstalling the Chart

To uninstall/delete the chart with the release name <RELEASE_NAME>, the command removes all the Kubernetes components associated with the chart and deletes the release.

### Using Helm 2

```bash
$ helm delete <RELEASE_NAME> --purge
```

### Using Helm 3

```bash
$ helm delete <RELEASE_NAME>
```

## Configuration

The following table lists the configurable parameters of the cert-exporter chart and their default values.

| Parameter                            | Description                                                                       | Default                                      |
| ------------------------------------ | --------------------------------------------------------------------------------- | -------------------------------------------- |
| `image.repository`                   | The image repository to pull from                                                 | `registry.suse.com/caasp/v4.5/cert-exporter` |
| `image.tag`                          | The image tag to pull                                                             | `2.3.0`                                      |
| `image.pullPolicy`                   | Image pull policy                                                                 | `IfNotPresent`                               |
| `imagePullSecrets`                   | Name of Secret resource containing private registry credentials                   | `[]`                                         |
| `resources`                          | Pod resource requests & limits                                                    | `{}`                                         |
| `node.enabled`                       | If true, create node certs DaemonSet                                              | `true`                                       |
| `addon.enabled`                      | If true, create addon certs Deployment                                            | `true`                                       |
| `addon.nodeSelector`                 | Node labels for cert-exporter addon Deployment pod assignment                     | `{}`                                         |
| `addon.affinity`                     | Affinity settings for cert-exporter addon Deployment pod assignment               | `{}`                                         |
| `customSecret.enabled`               | If true, create custom secret certs Deployment                                    | `false`                                      |
| `customSecret[0].name`               | The name of the custom secret certs Deployment                                    | `cert-manager`                               |
| `customSecret[0].namespace`          | Kubernetes namespace to list custom secret certs                                  |                                              |
| `customSecret[0].includeKeys`        | Secret globs to include when looking for custom secret certs data keys            | `[]`                                         |
| `customSecret[0].excludeKeys`        | Secret globs to exclude when looking for custom secret certs data keys            | `[]`                                         |
| `customSecret[0].labelSelector`      | Label selector to find custom secret certs to publish as metrics                  | `[]`                                         |
| `customSecret[0].annotationSelector` | Annotation selector to find custom secret certs to publish as metrics             | `[]`                                         |
| `customSecret[0].nodeSelector`       | Node labels for cert-exporter custom secret certs Deployment pod assignment       | `{}`                                         |
| `customSecret[0].affinity`           | Affinity settings for cert-exporter custom secret certs Deployment pod assignment | `{}`                                         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

For examples:
1. Monitor cert-manager issues certificates in cert-managert-test namespace.
   - Using Helm 2
     ```bash
     helm install \
         --name <RELEASE_NAME> \
         --set customSecret.enabled=true \
         --set customSecret.certs[0].name=cert-manager \
         --set customSecret.certs[0].namespace=cert-manager-test \
         --set customSecret.certs[0].includeKeys="{*.crt,*.pem}" \
         --set customSecret.certs[0].annotationSelector="{cert-manager.io/certificate-name}" \
         suse/cert-exporter
     ```
   - Using Helm 3
     ```bash
     helm install <RELEASE_NAME> \
         --set customSecret.enabled=true \
         --set customSecret.certs[0].name=cert-manager \
         --set customSecret.certs[0].namespace=cert-manager-test \
         --set customSecret.certs[0].includeKeys="{*.crt,*.pem}" \
         --set customSecret.certs[0].annotationSelector="{cert-manager.io/certificate-name}" \
         suse/cert-exporter
      ```

2. Monitor certificates in all namespaces filtered by label selector.
   - Using Helm 2
     ```bash
     helm install \
         --name <RELEASE_NAME> \
         --set customSecret.enabled=true \
         --set customSecret.certs[0].name=self-signed-cert \
         --set customSecret.certs[0].includeKeys="{*.crt,*.pem}" \
         --set customSecret.certs[0].labelSelector="{key=value}" \
         suse/cert-exporter
     ```
   - Using Helm 3
     ```bash
     helm install <RELEASE_NAME> \
         --set customSecret.enabled=true \
         --set customSecret.certs[0].name=self-signed-cert \
         --set customSecret.certs[0].includeKeys="{*.crt,*.pem}" \
         --set customSecret.certs[0].labelSelector="{key=value}" \
         suse/cert-exporter
     ```

3. Deploy both 1. and 2. together.
   - Using Helm 2
     ```bash
     helm install
         --name <RELEASE_NAME> \
         --set customSecret.enabled=true \
         --set customSecret.certs[0].name=cert-manager \
         --set customSecret.certs[0].namespace=cert-manager-test \
         --set customSecret.certs[0].includeKeys="{*.crt,*.pem}" \
         --set customSecret.certs[0].annotationSelector="{cert-manager.io/certificate-name}" \
         --set customSecret.certs[1].name=self-signed-cert \
         --set customSecret.certs[1].includeKeys="{*.crt,*.pem}" \
         --set customSecret.certs[1].labelSelector="{key=value}" \
         suse/cert-exporter
     ```
   - Using Helm 3
     ```bash
     helm install <RELEASE_NAME> \
         --set customSecret.enabled=true \
         --set customSecret.certs[0].name=cert-manager \
         --set customSecret.certs[0].namespace=cert-manager-test \
         --set customSecret.certs[0].includeKeys="{*.crt,*.pem}" \
         --set customSecret.certs[0].annotationSelector="{cert-manager.io/certificate-name}" \
         --set customSecret.certs[1].name=self-signed-cert \
         --set customSecret.certs[1].includeKeys="{*.crt,*.pem}" \
         --set customSecret.certs[1].labelSelector="{key=value}" \
         suse/cert-exporter
     ```

4. Monitor custom certificates only without monitor node and addon certificates.
   - Using Helm 2
     ```bash
     helm install \
         --name <RELEASE_NAME> \
         --set node.enabled=false \
         --set addon.enabled=false \
         --set customSecret.enabled=true \
         --set customSecret.certs[0].name=cert-manager \
         --set customSecret.certs[0].namespace=cert-manager-test \
         --set customSecret.certs[0].includeKeys="{*.crt,*.pem}" \
         --set customSecret.certs[0].annotationSelector="{cert-manager.io/certificate-name}" \
         --set customSecret.certs[1].name=self-signed-cert \
         --set customSecret.certs[1].includeKeys="{*.crt,*.pem}" \
         --set customSecret.certs[1].labelSelector="{key=value}" \
         suse/cert-exporter
     ```
    - Using Helm 3
      ```bash
      helm install <RELEASE_NAME> \
          --set node.enabled=false \
          --set addon.enabled=false \
          --set customSecret.enabled=true \
          --set customSecret.certs[0].name=cert-manager \
          --set customSecret.certs[0].namespace=cert-manager-test \
          --set customSecret.certs[0].includeKeys="{*.crt,*.pem}" \
          --set customSecret.certs[0].annotationSelector="{cert-manager.io/certificate-name}" \
          --set customSecret.certs[1].name=self-signed-cert \
          --set customSecret.certs[1].includeKeys="{*.crt,*.pem}" \
          --set customSecret.certs[1].labelSelector="{key=value}" \
          suse/cert-exporter
      ```
