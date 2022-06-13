---
title: Uninstall
description: Uninstall
weight: 5
icon: setup
---

## Uninstall the Dynatrace Keptn integration

To uninstall the *dynatrace-service*, use the Helm CLI to delete the release of the service:

```console
helm delete -n keptn dynatrace-service
```

Note, this command only removes the Dynatrace integration into Keptn. Other components, such as the Dynatrace OneAgent on Kubernetes will be unaffected.

## Uninstall OneAgent Operator

To remove Dynatrace monitoring on your Kubernetes cluster, please follow the official Dynatrace documentation on [uninstalling OneAgent Operator](https://www.dynatrace.com/support/help/shortlink/kubernetes-manage-helm#uninstall-oneagent-operator).
