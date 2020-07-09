---
title: Troubleshooting
description: Find tips and tricks to deal with troubles that may occur when using Keptn. 
weight: 100
icon: help
keywords: [troubleshooting]
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
NAME                                                              READY     STATUS    RESTARTS   AGE
api-gateway-nginx-794b946b9c-jjhsv                                1/1       Running   0          34m
api-service-86dc967944-bx9n4                                      1/1       Running   0          34m
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


## Broken Keptn project

When creating a project failed, this can cause a problematic state that manifests in a situation that the Keptn Bridge does not show any project.

<details><summary>Expand instructions</summary>
<p>

**Situation**: Executing [keptn create project](../reference/cli/commands/keptn_create_project) failed with following error messsage: 

```console
Starting to create project   
ID of Keptn context: 9d1a30cd-e00b-4354-a308-03e50368bc40  
Creating project sockshop failed. Could not commit changes.
```

**Problem**: The Keptn Bridge does not show any project even though other projects were already displayed. 

**Solution**: 

* Try to execute the command [keptn delete project](../reference/cli/commands/keptn_delete_project):

* If the command did not work, manually delete the faulty project in the `configuration-service` pod.

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

## Troubleshooting the Installer Job

In some cases, the installer is not running correctly or crashes.

<details><summary>Expand instructions</summary>
<p>

**Investigation:**

The Keptn installation is aborting with an error. The investigation needs to be conducted using the following commands:

* Show all deployed pods in the default namespace (should show the status of the installer pod): ``kubectl get pods``
* Show status of the installer job: ``kubectl get jobs``
* Get logs of the installer job: ``kubectl logs jobs/installer``
* If the installer has partially finished, [verify your Keptn installation](#verifying-a-keptn-installation)

**Possible solutions:**

* If the installer pod shows an ImagePullBackOff error, verify that your cluster can connect to the Internet to pull images (e.g., from docker.io).
* If the installer pod has started, but crashes, please create a [new bug report](https://github.com/keptn/keptn/issues/new?assignees=&labels=bug&template=bug_report.md&title=) with the output of above commands.


</p></details>


## Error: UPGRADE FAILED: timed out waiting for the condition

This error often appears when executing `keptn send event new-artifact` in case of insufficient CPU and/or memory on the Kubernetes cluster.

<details><summary>Expand instructions</summary>
<p>

**Investigation:**

The Helm upgrade runs into a time-out when deploying a new artifact of your service using

```console
keptn send event new-artifact
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

Same as the error above, but this issue occurs sometimes using a _single_ worker node on EKS.

**Solution:** 

Increase the number of worker nodes. For example, you can therefore use the `eksctl` CLI:
https://eksctl.io/usage/managing-nodegroups/


## Verify Kubernetes Context with Keptn Installation

If you are performing critical operations, such as installing new Keptn services or upgrading something, please verify
that you are connected to the correct cluster.

An easy way to accomplish this is to compare the domain stored in the Kubernetes ConfigMap `keptn-domain` with the output of `keptn status`.

```console
$ kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}'

123.45.67.89.xip.io
``` 
vs.
```console
$ keptn status
Starting to authenticate
Successfully authenticated
CLI is authenticated against the Keptn cluster https://api.keptn.123.45.67.89.xip.io
```

As you can see, the domains match (despite the `https://api.keptn.` prefix in the output of `keptn status`).

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

**Note:** Minikube is a K8s distribution for development environments. Please go with K3s for a more stable setup.

**Investigation:**

* To verify the problem, investigate the logs of the mongodb pod:

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

The problem is a permission issue on the `/var/lib/mongodb/data` folder. See [kubernetes/minikube#1184](https://github.com/kubernetes/minikube/issues/1184) and Minikube 'none' driver: https://minikube.sigs.k8s.io/docs/reference/drivers/none/ which lay out complexity for persistence.

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