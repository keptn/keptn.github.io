---
title: Backup and restore Keptn
description: How to backup and restore Keptn.
weight: 20
keywords: backup
---

To secure all your data in your project's git repositories, as well as all events that have occurred for these project, you need to 
back up the data within the Configuration Service, the MongoDB and - if you have configured those - credentials to your project's git upstream repos.
The following sections describe how to back up that data and store it on your local machine.
**NOTE:** These instructions do not cover backing up any Helm- or Istio-related configurations.

## Backup Configuration Service

First, create a local backup directory containing all data within the git repos of the configuration-service. To do so, please execute the following command:

```console
mkdir keptn-backup
cd keptn-backup
mkdir config-svc-backup
CONFIG_SERVICE_POD=$(kubectl get pods -n keptn -lrun=configuration-service -ojsonpath='{.items[0].metadata.name}')
kubectl cp keptn/$CONFIG_SERVICE_POD:/data ./config-svc-backup/ -c configuration-service
```

Verify that the data has been copied correctly to your local machine by checking the content of the directory you just created. 
This should include all projects you have onboarded with Keptn, as well as a `lost+found` directory, which can be ignored.

```console
$ ls config-svc-backup/config
lost+found	sockshop my-project
```

## Backup Mongodb Data

The next step is to create a backup of the mongodb database in the `keptn-datastore` namespace using the `mongodump` tool.
NOTE: this tool will be executed within the pod running the MongoDB, so you do not need to have it installed locally.

Create a directory for the MongoDB backup:

```console
mkdir mongodb-backup
chmod o+w mongodb-backup
```

Copy the data from the MongoDB to your local directory:

```console
kubectl exec svc/mongodb -n keptn-datastore -- mongodump --uri="mongodb://user:password@localhost:27017/keptn" --out=./dump

MONGODB_POD=$(kubectl get pods -n keptn-datastore -lname=mongodb -ojsonpath='{.items[0].metadata.name}')
kubectl cp keptn-datastore/$MONGODB_POD:dump ./mongodb-backup/ -c mongodb
```

## Backup Git credentials

For projects where you have configured a Git upstream repository, we advise to backup the Kubernetes secrets needed to access those.
To do so, please execute the following command **for each project** for which you have configured an upstream repo:

```console
PROJECT_NAME=<project-name>
kubectl get secret -n keptn git-credentials-$PROJECT_NAME -oyaml > $PROJECT_NAME-credentials.yaml
```

# Restore Keptn

This section describes how to restore the projects of a previous Keptn installation using the data you have stored on your machine using the instructions above.

## Restore Configuration Service

Copy the directory containing all git repositories to the configuration-service

```console
CONFIG_SERVICE_POD=$(kubectl get pods -n keptn -lrun=configuration-service -ojsonpath='{.items[0].metadata.name}')
kubectl cp ./config-svc-backup/* keptn/$CONFIG_SERVICE_POD:/data -c configuration-service
```

To make sure the git repositories within the configuration service are in a consistent state, they need to be reset to the current HEAD. To do so, 
please execute the following commands:

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

CONFIG_SERVICE_POD=$(kubectl get pods -n keptn -lrun=configuration-service -ojsonpath='{.items[0].metadata.name}')
kubectl cp ./reset-git-repos.sh keptn/$CONFIG_SERVICE_POD:/ -c configuration-service
kubectl exec -n keptn $CONFIG_SERVICE_POD -c configuration-service -- chmod +x -R ./reset-git-repos.sh
kubectl exec -n keptn $CONFIG_SERVICE_POD -c configuration-service -- ./reset-git-repos.sh
``` 

## Restore MongoDB data

Copy the content of the mongodb-backup directory you have created earlier into the pod running the MongoDB:

```console
MONGODB_POD=$(kubectl get pods -n keptn-datastore -lname=mongodb -ojsonpath='{.items[0].metadata.name}')
kubectl cp ./mongodb-backup/ keptn-datastore/$MONGODB_POD:dump -c mongodb
```

Import the MongoDB dump into the database using the following command:

```console
kubectl exec svc/mongodb -n keptn-datastore -- mongorestore --host localhost:27017 --username user --password password --authenticationDatabase keptn ./dump
```


## Restore Git credentials

To re-establish the communication between the configuration-service and your project's upstream repositories, restore the K8s secrets
you have previously stored in the `keptn-backup` directory , using `kubectl apply`:

```console
PROJECT_NAME=<project-name>
kubectl apply -f $PROJECT_NAME-credentials.yaml
```

After executing these steps, your projects and all events should be visible in the Keptn's Bridge again.



