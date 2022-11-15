---
title: Troubleshooting the installation
description: Tips for troubleshooting installation problems.
weight: 300
---

1. [Generate a support-archive](../../0.19.x/reference/cli/commands/keptn_generate_support-archive) and ask for help in our [Slack channel](https://slack.keptn.sh).

1. Uninstall Keptn by executing the [keptn uninstall](../../0.19.x/reference/cli/commands/keptn_uninstall) command before conducting a re-installation.

## Keptn API cannot be reached

Occasionally (most often after a new Keptn installation),
the Keptn API cannot be reached, which also means that the Keptn CLI does not work.
To solve this problem, try to restart the `api-gateway-nginx` pod by executing:

```
kubectl delete pods -n keptn --selector=run=api-gateway-nginx
```

## Verify Kubernetes context

To verify that you are connected to the correct cluster
before performing critical operations
such as installing new Keptn services or upgrading a service or Keptn itself,
execute the following to get the Keptn endpoint:

```
keptn status
```

```
Starting to authenticate
Successfully authenticated
CLI is authenticated against the Keptn cluster http://xx.xx.xx.xx.nip.io/api
```

## Verify a Keptn installation

The first step for troubleshooting a Keptn installation
is to verify that all parts of the Keptn installation are running as intended,
meaning that all distributors and pods are running.
To do this, run the following command:

```
kubectl get pods -n keptn
```

```
NAME                                                              READY   STATUS    RESTARTS   AGE
api-gateway-nginx-5669667d4f-2ppg9                                1/1     Running   0          20s
api-service-5b846f4d5b-trmbp                                      1/1     Running   0          28s
bridge-6dcc7cc967-hfvdv                                           1/1     Running   0          21s
configuration-service-589fbfb7d9-2rrmv                            2/2     Running   2          30s
eventbroker-go-7d9bbd5b88-84lgf                                   1/1     Running   0          31s
gatekeeper-service-58d89b6c79-bxzsv                               2/2     Running   2          31s
helm-service-67c6fff6d-qxhsj                                      2/2     Running   0          23s
helm-service-continuous-deployment-distributor-7c4455d697-gwwgj   1/1     Running   3          30s
jmeter-service-5444cc4968-v559v                                   2/2     Running   2          30s
keptn-nats-cluster-0                                              3/3     Running   0          28s
lighthouse-service-65ff48dc57-6hdvx                               2/2     Running   2          30s
mongodb-59975d9f4c-nn5c2                                          1/1     Running   0          26s
mongodb-datastore-7fdb567996-lgjj8                                2/2     Running   2          33s
remediation-service-56777cb979-957l4                              2/2     Running   2          33s
shipyard-service-57c6996f47-pzs9r                                 2/2     Running   2          34s
openshift-route-service-57b45c4dfc-4x5lm                          2/2     Running   0          32s (OpenShift only)
```

If you see that some pods are pending or crashing,
use the following command to check on the status of those pods
and see whether the problem is caused by low resources such as disk space:

```
kubectl describe pod PODID -n keptn
```

## Check resources

You may run into issues that are caused by the way your Kubernetes cluster is set up and configured.
You should learn the basics of Kubernetes, and know about pods, deployments,
PVCs (Persistent Volume Claims), storage classes, ingress, and so forth.
You should also learn how to do basic Kubernetes troubleshooting.

### Kubernetes resources

You can analyze the pods that are failing with general Kubernetes diagnostics,
especially viewing the log files.
Common problems are:

* Persistent Volume Claims (PVCs) do not have enough storage capacity.
  If your PVC is not configured correctly or is not large enough,
  nodes running services that need storage (such as `mongodb` and the `configuration-service`)
  cannot launch because they do not have access to storage.
  Most Kubernetes clusters need at least 20GB to 30GB of storage
  and may need more depending on the projects and services you are running.
* Inadequate CPUs and/or memory.
  This can lead to timeouts during startup.

### Docker resources

When running a basic Keptn instance with k3d,
ensure that your local k3d environment has enough resources.
You can verify this in your Docker resource settings.
The resources required to run Keptn are determined by the projects and services that you run.
We have used the following configuration to run a basic Keptn installation
with a small project for study and demonstration purposes:
<details><summary>Resources</summary>
![docker resources](./assets/docker-resources.png)
</details>

## Fully Qualified Domain Names cannot be reached from within the cluster

Depending on your Kubernetes cluster configuration,
certain hostnames cannot be reached from within the Kubernetes cluster.
This is usually visible via an error message that looks as follows:
```
Failed to send cloudevent:, Post http://event-broker.keptn.svc.cluster.local/keptn: dial tcp: lookup event-broker.keptn.svc.cluster.local: Try again
```

The problem can appear in virtually any service and scenario:

* LoadGenerator for keptn/examples
* Prometheus-Service/Prometheus-SLI-Service trying to access Prometheus
* Dynatrace-Service trying to access a Dynatrace environment
* Unleash-Service trying to access Unleash
* Any keptn-service trying to send a CloudEvent via the event-broker

<details><summary>Expand instructions</summary>
<p>


**Problem**: Trying to access certain hostnames does not work within the cluster.

The reason behind this is that some Kubernetes cluster configurations have issues
when it comes to resolving internal hostnames like `service.namespace.svc.cluster.local`,
but potentially reaching ANY hostname might fail, e.g., trying to fetch a URL via `wget keptn.sh`.

**Analysis**: To find out whether you are affected or not,
run an `alpine:3.11` container that tries to access the Kubernetes API or any external hostname, e.g.:

```
kubectl run -i --restart=Never --rm test-${RANDOM} --image=alpine:3.11 \
   -- sh -c "wget --no-check-certificate \
   https://kubernetes.default.svc.cluster.local/api/v1"
```

```
kubectl run -i --restart=Never --rm test-${RANDOM} --image=alpine:3.11 \
   -- sh -c "wget https://keptn.sh"
```

If in any of the above instances you get a "bad address", then you are most likely affected, e.g.:
```
wget: bad address 'kubernetes.default.svc.cluster.local'
```

If it prints a download bar, the content of the requested URL or an HTTP 400 error (or similar),
the connection works, e.g.:
```
Connecting to kubernetes.default.svc.cluster.local (10.0.80.1:443)
saving to 'v1'
v1                   100% |********************************| 10337  0:00:00 ETA
```

The problem behind this is usually a misconfiguration for the nameserver
or the local `/etc/resolv.conf` configuration (e.g., searchdomains).

More details can be found at
[GitHub Kubernetes Issue #64924](https://github.com/kubernetes/kubernetes/issues/64924).

**Solutions**:

1. Verify that your cluster's nameserver configuration is working as expected,
   especially the searchdomains. The easiest way to verify this is to look at the output of
   ```
   nslookup keptn.sh
   ```
   on your physical machine as well as within your Kubernetes cluster:
   ```
   kubectl run -i --restart=Never --rm test-${RANDOM} \
      --image=alpine:3.11 -- sh -c "nslookup keptn.sh"
   ```
   * If a nameserver returns `NXDOMAIN` or `Non-authoritative answer`, everything is fine.
   * If at any point a nameserver returns an `ERRFAIL`, `SERVFAIL` or similar,
     update the hosts `/etc/resolv.conf` file (together with your administrator) and try again.

1. Overwrite the DNS config `ndots` to `ndots:1`
  [in all deployment manifests](https://pracucci.com/kubernetes-dns-resolution-ndots-options-and-why-it-may-affect-application-performances.html).

</p></details>
~      

## MongoDB fails on OpenShift

<details><summary>Expand instructions</summary>
<p>

**Reason:**

The root cause of this issue is that the MongoDB (as deployed by the default Keptn installation)
tries to set `mongodb` as the owner for the files in `/var/lib/mongodb/data`.
However, this is not allowed for some Persistent Volumes Claims (PVCs) with the assigned rights.

**Solution:**

Execute the following command to change the image of the `mongodb` deployment to run `mongodb` as root:

```
kubectl set image deployment/mongodb \
   mongodb=keptn/mongodb-privileged:latest -n keptn
```
</p></details>

## Installation aborts on Azure
<details><summary>Expand instructions</summary>
<p>

**Investigation:**

The Keptn installation aborts with the following error:

```
Cannot obtain the cluster/pod IP CIDR
```

**Reason:**

The root cause of this issue is that `kubenet` is not used in your AKS cluster.
However, it is needed to retrieve the `podCidr` according to the official docs:
https://docs.microsoft.com/en-us/rest/api/aks/managedclusters/createorupdate#containerservicenetworkprofile

**Solution:**

Select the **Kubenet network plugin (basic)** when setting up your AKS cluster
rather than the *Azure network plugin (advanced)* and retry the installation.
You can find more information at https://docs.microsoft.com/en-us/azure/aks/configure-kubenet

</p></details>




