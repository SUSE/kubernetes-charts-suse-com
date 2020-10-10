# QUARKS JOB

## Introduction

This helm chart deploys the quarks-job operator.

## Installing the Latest Stable Chart

To install the latest stable helm chart, with `quarks-job` as the release name into the namespace `quarks`:

```bash
helm repo add quarks https://cloudfoundry-incubator.github.io/quarks-helm/
helm install quarks-job quarks/quarks-job
```

### Using multiple operators

Choose different namespaces and cluster role names. The persist-output service account will be named the same as the cluster role:

```
helm install relname1 quarks/quarks-job \
  --namespace namespace1
  --set "global.singleNamespace.name=staging1" \
  --set "persistOutputClusterRole.name=clusterrole1" \
```

### Using multiple namespaces with one operator

The cluster role can be reused between namespaces.
The service account (and role binding) should be different for each namespace.

```
helm install relname1 quarks/cf-operator \
  --set "global.singleNamespace.create=false" \
  --set "persistOutputClusterRole.name=qjob-persist-output"
```

Manually create before running `helm install`, for each namespace:

* a namespace "staging1" with the following labels:
  * quarks.cloudfoundry.org/monitored: relname1
  * quarks.cloudfoundry.org/qjob-service-account: qjob-account1
* a service account named "qjob-account1"
* a role binding from the existing cluster role "qjob-persist-output" to "qjob-account1" in namespace "staging1"

## Installing the Chart From the Developmenet Branch

Download the shared scripts with `bin/tools`, set `PROJECT=quarks-job` and run `bin/build-image` to create a new docker image, export `DOCKER_IMAGE_TAG` to override the tag.

To install the helm chart directly from the [quarks-job repository](https://github.com/cloudfoundry-incubator/quarks-job) (any branch), run `bin/build-helm` first.

## Uninstalling the Chart

To delete the helm chart:

```bash
$ helm delete quarks-job --purge
```

## Configuration

| Parameter                                         | Description                                                                            | Default                                        |
| ------------------------------------------------- | -------------------------------------------------------------------------------------- | ---------------------------------------------- |
| `image.repository`                                | Docker hub repository for the quarks-job image                                         | `quarks-job`                                   |
| `image.org`                                       | Docker hub organization for the quarks-job image                                       | `cfcontainerization`                           |
| `image.tag`                                       | Docker image tag                                                                       | `foobar`                                       |
| `global.contextTimeout`                           | Will set the context timeout in seconds, for future K8S API requests                   | `30`                                           |
| `global.image.pullPolicy`                         | Kubernetes image pullPolicy                                                            | `IfNotPresent`                                 |
| `global.monitoredID`                              | Label value of 'quarks.cloudfoundry.org/monitored'. Matching namespaces are watched    | release name                                   |
| `global.rbac.create`                              | Install required RBAC service account, roles and rolebindings                          | `true`                                         |
| `serviceAccount.create`                           | If true, create a service account                                                      |                                                |
| `serviceAccount.name`                             | If not set and `create` is `true`, a name is generated using the fullname of the chart |                                                |
| `global.singleNamespace.create`                   | If true, create a service account and a single watch namespace                         | `true`                                         |
| `global.singleNamespace.name`                     | Namespace the operator will watch for Quarks jobs                                      | `staging`                                      |

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
