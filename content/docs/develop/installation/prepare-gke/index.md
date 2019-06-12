---
title: Prepare GKE cluster
description: How to setup a GKE cluster for keptn.
weight: 20
icon: setup
keywords: setup
---

## Install local tools
- [gcloud](https://cloud.google.com/sdk/gcloud/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Create GKE cluster
- Master version >= `1.11.x` (tested version: `1.11.7-gke.12` and `1.12.7-gke.10`)
- One `n1-standard-16` node
  <details><summary>Expand for details</summary>
  {{< popup_image link="./assets/gke-cluster-size.png" 
    caption="GKE cluster size">}}
  </details>
- Image type `ubuntu` or `cos` (if you plan to use Dynatrace monitoring, select `ubuntu` for a more [convenient setup](../../monitoring/dynatrace/))
- Sample script to create such cluster (adapt the values according to your needs)

  ```console
  // set environment variables
  PROJECT=nameofgcloudproject
  CLUSTERNAME=nameofcluster
  ZONE=us-central1-a
  REGION=us-central1
  GKEVERSION="1.12.7-gke.10"
  ```

  ```console
  gcloud beta container --project $PROJECT clusters create $CLUSTERNAME --zone $ZONE --no-enable-basic-auth --cluster-version $GKEVERSION --machine-type "n1-standard-16" --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --no-enable-ip-alias --network "projects/$PROJECT/global/networks/default" --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --no-enable-autoupgrade
  ```

## Install keptn 

To install keptn, please continue [here](../setup-keptn/).