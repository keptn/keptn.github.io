---
title: Troubleshooting
description: Find tips and tricks to deal with troubles that may occur when using Keptn. 
weight: 80
keywords: [troubleshooting]
---

In this section, instructions have been summarized that help to troubleshoot known issues that may occur when using Keptn.

## Verifying a Keptn installation
<details><summary>Expand instructions</summary>
<p>

- To verify your Keptn installation, retrieve the pods running in the `keptn` namespace.

  ```console
  kubectl get pods -n keptn
  ```

  ```console
  NAME                                                              READY     STATUS    RESTARTS   AGE
  api-5cfd44687-b2sqr                                               1/1       Running   0          34m
  bridge-54d65cd4c5-9hwsl                                           1/1       Running   0          34m
  configuration-service-75df569979-qvg8t                            1/1       Running   0          34m
  eventbroker-go-f44576fcb-z2ddv                                    1/1       Running   0          34m
  gatekeeper-service-6d5d798ccd-d442x                               1/1       Running   0          34m
  gatekeeper-service-evaluation-done-distributor-7556c87d9b-xbffs   1/1       Running   0          34m
  helm-service-596b4855b4-zkb77                                     1/1       Running   0          34m
  helm-service-configuration-change-distributor-58d97df957-2msfs    1/1       Running   0          34m
  helm-service-service-create-distributor-58584b6f7-4l9rr           1/1       Running   0          34m
  jmeter-service-7d9c654c9c-xgz7s                                   1/1       Running   0          34m
  jmeter-service-deployment-distributor-6dbd4858bf-v2stj            1/1       Running   0          34m
  keptn-nats-cluster-1                                              1/1       Running   0          34m
  lighthouse-service-6497f48947-vvs5g                               1/1       Running   0          34m
  lighthouse-service-get-sli-done-distributor-56896bb59c-d6tlp      1/1       Running   0          34m
  lighthouse-service-start-evaluation-distributor-5fb47dcfd-mklxx   1/1       Running   0          34m
  lighthouse-service-tests-finished-distributor-5dfc978bd4-7hl44    1/1       Running   0          34m
  nats-operator-7dcd546854-nhpm5                                    1/1       Running   0          34m
  prometheus-service-6db877499c-vvvg5                               1/1       Running   0          33m
  prometheus-service-monitoring-configure-distributor-5f789fvn69f   1/1       Running   0          33m
  prometheus-sli-service-66f8b8d86f-stgzr                           1/1       Running   0          33m
  prometheus-sli-service-monitoring-configure-distributor-675x5kp   1/1       Running   0          33m
  remediation-service-f6bbc48b5-g47kt                               1/1       Running   0          34m
  remediation-service-problem-distributor-79885bd957-nz74j          1/1       Running   0          34m
  servicenow-service-7cd9b8784-xxj7z                                1/1       Running   0          33m
  servicenow-service-problem-distributor-666fbf4b6-l62dj            1/1       Running   0          33m
  shipyard-service-565b96cb9c-mz2cl                                 1/1       Running   0          34m
  shipyard-service-create-project-distributor-c65b7c677-nkmnk       1/1       Running   0          34m
  shipyard-service-delete-project-distributor-55b86db7b-kd28z       1/1       Running   0          34m
  wait-service-7b4d74b4d9-b4lk7                                     1/1       Running   0          34m
  wait-service-deployment-distributor-55cd8fc655-n5px7              1/1       Running   0          34m
  openshift-route-service-57b45c4dfc-4x5lm                          1/1       Running   0          32s (OpenShift only)
  openshift-route-service-create-project-distributor-7d4454cs44xp   1/1       Running   0          33s (OpenShift only)
  ```

- In the `keptn-datastore` namespace, you should see the following pods:

  ```console
  kubectl get pods -n keptn-datastore
  ```

  ```console
  NAME                                             READY   STATUS    RESTARTS   AGE
  mongodb-7d956d5775-mkxv5                         1/1     Running   0          5m16s
  mongodb-datastore-d65b468d7-tmwfm                1/1     Running   0          5m14s
  mongodb-datastore-distributor-6cc947d554-tn6kr   1/1     Running   0          5m7s
  ```

- To verify the Istio installation, retrieve all pods within the `istio-system` namespace and check whether they are running:

  ```console
  kubectl get pods -n istio-system
  ```

  ```console
  NAME                                      READY     STATUS    RESTARTS   AGE
  istio-citadel-6c456d967c-bpqbd            1/1     Running     0          6m
  istio-cleanup-secrets-1.2.5-22gts         0/1     Completed   0          6m
  istio-ingressgateway-5d49795589-tfl4k     1/1     Running     0          6m
  istio-init-crd-10-rzlf7                   0/1     Completed   0          6m
  istio-init-crd-11-chvzr                   0/1     Completed   0          6m
  istio-init-crd-12-8zvn4                   0/1     Completed   0          6m
  istio-pilot-79b78c894b-zsz5j              2/2     Running     0          6m
  istio-security-post-install-1.2.5-glswk   0/1     Completed   0          6m
  istio-sidecar-injector-bcf445789-gkfjf    1/1     Running     0          6m
  ```
</p></details>

## Installation on Azure aborts
<details><summary>Expand instructions</summary>
<p>

**Investigation:**

The Keptn installation is aborting with the following error:

```console
Cannot obtain the cluster/pod IP CIDR
```

**Reason:** 

The root cause of this issue is that `kubenet` is not used in your AKS cluster. However, it is needed to retrieve the `podCidr` according to the official docs: https://docs.microsoft.com/en-us/rest/api/aks/managedclusters/createorupdate#containerservicenetworkprofile 

**Solution:** 

Please select the **Kubenet network plugin (basic)** when setting up your AKS cluster, instead of *Azure network plugin (advanced)* and retry the installation. You can find more information here: https://docs.microsoft.com/en-us/azure/aks/configure-kubenet 

</p></details>
