---
title: Setup GKE
description: How to setup a GKE cluster to be used for Keptn.
weight: 22
keywords: setup
---

## 1. Sign up for Google Cloud Platform
Run your Keptn installation for free on GKE!
If you sign up for a Google Cloud account, Google gives you an initial $300 credit. For deploying Keptn you can apply for an additional $200 credit which you can use towards that GKE cluster needed to run Keptn.<br><br>
<a class="button button-primary" href="http://bit.ly/keptnongke" target="_blank">Sign up here</a>



## 2. Install local tools
  - [gcloud](https://cloud.google.com/sdk/gcloud/)
  - [python 2.7](https://www.python.org/downloads/release/python-2716/) (required for Ubuntu 19.04)

## 3a. Create GKE cluster through Cloud Console
  - Master version >= `1.11.x` (`1.12.8-gke.10`)
  - One `n1-standard-4` node
  - Image type `ubuntu` or `cos` (if you plan to use Dynatrace monitoring, select `ubuntu` for a more [convenient setup](../../monitoring/dynatrace/))
  - Sample script to create such cluster (adapt the values according to your needs)

## 3b. Create through gcloud cli
```console
// set environment variables
PROJECT=nameofgcloudproject
CLUSTER_NAME=nameofcluster
ZONE=us-central1-a
REGION=us-central1
GKE_VERSION="1.12.8-gke.10"
```

```console
gcloud beta container --project $PROJECT clusters create $CLUSTER_NAME --zone $ZONE --no-enable-basic-auth --cluster-version $GKE_VERSION --machine-type "n1-standard-4" --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --no-enable-ip-alias --network "projects/$PROJECT/global/networks/default" --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --no-enable-autoupgrade
```

## 4. Continue with Keptn installation

Now that the cluster is set up, [continue with the Keptn installation](../../#2-install-keptn)