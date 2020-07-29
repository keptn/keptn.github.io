---
title: Uninstall Keptn
description: Uninstall Keptn from a Kubernetes cluster.
weight: 10
keywords: [0.7.x-operate]
---

## Prerequisites
- [keptn CLI](../install/#install-keptn-cli)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Uninstall Keptn

- To uninstall Keptn from your cluster, run the uninstall command using the Keptn CLI:

``` console
keptn uninstall
``` 

- To verify the cleanup, retrieve the list of namespaces in your cluster and ensure that the **keptn** namespace is not included in the output of the following command:

```console
kubectl get namespaces
```
