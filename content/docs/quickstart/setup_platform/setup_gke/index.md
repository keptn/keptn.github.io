---
title: Setup GKE
description: How to setup a GKE cluster to be used for Keptn.
weight: 22
keywords: setup
---

<div class="promo section-primary">
  <div class="container pt-1 pb-1 text-center">
    <div class="row pt-md-5 pb-md-5">
      <div class="col-12 col-md-12 col-lg-12">
        Keptn loves <strong>Google Kubernetes Engine</strong> and so do they.
        <br>
        Sign up via Keptn and get an extra <strong>$200</strong> in <strong>Google Cloud Platform</strong> credit.
        <br><br>
        <a class="button button-secondary" href="http://bit.ly/keptnongke" target="_blank">Sign up and use Keptn in GKE</a>
        
      </div>
    </div>
  </div>
</div>

## 1. Install local tools
  - [gcloud](https://cloud.google.com/sdk/gcloud/)
  - [python 2.7](https://www.python.org/downloads/release/python-2716/) (required for Ubuntu 19.04)

## 2a. Create GKE cluster through Cloud Console
  - Master version >= `1.11.x` (`1.12.8-gke.10`)
  - One `n1-standard-4` node
  - Image type `ubuntu` or `cos` (if you plan to use Dynatrace monitoring, select `ubuntu` for a more [convenient setup](../../monitoring/dynatrace/))
  - Sample script to create such cluster (adapt the values according to your needs)

## 2b. Create through gcloud cli
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