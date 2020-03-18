---
title: Setup Minikube
description: How to setup a Minikube cluster to be used for Keptn.
weight: 24
keywords: setup
---

## 1. Install local tools
  - [minikube 1.2](https://github.com/kubernetes/minikube/releases/tag/v1.2.0) (newer versions do not work).

## 2. Create Minikube VM

* Setup a Minikube VM with at least 6 CPU cores and 12 GB memory using:

```console
minikube stop # optional
minikube delete # optional
minikube start --cpus 6 --memory 12200
``` 

* Start the Minikube LoadBalancer service in a second terminal by executing:

```console
minikube tunnel 
``` 

## 3. Continue with Keptn installation

Now that the Minikube VM is set up, [continue with the Keptn installation](../../#2-install-keptn).
