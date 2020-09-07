# Velero

Velero is an open source tool to safely backup and restore, perform disaster recovery, and migrate Kubernetes cluster resources and persistent volumes.

Velero has two main components: a CLI, and a server-side Kubernetes deployment.

## Installing the Velero server

### Velero version

This helm chart installs Velero version v1.4.2 https://github.com/vmware-tanzu/velero/tree/v1.4.2.

### Provider credentials

When installing using the Helm chart, the provider's credential information will need to be appended into your values. The easiest way to do this is with the `--set-file` argument, available in Helm 2.10 and higher. See your cloud provider's documentation for the contents and creation of the `credentials-velero` file.

### Installing

The default configuration values for this chart are listed in values.yaml.

See Velero's full [official documentation](https://velero.io/docs/v1.4/basic-install/). More specifically, find your provider in the Velero list of [supported providers](https://velero.io/docs/v1.4/supported-providers/) for specific configuration information and examples.


#### Using Helm 3

First, create the namespace: `kubectl create namespace <YOUR NAMESPACE>`

##### Option 1) CLI commands

Note: you may add the flag `--set installCRDs=false` if you don't want to install the CRDs.

Specify the necessary values using the --set key=value[,key=value] argument to helm install. For example,

```bash
helm install suse/velero --namespace <YOUR NAMESPACE> \
--set-file credentials.secretContents.cloud=<FULL PATH TO FILE> \
--set configuration.provider=<PROVIDER NAME> \
--set configuration.backupStorageLocation.name=<BACKUP STORAGE LOCATION NAME> \
--set configuration.backupStorageLocation.bucket=<BUCKET NAME> \
--set configuration.backupStorageLocation.config.region=<REGION> \
--set configuration.volumeSnapshotLocation.name=<VOLUME SNAPSHOT LOCATION NAME> \
--set configuration.volumeSnapshotLocation.config.region=<REGION> \
--set image.repository=registry.suse.com/caasp/v4.5/velero \
--set image.tag=1.4.2 \
--set image.pullPolicy=IfNotPresent \
--set initContainers[0].name=velero-plugin-for-<PROVIDER NAME> \
--set initContainers[0].image=registry.suse.com/caasp/v4.5/velero-plugin-for-<PROVIDER NAME>:<PROVIDER PLUGIN TAG> \
--set initContainers[0].volumeMounts[0].mountPath=/target \
--set initContainers[0].volumeMounts[0].name=plugins \
--generate-name
```

##### Option 2) YAML file

Add/update the necessary values by changing the values.yaml from this repository, then run:

```bash
helm install suse/velero --namespace <YOUR NAMESPACE> -f values.yaml --generate-name
```
##### Upgrade the configuration

If a value needs to be added or changed, you may do so with the `upgrade` command. An example:

```bash
helm upgrade suse/velero <RELEASE NAME> --namespace <YOUR NAMESPACE> --reuse-values --set configuration.provider=<NEW PROVIDER>
```

#### Using Helm 2

##### Tiller cluster-admin permissions

A service account and the role binding prerequisite must be added to Tiller when configuring Helm to install Velero:

```
kubectl create sa -n kube-system tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount kube-system:tiller
helm init --tiller-image registry.suse.com/caasp/v4.5/helm-tiller:2.16.9 --service-account tiller --wait --upgrade
```

##### Option 1) CLI commands

Note: you may add the flag `--set installCRDs=false` if you don't want to install the CRDs.

Specify the necessary values using the --set key=value[,key=value] argument to helm install. For example,

```bash
helm install suse/velero --namespace <YOUR NAMESPACE> \
--set-file credentials.secretContents.cloud=<FULL PATH TO FILE> \
--set configuration.provider=<PROVIDER NAME> \
--set configuration.backupStorageLocation.name=<BACKUP STORAGE LOCATION NAME> \
--set configuration.backupStorageLocation.bucket=<BUCKET NAME> \
--set configuration.backupStorageLocation.config.region=<REGION> \
--set configuration.volumeSnapshotLocation.name=<VOLUME SNAPSHOT LOCATION NAME> \
--set configuration.volumeSnapshotLocation.config.region=<REGION> \
--set image.repository=registry.suse.com/caasp/v4.5/velero \
--set image.tag=1.4.2 \
--set image.pullPolicy=IfNotPresent \
--set initContainers[0].name=velero-plugin-for-<PROVIDER NAME> \
--set initContainers[0].image=registry.suse.com/caasp/v4.5/velero-plugin-for-<PROVIDER NAME>:<PROVIDER PLUGIN TAG> \
--set initContainers[0].volumeMounts[0].mountPath=/target \
--set initContainers[0].volumeMounts[0].name=plugins
```

##### Option 2) YAML file

Add/update the necessary values by changing the values.yaml from this repository, then run:

```bash
helm install suse/velero --namespace <YOUR NAMESPACE> -f values.yaml
```

##### Upgrade the configuration

If a value needs to be added or changed, you may do so with the `upgrade` command. An example:

```bash
helm upgrade suse/velero <RELEASE NAME> --reuse-values --set configuration.provider=<NEW PROVIDER>
```

## Uninstall Velero

Note: when you uninstall the Velero server, all backups remain untouched.

### Using Helm 2

```bash
helm delete <RELEASE NAME> --purge
```

### Using Helm 3

```bash
helm delete <RELEASE NAME> -n <YOUR NAMESPACE>
```
