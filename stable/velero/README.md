# Velero

Velero is an open source tool to safely backup and restore, perform disaster recovery, and migrate Kubernetes cluster resources and persistent volumes.

Velero has two main components: a CLI, and a server-side Kubernetes deployment.

## Installing the Velero server

### Velero version

This helm chart installs Velero version 1.3.1.

### Provider credentials

When installing using the Helm chart, the provider's credential information will need to be appended into your values. The easiest way to do this is with the `--set-file` argument, available in Helm 2.10 and higher. See your cloud provider's documentation for the contents and creation of the `credentials-velero` file.

### Installing

The default configuration values for this chart are listed in values.yaml.

#### Using Helm 3

First, create the namespace: `kubectl create namespace <YOUR NAMESPACE>`

##### Option 1) CLI commands

Specify the necessary values using the --set key=value[,key=value] argument to helm install. For example,

```bash
helm install suse/velero --namespace <YOUR NAMESPACE> \
--set-file credentials.secretContents.cloud=<FULL PATH TO FILE> \
--set configuration.provider=aws \
--set configuration.backupStorageLocation.name=<PROVIDER NAME> \
--set configuration.backupStorageLocation.bucket=<BUCKET NAME> \
--set configuration.backupStorageLocation.config.region=<REGION> \
--set configuration.volumeSnapshotLocation.name=<PROVIDER NAME> \
--set configuration.volumeSnapshotLocation.config.region=<REGION> \
--set initContainers[0].name=velero-plugin-for-aws \
--set initContainers[0].image=registry.suse.com/caasp/v4.5/velero-plugin-for-aws:1.0.1 \
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
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --tiller-image registry.suse.com/caasp/v4.5/helm-tiller:2.16.1 --service-account tiller
```

##### Option 1) CLI commands

Specify the necessary values using the --set key=value[,key=value] argument to helm install. For example,

```bash
helm install suse/velero --namespace <YOUR NAMESPACE> \
--set-file credentials.secretContents.cloud=<FULL PATH TO FILE> \
--set configuration.provider=aws \
--set configuration.backupStorageLocation.name=<PROVIDER NAME> \
--set configuration.backupStorageLocation.bucket=<BUCKET NAME> \
--set configuration.backupStorageLocation.config.region=<REGION> \
--set configuration.volumeSnapshotLocation.name=<PROVIDER NAME> \
--set configuration.volumeSnapshotLocation.config.region=<REGION> \
--set initContainers[0].name=velero-plugin-for-aws \
--set initContainers[0].image=registry.suse.com/caasp/v4.5/velero-plugin-for-aws:1.0.1 \
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

#### Using Helm 3

```bash
helm delete <RELEASE NAME> --namespace <YOUR NAMESPACE>
```

#### Using Helm 2

```bash
helm delete <RELEASE NAME> --purge
```
