---
title: Back up and restore Keptn
description: How to back up and restore Keptn.
weight: 50
keywords: backup
---

To secure all your data in your project's Git repository, as well as all events that have occurred for these projects, you must
back up the data within the *Configuration Service* (if used), the *MongoDB*, and credentials to your project's Git upstream repos (if you have configured those for *Configuration Service*).
The following sections describe how to back up that data and how to restore it.

**Note:** These instructions do not cover backing up any Helm- or Istio-related configurations.

:warning: Please make sure your `kubectl` is connected to the cluster where Keptn is running. 

## Back up Keptn with Configuration Service

This section describes how to back up your Keptn and store it on your local machine. 

### Back up Configuration Service

First, create a local backup directory containing all data within the Git repos of the configuration-service. To do so, please execute the following command:

```console
mkdir keptn-backup
cd keptn-backup
mkdir config-svc-backup
CONFIG_SERVICE_POD=$(kubectl get pods -n keptn -lapp.kubernetes.io/name=configuration-service -ojsonpath='{.items[0].metadata.name}')
kubectl cp keptn/$CONFIG_SERVICE_POD:/data ./config-svc-backup/ -c configuration-service
```

Verify that the data has been copied correctly to your local machine by checking the content of the directory you just created. 
This should include all projects you have onboarded with Keptn and a `lost+found` directory, which can be ignored.

```console
$ ls config-svc-backup/config
lost+found	sockshop my-project
```

### Back up Mongodb Data

The next step is to create a backup of the mongodb database in the `keptn-datastore` namespace using the `mongodump` tool.`

Create a directory for the MongoDB backup:

```console
mkdir mongodb-backup
chmod o+w mongodb-backup
```

Copy the data from the MongoDB to your local directory:

```console
MONGODB_ROOT_USER=$(kubectl get secret mongodb-credentials -n keptn -ojsonpath={.data.mongodb-root-user} | base64 -d)
MONGODB_ROOT_PASSWORD=$(kubectl get secret mongodb-credentials -n keptn -ojsonpath={.data.mongodb-root-password} | base64 --decode)

kubectl exec svc/keptn-mongo -n keptn -- mongodump --authenticationDatabase admin --username $MONGODB_ROOT_USER --password $MONGODB_ROOT_PASSWORD -d keptn -h localhost --out=/tmp/dump

MONGODB_POD=$(kubectl get pods -n keptn -lapp.kubernetes.io/name=mongo -ojsonpath='{.items[0].metadata.name}')
kubectl cp keptn/$MONGODB_POD:/tmp/dump ./mongodb-backup/ -c mongodb
```

### Back up Git credentials

For projects where you have configured a Git upstream repository, you should back up the Kubernetes secrets needed to access those.
To do so, please execute the following command for each project for which you have configured an upstream repo:

```console
PROJECT_NAME=<project_name>
kubectl get secret -n keptn git-credentials-$PROJECT_NAME -oyaml > $PROJECT_NAME-credentials.yaml
```

## Back up Keptn with Configuration Service and moving to Resource Service

This section describes how to back up your Keptn which is using Configuration Service, updating Keptn to a newer version which is using Resource Service and restoring your data. 

### Add remote git upstream repository to each project

There is no need to create an extra backup of the Configuration Service, but to not lose your data, you need to make sure every project
created on your Keptn instance has a configured remote git upstream repository. For project which do not have remote git upstream repository configured, you can use the `keptn update project` command of Keptn CLI to add it. An example of the command:

```console
keptn update project PROJECTNAME --git-user=GIT_USER --git-token=GIT_TOKEN --git-remote-url=GIT_REMOTE_URL
```

To list advanced options regading updating the project use the command bellow for more information:

```console
keptn update project --help
```

### Back up Mongodb Data

The next step is to create a backup of the mongodb database in the `keptn-datastore` namespace using the `mongodump` tool.`

Create a directory for the MongoDB backup:

```console
mkdir mongodb-backup
chmod o+w mongodb-backup
```

Copy the data from the MongoDB to your local directory:

```console
MONGODB_ROOT_USER=$(kubectl get secret mongodb-credentials -n keptn -ojsonpath={.data.mongodb-root-user} | base64 -d)
MONGODB_ROOT_PASSWORD=$(kubectl get secret mongodb-credentials -n keptn -ojsonpath={.data.mongodb-root-password} | base64 --decode)

kubectl exec svc/keptn-mongo -n keptn -- mongodump --authenticationDatabase admin --username $MONGODB_ROOT_USER --password $MONGODB_ROOT_PASSWORD -d keptn -h localhost --out=/tmp/dump

MONGODB_POD=$(kubectl get pods -n keptn -lapp.kubernetes.io/name=mongo -ojsonpath='{.items[0].metadata.name}')
kubectl cp keptn/$MONGODB_POD:/tmp/dump ./mongodb-backup/ -c mongodb
```

### Back up Git credentials

For storing Git credentials, please execute the following command for each project for which you have configured an upstream repo:

```console
PROJECT_NAME=<project_name>
kubectl get secret -n keptn git-credentials-$PROJECT_NAME -oyaml > $PROJECT_NAME-credentials.yaml
```

## Back up Keptn with Resource Service

There is no need to create any backup an extra backup of the Resource Service, as all the data are stored in remote git upstream repository and will be automatically synchronized to the Keptn instance after restoring the MongoDB data and Git credentials

### Back up Mongodb Data

The next step is to create a backup of the mongodb database in the `keptn-datastore` namespace using the `mongodump` tool.`

Create a directory for the MongoDB backup:

```console
mkdir mongodb-backup
chmod o+w mongodb-backup
```

Copy the data from the MongoDB to your local directory:

```console
MONGODB_ROOT_USER=$(kubectl get secret mongodb-credentials -n keptn -ojsonpath={.data.mongodb-root-user} | base64 -d)
MONGODB_ROOT_PASSWORD=$(kubectl get secret mongodb-credentials -n keptn -ojsonpath={.data.mongodb-root-password} | base64 --decode)

kubectl exec svc/keptn-mongo -n keptn -- mongodump --authenticationDatabase admin --username $MONGODB_ROOT_USER --password $MONGODB_ROOT_PASSWORD -d keptn -h localhost --out=/tmp/dump

MONGODB_POD=$(kubectl get pods -n keptn -lapp.kubernetes.io/name=mongo -ojsonpath='{.items[0].metadata.name}')
kubectl cp keptn/$MONGODB_POD:/tmp/dump ./mongodb-backup/ -c mongodb
```

### Back up Git credentials

For storing Git credentials, please execute the following command for each project for which you have configured an upstream repo:

```console
PROJECT_NAME=<project_name>
kubectl get secret -n keptn git-credentials-$PROJECT_NAME -oyaml > $PROJECT_NAME-credentials.yaml
```

## Restore Keptn

This section describes how to restore data from your Keptn projects on a fresh Keptn installation using the data you have stored on your machine using the instructions above. If using Resource Service, please skip the `Restore Configuration Service` step

### Restore Configuration Service

Copy the directory containing all Git repositories to the configuration-service:

```console
CONFIG_SERVICE_POD=$(kubectl get pods -n keptn -lapp.kubernetes.io/name=configuration-service -ojsonpath='{.items[0].metadata.name}')
kubectl cp ./config-svc-backup/config/ keptn/$CONFIG_SERVICE_POD:/data -c configuration-service
```

To make sure the Git repositories within the configuration service are in a consistent state, they need to be reset to the current HEAD. To do so, 
please execute the following commands:

<!-- 
Please note: This script is tested with an integration test here: https://github.com/keptn/keptn/blob/master/test/go-tests/test_backuprestore.go#L73
Do not change, without adapting the change in the integration test. 
-->
```console
cat <<EOT >> reset-git-repos.sh
#!/bin/sh

cd /data/config/
for FILE in *; do
    if [ -d "\$FILE" ]; then
        cd "\$FILE"
        git reset --hard
        cd ..
    fi
done
EOT

CONFIG_SERVICE_POD=$(kubectl get pods -n keptn -lapp.kubernetes.io/name=configuration-service -ojsonpath='{.items[0].metadata.name}')
kubectl cp ./reset-git-repos.sh keptn/$CONFIG_SERVICE_POD:/data/config -c configuration-service
kubectl exec -n keptn $CONFIG_SERVICE_POD -c configuration-service -- chmod +x -R ./data/config/reset-git-repos.sh
kubectl exec -n keptn $CONFIG_SERVICE_POD -c configuration-service -- ./data/config/reset-git-repos.sh
``` 

### Restore MongoDB data

Copy the content of the mongodb-backup directory you have created earlier into the pod running the MongoDB:

```console
MONGODB_POD=$(kubectl get pods -n keptn -lapp.kubernetes.io/name=mongo -ojsonpath='{.items[0].metadata.name}')
kubectl cp ./mongodb-backup/ keptn/$MONGODB_POD:/tmp/dump -c mongodb
```

Import the MongoDB dump into the database using the following command:

```console
MONGODB_ROOT_USER=$(kubectl get secret mongodb-credentials -n keptn -ojsonpath={.data.mongodb-root-user} | base64 -d)
MONGODB_ROOT_PASSWORD=$(kubectl get secret mongodb-credentials -n keptn -ojsonpath={.data.mongodb-root-password} | base64 -d)
kubectl exec svc/keptn-mongo -n keptn -- mongorestore --drop --preserveUUID --authenticationDatabase admin --username $MONGODB_ROOT_USER --password $MONGODB_ROOT_PASSWORD /tmp/dump
```

### Restore Git credentials

To re-establish the communication between the configuration-service and your projects' upstream repositories, restore the Kubernetes secrets you have previously stored in the `keptn-backup` directory , using `kubectl apply`:

```console
PROJECT_NAME=<project_name>
kubectl apply -f $PROJECT_NAME-credentials.yaml
```

After executing these steps, your projects and all events should be visible in the Keptn Bridge again.

## Restore Configuration Service data to Keptn using Resource Service

This section describes how to restore an acient data backup of the Configuration Service and apply it to a Keptn instance running a Resource Service. This can be applied only to projects which do not have a remote git upstream repository configured. The pre-requisities for these steps is to have the MongoDB data restored already.

The first step is to setup a remote git repository (e.g. on Github, Gitlab,...) for your project. Afterwards go to the project foler of your backup and execute:

```console
git remote add origin <your-git-repository-url>
git fetch origin
git push --all --force
```

The second step is to configure the remote git repository for your project. You can do it via Bridge UI or Keptn CLI with the commad:

```console
keptn update project PROJECTNAME --git-user=GIT_USER --git-token=GIT_TOKEN --git-remote-url=GIT_REMOTE_URL
```

After executing these steps, your project resources should be automatically fetched from the configured remote git repository and present in your local project repository folder.
