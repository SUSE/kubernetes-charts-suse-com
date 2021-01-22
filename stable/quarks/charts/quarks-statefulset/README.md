# QUARKS SECRET

## Introduction

This helm chart deploys the quarks-statefulset operator.

## Installing the Latest Stable Chart

To install the latest stable helm chart, with `quarks-statefulset` as the release name into the namespace `quarks`:

```bash
helm repo add quarks https://cloudfoundry-incubator.github.io/quarks-helm/
helm install quarks-statefulset quarks/quarks-statefulset
```

### Namespaces

The operator runs on every namespace that has the monitoredID label (quarks.cloudfoundry.org/monitored).

```
helm install relname1 quarks/quarks-statefulset \
  --set "global.monitoredID=relname1"
```

## Installing the Chart From the Developmenet Branch

Download the shared scripts with `bin/tools`, set `PROJECT=quarks-statefulset` and run `bin/build-image` to create a new docker image. Export `DOCKER_IMAGE_TAG` to override the tag that's being put in the chart.

To install the helm chart directly from the [quarks-statefulset repository](https://github.com/cloudfoundry-incubator/quarks-statefulset) (any branch), run `bin/build-helm` first.

## Uninstalling the Chart

To delete the helm chart:

```bash
$ helm delete quarks-statefulset --purge
```

## Configuration

| Parameter                                         | Description                                                                            | Default                                        |
| ------------------------------------------------- | -------------------------------------------------------------------------------------- | ---------------------------------------------- |
| `global.contextTimeout`                           | Will set the context timeout in seconds, for future K8S API requests                   | `30`                                           |
| `global.image.pullPolicy`                         | Kubernetes image pullPolicy                                                            | `IfNotPresent`                                 |
| `global.monitoredID`                              | Label value of 'quarks.cloudfoundry.org/monitored'. Matching namespaces are watched    | release name                                   |
| `global.rbac.create`                              | Install required RBAC service account, roles and rolebindings                          | `true`                                         |
| `operator.webhook.endpoint`                       | Hostname/IP under which the webhook server can be reached from the cluster                        | the IP of service `quarks-statefulset-webhook`        |
| `operator.webhook.port`                           | Port the webhook server listens on                                                                | 2999                                           |
| `global.operator.webhook.useServiceReference`     | If true, the webhook server is addressed using a service reference instead of the IP              | `true`                                         |
| `serviceAccount.create`                           | If true, create a service account                                                      | `true`                                         |
| `serviceAccount.name`                             | If not set and `create` is `true`, a name is generated using the fullname of the chart |                                                |
> **Note:**
>
> `global.operator.webhook.useServiceReference` will override `operator.webhook.endpoint` configuration
>

## RBAC

By default, the helm chart will install RBAC ClusterRole and ClusterRoleBinding based on the chart release name, it will also grant the ClusterRole to an specific service account, which have the same name of the chart release.

The RBAC resources are enable by default. To disable use `--set global.rbacEnable=false`.

## Custom Resources

The `quarks-statefulset` watches for the `QuarksStatefulset` custom resource.

The `quarks-statefulset` requires this CRD to be installed in the cluster, in order to work as expected. By default, the `quarks-statefulset` applies the CRD in your cluster automatically.

To verify if the CRD is installed:

```bash
$ kubectl get crds
NAME                                            CREATED AT
quarksstatefulset.quarks.cloudfoundry.org           2019-06-25T07:08:37Z
```
