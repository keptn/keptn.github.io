---
title: Troubleshooting the installation
description: Choose the method to use to access Keptn
weight: 300
---

1. [Verify the Keptn installation](../../0.16.x/troubleshooting#verifying-a-keptn-installation).

1. [Generate a support-archive](../../0.16.x/reference/cli/commands/keptn_generate_support-archive) and ask for help in our [Slack channel](https://slack.keptn.sh).

1. Uninstall Keptn by executing the [keptn uninstall](../../0.16.x/reference/cli/commands/keptn_uninstall) command before conducting a re-installation.


You may run into issues that are caused by the way your Kubernetes cluster is set up and configured.
You should learn the basics of Kubernetes, and know about pods, deployments,
PVCs (Persistent Volume Claims), storage classes, ingress, and so forth.
You should also learn how to do basic Kubernetes troubleshooting.

If you cannot initialize your Keptn installation,
try running the following command:

```console
kubectl get pods -n keptn
```
If you see that some pods are pending or crashing,
use **kubectl** to check on the status of those pods.
A common problem is your PVC (Persistent Volume Claim) is not configured correctly
so nodes running services that need storage
(such as mongodb and the configuration-service)
cannot launch because they do not have access to storage.


