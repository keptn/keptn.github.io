---
title: Keptn with managed Istio (experimental)
description: Install Keptn on GKE with managed Istio
weight: 90
---

## Intallation Guide

In case you want to re-use an existing Istio installation on a Kubernetes cluster (e.g., GKE), we are providing a hidden flag `--istio-install-option=Reuse` starting with Keptn 0.6.1:

```console
keptn install --istio-install-option=Reuse --platform=gke
```

**Note 1**: This flag is experimental and a successful installation depends on the Istio version and 
 configuration that is used.

**Note 2**: This is an experimental feature and all corner cases cannot be covered. Any help in this regard is appreciated. In case of any issues, feel free to create a [new bug report](https://github.com/keptn/keptn/issues/new?assignees=&labels=bug&template=bug_report.md&title=) and provide as much debug information as possible.

## Detailed Installation Guide on GKE

When creating a new cluster on GKE, make sure to select the option "Enable Istio" (hidden in the Features tab). Please find out more details [on the official product page](https://cloud.google.com/istio/docs/istio-on-gke/installing) of GKE.

  {{< popup_image
  link="./assets/gke_istio.png"
  caption="GKE with existing istio">}}

Once the cluster has been created, please verify the istio version in use by executing

```console
$ kubectl get deployments -n istio-system -owide

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS                 IMAGES                                                                                                         SELECTOR
istio-citadel            1/1     1            1           32m   citadel                    gke.gcr.io/istio/citadel:1.2.10-gke.3                                                                          istio=citadel
istio-galley             1/1     1            1           32m   galley                     gke.gcr.io/istio/galley:1.2.10-gke.3                                                                           istio=galley
istio-ingressgateway     1/1     1            1           32m   istio-proxy                gke.gcr.io/istio/proxyv2:1.2.10-gke.3                                                                          app=istio-ingressgateway,istio=ingressgateway
istio-pilot              1/1     1            1           32m   discovery,istio-proxy      gke.gcr.io/istio/pilot:1.2.10-gke.3,gke.gcr.io/istio/proxyv2:1.2.10-gke.3                                      istio=pilot
istio-policy             1/1     1            1           32m   mixer,istio-proxy          gke.gcr.io/istio/mixer:1.2.10-gke.3,gke.gcr.io/istio/proxyv2:1.2.10-gke.3                                      istio=mixer,istio-mixer-type=policy
istio-sidecar-injector   1/1     1            1           32m   sidecar-injector-webhook   gke.gcr.io/istio/sidecar_injector:1.2.10-gke.3                                                                 istio=sidecar-injector
istio-telemetry          1/1     1            1           32m   mixer,istio-proxy          gke.gcr.io/istio/mixer:1.2.10-gke.3,gke.gcr.io/istio/proxyv2:1.2.10-gke.3                                      istio=mixer,istio-mixer-type=telemetry
```

**Note**: Keptn 0.6.1 is installing Istio in version 1.3.

After setting up the cluster you can install Keptn. Make sure to add the hidden option `--istio-install-option=Reuse` to the `keptn install` command and verify that the installation has worked using `keptn status`.

Afterwards you can continue with the [tutorials](../../usecases/) as usual.
