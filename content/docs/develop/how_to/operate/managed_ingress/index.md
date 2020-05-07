---
title: Keptn with pre-installed Istio/NGINX (experimental)
description: Explains how to install Keptn with a pre-installed/managed Istio/NGINX installation.
weight: 90
---

## Intallation Guide

In case you want to re-use an existing Istio installation for the [full Keptn installation](../../installation/setup-keptn)
or re-use an existing NGINX installation for the [quality gates Keptn installation](../../usecases/quality-gates),
the Keptn CLI provides a hidden  flag `--ingress-install-option=Reuse` starting with Keptn 0.6.1:

```console
keptn install --ingress-install-option=Reuse --platform=gke
``` 
or 
```console
keptn install --ingress-install-option=Reuse --use-case=quality-gates --platform=gke
```

**Please note**: This flag is experimental, and a successful installation heavily depends on the Istio/NGINX version and 
 configuration that is used.

## Detailed Installation Guide for pre-installed Istio on GKE

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

**Note**: A default Keptn 0.6.1 and 0.6.2 installation would have installed Istio in version 1.3.

After setting up the cluster you can install Keptn. Make sure to add the hidden option `--ingress-install-option=Reuse` 
 to the `keptn install` command and verify that the installation has worked using `keptn status`.

Afterwards you can continue with the [tutorials](../../usecases/) as usual.

Please note that this is an experimental feature and we cannot cover all corner-cases. Any help in this regard is appreciated.
In case of any issues, feel free to create a [new bug report](https://github.com/keptn/keptn/issues/new?assignees=&labels=bug&template=bug_report.md&title=)
and provide as much debug information as possible.
