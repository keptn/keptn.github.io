---
title: Install Keptn manually
description: Install Keptn manually on your Kubernetes cluster (deprecated in 0.17.x)
weight: 45
---

Keptn consists of a **Control Plane** and an **Execution Plane**:
In release 0.17.x, this must be done using the [Helm chart](../helm-install).
In earlier releases, this could instead be done manually using the **keptn install** commands.
Those instructions are retained here for reference.

* The **Control Plane** allows using Keptn for the [Quality Gates](../../concepts/quality_gates/)
and [Automated Operations](../../concepts/automated_operations/) use cases. To install the control plane containing the components for *quality gates* and *automated operations*, execute:

    ```console
    helm repo add keptn https://charts.keptn.sh
    helm repo update
    helm install keptn keptn/keptn -n keptn --version=$KeptnVersion
    ```

  where, `$KeptnVersion` is the version of Keptn you want to install.

* The **Control Plane with the Execution Plane (for Continuous Delivery)** allows to implement [Continuous Delivery](../../concepts/delivery/) on top of *quality gates* and *automated operations* use cases. Please not that for this use-case [Istio](https://istio.io) is required as well, as this is used for traffic routing between blue/green versions during deployment. To install the control plane with the execution plane for continuous delivery, execute:

    ```
    helm repo add keptn https://charts.keptn.sh
    helm repo update
    helm install keptn keptn/keptn -n keptn --version=$KeptnVersion --create-namespace --set=continuous-delivery.enabled=true
    ```

 where, `$KeptnVersion` is the version of Keptn you want to install.
