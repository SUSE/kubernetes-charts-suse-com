# Velero

Velero is an open source tool to safely backup and restore, perform disaster recovery, and migrate Kubernetes cluster resources and persistent volumes.

Velero has two main components: a CLI, and a server-side Kubernetes deployment.

## Installing the Velero server

This helm chart installs Velero version 1.3.1.

### Prerequisites

#### Provider credentials

When installing using the Helm chart, the provider's credential information will need to be appended into your values. The easiest way to do this is with the `--set-file` argument, available in Helm 2.10 and higher. See your cloud provider's documentation for the contents and creation of the `credentials-velero` file.

### Installing

The default configuration values for this chart are listed in values.yaml.

#### Option 1) CLI commands

Specify the necessary values using the --set key=value[,key=value] argument to helm install. For example,

```bash
helm install --namespace <YOUR NAMESPACE> \
--set configuration.provider=<PROVIDER NAME> \
--set-file credentials.secretContents.cloud=<FULL PATH TO FILE> \
--set configuration.backupStorageLocation.name=<PROVIDER NAME> \
--set configuration.backupStorageLocation.bucket=<BUCKET NAME> \
--set configuration.backupStorageLocation.config.region=<REGION> \
--set configuration.volumeSnapshotLocation.name=<PROVIDER NAME> \
--set configuration.volumeSnapshotLocation.config.region=<REGION> \
--set initContainers[0].name=velero-plugin-for-aws \
--set initContainers[0].image=registry.suse.com/caasp/v4/velero-plugin-for-aws:1.0.1 \
--set initContainers[0].volumeMounts[0].mountPath=/target \
--set initContainers[0].volumeMounts[0].name=plugins \
suse/velero
```

#### Option 2) YAML file

Add/update the necessary values by changing the values.yaml from this repository, then running:

```bash
helm install --namespace <NAMESPACE> -f values.yaml suse/velero
```

## Uninstall Velero

Note: when you uninstall the Velero server, all backups remain untouched.

```bash
helm delete <RELEASE NAME> --purge
```
