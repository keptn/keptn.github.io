---
title: Setup GKE
description: How to setup a GKE cluster to be used for keptn.
weight: 22
keywords: setup
---

## 1. Install local tools
  - [gcloud](https://cloud.google.com/sdk/gcloud/)
  - [python 2.7](https://www.python.org/downloads/release/python-2716/) (required for Ubuntu 19.04)

## 2a. Create a GKE cluster through Cloud Console
  - Master version: Default
  - Machine type: One `n1-standard-4` node
  - Image type: `ubuntu` or `cos` (For Dynatrace monitoring, select Ubuntu)
  - Disable `auto-upgrade` and `Enable VPC-native (using alias IP)` 

## 2b. Create a GKE cluster through gcloud cli
```console
// set environment variables
PROJECT=nameofgcloudproject
CLUSTER_NAME=nameofcluster
ZONE=us-central1-a
REGION=us-central1
GKE_VERSION="1.13.11-gke.9 (default)"
```

```console
gcloud beta container --project $PROJECT clusters create $CLUSTER_NAME --zone $ZONE --no-enable-basic-auth --cluster-version $GKE_VERSION --machine-type "n1-standard-4" --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --no-enable-ip-alias --network "projects/$PROJECT/global/networks/default" --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --no-enable-autoupgrade
```