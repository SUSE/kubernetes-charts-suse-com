# QUARKS JOB

## Introduction

This helm chart deploys the quarks-job operator.

## Installing the Latest Stable Chart

To install the latest stable helm chart, with `quarks-job` as the release name into the namespace `quarks`:

```bash
$ helm install quarks-job https://s3.amazonaws.com/cf-operators/helm-charts/quarks-job-v0.0.1%2B47.g24492ea.tgz --namespace quarks
```

## Installing the Chart From the Developmenet Branch

Run `bin/build-image` to create a new docker image, export `DOCKER_IMAGE_TAG` to override the tag.

To install the helm chart directly from the [quarks-job repository](https://github.com/cloudfoundry-incubator/quarks-job) (any branch), run `bin/build-helm` first.

## Uninstalling the Chart

To delete the helm chart:

```bash
$ helm delete quarks-job --purge
```

## Configuration

| Parameter                                         | Description                                                                       | Default                                        |
| ------------------------------------------------- | -------------------------------------------------------------------------------------- | ---------------------------------------------- |
| `image.repository`                                | Docker hub repository for the quarks-job image                                         | `quarks-job`                                   |
| `image.org`                                       | Docker hub organization for the quarks-job image                                       | `cfcontainerization`                           |
| `image.tag`                                       | Docker image tag                                                                       | `foobar`                                       |
| `global.contextTimeout`                           | Will set the context timeout in seconds, for future K8S API requests                   | `30`                                           |
| `global.image.pullPolicy`                         | Kubernetes image pullPolicy                                                            | `IfNotPresent`                                 |
| `global.operator.watchNamespace`                  | Namespace the operator will watch for BOSH deployments                                 | the release namespace                          |
| `global.rbac.create`                              | Install required RBAC service account, roles and rolebindings                          | `true`                                         |
| `serviceAccount.create`                           | If true, create a service account                                                      |                                                |
| `serviceAccount.name`                             | If not set and `create` is `true`, a name is generated using the fullname of the chart |                                                |

## RBAC

By default, the helm chart will install RBAC ClusterRole and ClusterRoleBinding based on the chart release name, it will also grant the ClusterRole to an specific service account, which have the same name of the chart release.

The RBAC resources are enable by default. To disable use `--set global.rbacEnable=false`.

## Custom Resources

The `quarks-job` watches for the `QuarksJob` custom resource.

The `quarks-job` requires this CRD to be installed in the cluster, in order to work as expected. By default, the `quarks-job` applies the CRD in your cluster automatically.

To verify if the CRD is installed:

```bash
$ kubectl get crds
NAME                                            CREATED AT
quarksjobs.quarks.cloudfoundry.org           2019-06-25T07:08:37Z
```
