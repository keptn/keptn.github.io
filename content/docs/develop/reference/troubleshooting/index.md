---
title: Troubleshooting
description: Find tips and tricks to deal with troubles that may occur when using Keptn. 
weight: 80
keywords: [troubleshooting]
---

In this section, instructions are summarized that help to trouble shoot known issues that may occur when using Keptn.

## Verifying a Keptn installation
<details><summary>Expand instructions</summary>
<p>

- To verify your Keptn installation, retrieve the pods running in the `keptn` namespace.

  ```console
  kubectl get pods -n keptn
  ```

  ```console
  NAME                                                              READY     STATUS    RESTARTS   AGE
  api-55b57db797-8kgxd                                              1/1       Running   0          2m
  bridge-6fc5bd679b-745fz                                           1/1       Running   0          2m
  configuration-service-845997dd7d-sf5f6                            1/1       Running   0          2m
  eventbroker-go-68d5f9d789-pp7n4                                   1/1       Running   0          2m
  gatekeeper-service-6469d5f4f7-96cjl                               1/1       Running   0          2m
  gatekeeper-service-evaluation-done-distributor-5b5f77c6ff-pf8hb   1/1       Running   0          2m
  helm-service-569dc7d48f-dzs6n                                     1/1       Running   0          2m
  helm-service-configuration-change-distributor-55ddcdbc94-6v8jj    1/1       Running   0          2m
  helm-service-service-create-distributor-7896c55ccf-fn8cj          1/1       Running   0          2m
  jmeter-service-57c9d4d999-mfxlr                                   1/1       Running   0          2m
  jmeter-service-deployment-distributor-687b778dfd-hvd8q            1/1       Running   0          2m
  keptn-nats-cluster-1                                              1/1       Running   0          2m
  nats-operator-67d8dd94d5-7929b                                    1/1       Running   0          2m
  pitometer-service-775dfb4bf4-6bqqm                                1/1       Running   0          2m
  pitometer-service-tests-finished-distributor-785bdc79d4-xgwdd     1/1       Running   0          2m
  prometheus-service-5d84cd45df-kcft8                               1/1       Running   0          4m
  prometheus-service-monitoring-configure-distributor-5f4f9f54jks   1/1       Running   0          4m
  remediation-service-a7pysw4bb-q0mzk                               1/1       Running   0          4m
  remediation-service-problem-distributor-u2dfa5f5cfb-8n8cb         1/1       Running   0          4m
  servicenow-service-64cb58c879-f868m                               1/1       Running   0          4m
  servicenow-service-problem-distributor-6d4fc577d9-8b97g           1/1       Running   0          4m
  shipyard-service-58b5d5df74-2k8d5                                 1/1       Running   0          3m
  shipyard-service-create-project-distributor-5d56b4fcfd-6hmt6      1/1       Running   0          3m
  wait-service-d749fc4bb-qzfzk                                      1/1       Running   0          3m
  wait-service-deployment-distributor-7cd55f5cfb-7f7cb              1/1       Running   0          2m
  openshift-route-service-57b45c4dfc-4x5lm                          1/1       Running   0          33s (OpenShift only)
  openshift-route-service-create-project-distributor-7d4454cs44xp   1/1       Running   0          33s (OpenShift only)
  ```

- In the `keptn-datastore` namespace, you should see the following pods:

  ```console
  kubectl get pods -n keptn-datastore
  ```

  ```console
  NAME                                             READY   STATUS    RESTARTS   AGE
  fluent-bit-s8drm                                 1/1     Running   0          5m14s
  mongodb-7d956d5775-mkxv5                         1/1     Running   0          5m16s
  mongodb-datastore-d65b468d7-tmwfm                1/1     Running   0          5m14s
  mongodb-datastore-distributor-6cc947d554-tn6kr   1/1     Running   0          5m7s
  ```

- To verify the Istio installation, retrieve all pods within the `istio-system` namespace and check whether they are in a running state:

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
