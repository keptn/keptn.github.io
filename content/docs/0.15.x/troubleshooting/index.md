---
title: Troubleshooting
description: Find tips and tricks to deal with troubles that may occur when using Keptn. 
weight: 100
icon: help
---

In this section, instructions have been summarized that help to troubleshoot known issues that may occur when using Keptn.

## Generating a Support Archive

The Keptn CLI allows to generate a support archive, which can be used as data source for debugging a Keptn installation.
For generating a support archive, please checkout the CLI command [keptn generate support-archive](../reference/cli/commands/keptn_generate_support-archive).

## Keptn API cannot be reached

In rare cases (but especially after a new Keptn installation), the Keptn API cannot be reached.
This prevents e.g. a successful communication between the Keptn CLI and the Keptn API.
In order to solve this problem, please try to restart the `api-gateway-nginx` pod by executing:

```console
kubectl delete pods -n keptn --selector=run=api-gateway-nginx
```

## Verifying a Keptn installation

Especially for troubleshooting purposes, it is necessary to verify that all parts of the Keptn installation are running as intended (i.e., no crashed pods, all distributors running).

<details><summary>Expand instructions</summary>
<p>

- To verify your Keptn installation, retrieve the pods running in the `keptn` namespace.

```console
kubectl get pods -n keptn
```

```console
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

</p></details>

## MongoDB on OpenShift 4 fails

<details><summary>Expand instructions</summary>
<p>

**Reason:**

The root cause of this issue is that the MongoDB (as deployed by the default Keptn installation) tries to set `mongodb` as the owner for the files in `/var/lib/mongodb/data`. However, this is not allowed for some Persistent Volumes (PVs) with the assigned rights.

**Solution:**

Please execute the following command to change the image of the `mongodb` deployment to run `mongodb` as root:

```console
kubectl set image deployment/mongodb mongodb=keptn/mongodb-privileged:latest -n keptn
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

The root cause of this issue is that `kubenet` is not used in your AKS cluster. However, it is needed to retrieve the `podCidr` according to the official docs: <https://docs.microsoft.com/en-us/rest/api/aks/managedclusters/createorupdate#containerservicenetworkprofile>

**Solution:**

Please select the **Kubenet network plugin (basic)** when setting up your AKS cluster, instead of *Azure network plugin (advanced)* and retry the installation. You can find more information here: <https://docs.microsoft.com/en-us/azure/aks/configure-kubenet>

</p></details>

## Broken Keptn project

When creating a project failed, this can cause a problematic state that manifests in a situation that the Keptn Bridge does not show any project.

<details><summary>Expand instructions</summary>
<p>

**Situation**: Executing [keptn create project](../reference/cli/commands/keptn_create_project) failed with following error message:

```console
Starting to create project   
ID of Keptn context: 9d1a30cd-e00b-4354-a308-03e50368bc40  
Creating project sockshop failed. Could not commit changes.
```

**Problem**: The Keptn Bridge does not show any project even though other projects were already displayed.

**Solution**:

- Try to execute the command [keptn delete project](../reference/cli/commands/keptn_delete_project):

- If the command did not work, manually delete the faulty project in the `configuration-service` pod.

    1. Connect to the pod of `configuration-service`:

    ```console
    kubectl -n keptn exec -it svc/configuration-service sh`
    ```

    1. In the pod, go to: `/data/config/`

    1. Delete the directory with the name of the faulty project:

    ```console
    rm -rf projectXYZ 
    ```

</p></details>

## Error: UPGRADE FAILED: timed out waiting for the condition

This error often appears when executing `keptn send trigger delivery` in case of insufficient CPU and/or memory on the Kubernetes cluster.

<details><summary>Expand instructions</summary>
<p>

**Investigation:**

The Helm upgrade runs into a time-out when deploying a new artifact of your service using

```console
keptn trigger delivery
```

**Reason:**

In this case, Helm creates a new Kubernetes Deployment with the new artifact, but Kubernetes fails to start the pod.
Unfortunately, there is no way to catch this error by Helm (right now). A good way to detect the error is to look at the Kubernetes events captured by the cluster:

```console
kubectl -n sockshop-dev get events  --sort-by='.metadata.creationTimestamp'
```

where `sockshop-dev` is the project and stage that you are trying to deploy to.

*Note*: This error can also occur at a later stage (e.g., when using blue-green deployments).

**Solution:**

Increase the number of vCPUs and/or memory, or add another Kubernetes worker node.

</p></details>

## Helm upgrade runs into a time-out on EKS

Same as the error above, but this issue occurs sometimes using a *single* worker node on EKS.

**Solution:**

Increase the number of worker nodes. For example, you can therefore use the `eksctl` CLI:
<https://eksctl.io/usage/managing-nodegroups/>

## Deployment failed: no matches for kind "DestinationRule" in version "networking.istio.io/v1alpha3"

This error can appear after triggering a delivery (e.g., `keptn trigger delivery --project=sockshop --service=carts-db ...`):

```
Error when installing/upgrading chart sockshop-dev-carts-db-generated in namespace sockshop-dev: 
unable to build kubernetes objects from release manifest: [unable to recognize "": no matches for kind "DestinationRule" in version "networking.istio.io/v1alpha3", unable to recognize "": no matches for kind "VirtualService" in version "networking.istio.io/v1alpha3"]
```

<details><summary>Expand instructions</summary>
<p>

**Investigation:**

`helm-service` triggers a helm upgrade when deploying a new artifact of the respective service. However, the upgrade fails with the aforementioned error message displayed in Keptn Bridge.

**Reason:**

In this case, Helm applies the Kubernetes manifests shipped with the new artifact on the Kubernetes cluster, but Kubernetes fails to find the resources `"DestinationRule"` and `"VirtualService"` which are part of Istio.
Most likely Istio is not installed on your Kubernetes cluster.

**Solution:**

Install Istio as described in the [Continuous Delivery section](../continuous_delivery/expose_services).

</p></details>

## Verify Kubernetes Context with Keptn Installation

If you are performing critical operations, such as installing new Keptn services or upgrading something, please verify
that you are connected to the correct cluster.

- Execute `keptn status` to get the Keptn endpoint:

```console
keptn status
```

```console
Starting to authenticate
Successfully authenticated
CLI is authenticated against the Keptn cluster http://xx.xx.xx.xx.nip.io/api
```

## NGNIX troubleshooting

If a CLI command like, e.g., `keptn add resource` fails with the following error message:

```
$ keptn add-resource --project=sockshop --service=carts --stage=production --resource=remediation.yaml

Adding resource remediation.yaml to service carts in stage production in project sockshop
Error: Resource remediation.yaml could not be uploaded: invalid character '<' looking for beginning of value
-----DETAILS-----<html>
<head><title>502 Bad Gateway</title><script type="text/javascript" src="/ruxitagentjs_ICA2SVfqru_10191200423105232.js" data-dtconfig="rid=RID_470209891|rpid=-713832838|domain=api.keptn|reportUrl=/rb_bf35021xvs|app=ea7c4b59f27d43eb|featureHash=ICA2SVfqru|rdnt=1|uxrgce=1|bp=2|cuc=k1g1l44n|srms=1,1,,,|uxrgcm=100,25,300,3;100,25,300,3|dpvc=1|bismepl=2000|lastModification=1587774023960|dtVersion=10191200423105232|tp=500,50,0,1|uxdcw=1500|agentUri=/ruxitagentjs_ICA2SVfqru_10191200423105232.js"></script></head>
<body>
<center><h1>502 Bad Gateway</h1></center>
<hr><center>nginx/1.17.9</center>
</body>
</html>
```

You can resolve this problem by restarting the Nginx ingress with the following command:

```
$ kubectl -n keptn delete pod -l run=api-gateway-nginx

pod "api-gateway-nginx-cc948646d-zwrb4" deleted
```

After some seconds, the Nginx ingress pod should be up and running again. You can verify this by executing:

```
$ kubectl get pods -n keptn -l run=api-gateway-nginx

NAME                                READY   STATUS    RESTARTS   AGE
api-gateway-nginx-cc948646d-h6bdb   1/1     Running   0          13m
```

At this point, the CLI commands should work again:

```
$ keptn add-resource --project=sockshop --service=carts --stage=production --resource=remediation.yaml

Adding resource remediation.yaml to service carts in stage production in project sockshop
Resource has been uploaded.
```

## Keptn on Minikube causes a MongoDB issue after a reboot

When rebooting the machine Minikube is installed on, the MongoDB pod in the `keptn` namespace runs in a `CrashLoopBackoff`.

<details><summary>Expand instructions</summary>
<p>

**Note:** Minikube is a K8s distribution for development environments. Please go with K3s/K3d for a more stable setup.

**Investigation:**

- To verify the problem, investigate the logs of the mongodb pod:

```console
kubectl logs -n keptn mongodb-578b4d8bcd-dhgb8
```

```console
=> sourcing /usr/share/container-scripts/mongodb/pre-init//10-check-env-vars.sh ...
=> sourcing /usr/share/container-scripts/mongodb/pre-init//20-setup-wiredtiger-cache.sh ...
=> sourcing /usr/share/container-scripts/mongodb/pre-init//30-set-config-file.sh ...
=> sourcing /usr/share/container-scripts/mongodb/pre-init//35-setup-default-datadir.sh ...
ERROR: Couldn't write into /var/lib/mongodb/data
CAUSE: current user doesn't have permissions for writing to /var/lib/mongodb/data directory
DETAILS: current user id = 184, user groups: 184 0
stat: failed to get security context of '/var/lib/mongodb/data': No data available
DETAILS: directory permissions: drwxr-xr-x owned by 0:0, SELinux: ?
```

**Reason:**

The problem is a permission issue on the `/var/lib/mongodb/data` folder. See [kubernetes/minikube#1184](https://github.com/kubernetes/minikube/issues/1184) and Minikube 'none' driver: <https://minikube.sigs.k8s.io/docs/reference/drivers/none/> which lay out complexity for persistence.

**Solution:**

A workaround for this issue is to add an `initContainer` to the mongodb deployment as shown below. This container will be executed before the actual mongodb container and sets the right permissions on the `/var/lib/mongodb/data` folder.

```yaml
initContainers:
- name: volume-mount-hack
    image: busybox
    command: ["sh", "-c", "chown -R 184:184 /var/lib/mongodb/data"]
    volumeMounts:
    - name: mongodata
      mountPath: /var/lib/mongodb/data
```

</p></details>

## Fully Qualified Domain Names cannot be reached from within the cluster

Depending on your Kubernetes cluster configuration, certain hostnames cannot be reached from within the Kubernetes cluster. This is usually visible via an error message that looks as follows:

```
Failed to send cloudevent:, Post http://event-broker.keptn.svc.cluster.local/keptn: dial tcp: lookup event-broker.keptn.svc.cluster.local: Try again
```

The problem can appear in virtually any service and scenario:

1. LoadGenerator for keptn/examples
1. Prometheus-Service/Prometheus-SLI-Service trying to access Prometheus
1. Dynatrace-Service trying to access a Dynatrace environment
1. Unleash-Service trying to access Unleash
1. Any keptn-service trying to send a CloudEvent via the event-broker

<details><summary>Expand instructions</summary>
<p>

**Problem**: Trying to access certain hostnames does not work within the cluster.

The reason behind this is that some Kubernetes cluster configurations have issues when it comes to resolving internal hostnames like `service.namespace.svc.cluster.local`, but potentially reaching ANY hostname might fail, e.g., trying to fetch a URL via `wget keptn.sh`.

**Analysis**: To find out whether you are affected or not, please run an `alpine:3.11` container that tries to access the Kubernetes API or any external hostname, e.g.:

```
kubectl run -i --restart=Never --rm test-${RANDOM} --image=alpine:3.11 -- sh -c "wget --no-check-certificate https://kubernetes.default.svc.cluster.local/api/v1"
```

```
kubectl run -i --restart=Never --rm test-${RANDOM} --image=alpine:3.11 -- sh -c "wget https://keptn.sh"
```

If in any of the above instances you get a "bad address", then you are most likely affected, e.g.:

```
wget: bad address 'kubernetes.default.svc.cluster.local'
```

If it prints a download bar, the content of the requested URL or an HTTP 400 error (or similar), the connection works, e.g.:

```
Connecting to kubernetes.default.svc.cluster.local (10.0.80.1:443)
saving to 'v1'
v1                   100% |********************************| 10337  0:00:00 ETA
```

The problem behind this is usually a misconfiguration for the nameserver or the local `/etc/resolv.conf` configuration (e.g., searchdomains).

More details can be found at [GitHub Kubernetes Issue #64924](https://github.com/kubernetes/kubernetes/issues/64924).

**Solutions**:

- Verify your clusters nameserver configuration is working as expected, especially the searchdomains. Easiest way to verify is to look at the output of

   ```console
   nslookup keptn.sh
   ```

   on your physical machine as well as within your Kubernetes cluster:

   ```console
   kubectl run -i --restart=Never --rm test-${RANDOM} --image=alpine:3.11 -- sh -c "nslookup keptn.sh" 
   ```

  - If a nameserver returns `NXDOMAIN` or `Non-authoritative answer`, everything is fine.
  - If at any point a nameserver returns an `ERRFAIL`, `SERVFAIL` or similar, update the hosts `/etc/resolv.conf` file (together with your administrator) and try again.

- Overwrite the DNS config `ndots` to `ndots:1` [in all deployment manifests](https://pracucci.com/kubernetes-dns-resolution-ndots-options-and-why-it-may-affect-application-performances.html).

</p></details>
