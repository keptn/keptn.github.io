---
title: Troubleshooting
description: Find tips and tricks to deal with troubles that may occur when using Keptn. 
weight: 300
icon: help
---

In this section, instructions have been summarized that help to troubleshoot known issues that may occur when using Keptn.

## Generating a support archive

Use the [keptn generate support-archive](../reference/cli/commands/keptn_generate_support-archive) command
to generate a support archive
that can be used as a data source for debugging a Keptn installation.
Note that you must
[install the Keptn CLI](../../install/cli-install) before you can run this command.

## Troubleshooting details

See the following pages for specific troubleshooting hints:

* [Troubleshooting the installation](../../install/troubleshooting)

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

Same as the error above, but this issue occurs sometimes using a _single_ worker node on EKS.

**Solution:** 

Increase the number of worker nodes. For example, you can therefore use the `eksctl` CLI:
https://eksctl.io/usage/managing-nodegroups/

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

Install Istio as described in the [Install and configure Istio](../../install/istio) section.

</p></details>


## NGINX troubleshooting

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

When rebooting the machine on which Minikube is installed, the MongoDB pod in the `keptn` namespace runs in a `CrashLoopBackoff`. 

<details><summary>Expand instructions</summary>
<p>

**Note:** Minikube is a Kubernetes distribution for development environments. Please go with K3s/K3d for a more stable setup.

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

