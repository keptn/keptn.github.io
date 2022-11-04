---
title: Create or bring a Kubernetes cluster
description: Install Keptn on your Kubernetes cluster and expose it
weight: 10
---

Keptn can run on top of virtually any [Kubernetes](../k8s-support) cluster.
It can be installed in its own namespace on an existing Kubernetes cluster
or on its own cluster.
You can also deploy the Keptn Control Plane on one Kubernetes cluster
and deploy the Keptn Execution Plane on other Kubernetes clusters;
see [Multi-cluster setup](../multi-cluster) for details.

Before you install a new Kubernetes cluster,
you must install the [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) CLI.

Some of the more popular Kubernetes options are listed below
with links to installation instructions.

* This includes major commercial Kubernetes providers
  that are appropriate for production instances of Keptn.
* k3s, k3d, and Minikube allow you to install a small Kubernetes cluster
  on your laptop for study and demonstration purposes.

*Note* Be sure to check [Kubernetes support & Cluster size](../k8s-support)
  to ensure that Keptn is compatible with the Kubernetes version you are running
  and that your Kubernetes cluster has enough resources for Keptn.
  In particular, ensure that you include adequat storage capacity
  for the Persistent Volume Claims (PVCs).
  We recommend at least 20GB to 30GB of storage capacity for any Keptn installlation.
  Larger installations running more complex projects may need additional storage capacity.
  See [Check resources](../troubleshooting/#check-resources) for more information.

<details>
   <summary>Azure Kubernetes Service (AKS)</summary>

- Create AKS cluster by following the guide [here](https://docs.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli)
- Recommended node size: One **D8s_v3** node

</details>


<details><summary>Amazon Elastic Kubernetes Service (EKS)</summary>
<p>

- Create EKS cluster following by following the guide [here](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html)
- Recommended node size: One `m5.2xlarge` node

</p>
</details>

<details><summary>Google Kubernetes Engine (GKE)</summary>
<p>

Run your Keptn installation for free on GKE! If you [sign up for a Google Cloud account](https://console.cloud.google.com/getting-started), Google gives you an initial $300 credit. For deploying Keptn, you can apply for an additional $200 credit, which you can use towards that GKE cluster needed to run Keptn.<br><br>
<a class="button button-primary" href="https://bit.ly/keptngkecredit" target="_blank">Apply for your credit here</a>

- Create GKE cluster by following the guide [here](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-regional-cluster)
- Recommended node size: One node with 8 vCPUs and 32 GB memory (e.g., one **n1-standard-8** node)
  - Image type `Ubuntu` or `COS` (**Note:** If you plan to use Dynatrace monitoring, select `ubuntu` for a more convenient setup.
  
 </p>
</details>

<details><summary>OpenShift 4 & 3.11</summary>
<p>

**OpenShift 4**

1. Please bring your own OpenShift cluster in version 4 (tested version: `4.5`)

1. Install local tools

  - [oc CLI - v4.1](https://github.com/openshift/origin/releases/tag/v4.1.0)

1. Currently, there is the *known limitation* that the MongoDB of Keptn does not start. Please follow the troubleshooting guide provided here: [MongoDB fails on OpenShift](../troubleshooting/#mongodb-fails-on-openshift).
ngo

**OpenShift 3.11**

1. Please bring your own OpenShift cluster in version 3.11

1. Install local tools

  - [oc CLI - v3.11](https://github.com/openshift/origin/releases/tag/v3.11.0)

1. On the OpenShift master node, execute the following steps:

    - Set up the required permissions for your user:

      ```console
    oc adm policy --as system:admin add-cluster-role-to-user cluster-admin <OPENSHIFT_USER_NAME>
      ```

    - Set up the required permissions for the installer pod:

      ```console
    oc adm policy  add-cluster-role-to-user cluster-admin system:serviceaccount:default:default
    oc adm policy  add-cluster-role-to-user cluster-admin system:serviceaccount:kube-system:default
      ```

    - Enable admission WebHooks on your OpenShift master node:

      ```console
    sudo -i
    cp -n /etc/origin/master/master-config.yaml /etc/origin/master/master-config.yaml.backup
    oc ex config patch /etc/origin/master/master-config.yaml --type=merge -p '{
      "admissionConfig": {
        "pluginConfig": {
          "ValidatingAdmissionWebhook": {
            "configuration": {
              "apiVersion": "apiserver.config.k8s.io/v1alpha1",
              "kind": "WebhookAdmission",
              "kubeConfigFile": "/dev/null"
            }
          },
          "MutatingAdmissionWebhook": {
            "configuration": {
              "apiVersion": "apiserver.config.k8s.io/v1alpha1",
              "kind": "WebhookAdmission",
              "kubeConfigFile": "/dev/null"
            }
          }
        }
      }
    }' >/etc/origin/master/master-config.yaml.patched
    if [ $? == 0 ]; then
      mv -f /etc/origin/master/master-config.yaml.patched /etc/origin/master/master-config.yaml
      /usr/local/bin/master-restart api && /usr/local/bin/master-restart controllers
    else
      exit
    fi
      ```
</p>
</details>

<details><summary>K3s</summary>
<p>

Please refer to the [official homepage of K3s](https://k3s.io) for detailed installation instructions. Here, a short guide on how to run Keptn on K3s is provided for a Linux environment. **Note:** If you are using macOS, you will need to run K3s using [multipass](https://multipass.run/) and as explained [here](https://medium.com/@zhimin.wen/running-k3s-with-multipass-on-mac-fbd559966f7c).
 
1. Download, install [K3s](https://k3s.io/) (tested with [versions 1.17 to 1.21](../k8s-support)) and run K3s using the following command:
   ```console
   curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.20.4+k3s1 K3S_KUBECONFIG_MODE="644" sh -s - --no-deploy=traefik
   ```
   This installs version `v1.20.4+k3s1` (please refer to the [K3s GitHub releases page](https://github.com/rancher/k3s/releases) for newer releases), sets file permissions `644` on `/etc/rancher/k3s/k3s.yaml` and disables `traefik` as an ingress controller.

1. Export the Kubernetes profile using
   ```console
   export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
   ```
   
1. Verify that the connection to the cluster works
   ```console
   kubectl get nodes   
   ```

</p>
</details>

 <details><summary>K3d</summary>
<p>

Please refer to the [official homepage of K3d](https://k3d.io/v5.3.0/) for detailed installation instructions. Here, a short guide on how to run Keptn on K3d is provided for a Linux environment.

**Note:** [Docker](https://docs.docker.com/get-docker/) is required to use k3d.
k3d v5.x.x requires at least Docker v20.10.5 (runc >= v1.0.0-rc93) to work properly.

You must install [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) before installing K3d. This is used to interact with the Kubernetes cluster.

1. Download, install [K3d](https://k3d.io/v5.3.0/) (tested with [v5.3.0](../k8s-support)) and run K3d using the following command:

   ```console
   curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=v5.3.0 bash
   ```
   This installs version `v5.3.0` (please refer to the [K3d GitHub releases page](https://github.com/k3d-io/k3d/) for newer releases).

1. Create a cluster called My keptn which has port fowarding and disables the traffic, which is a ingress gateaway.
   ```console
   k3d cluster create mykeptn -p "8082:80@loadbalancer" --k3s-arg "--no-deploy=traefik@server:*"
   ```
   
1. Verify that the connection to the cluster works
   ```console
   kubectl get nodes   
   ```

</p>
</details>

<details><summary>Minikube</summary>
<p>

1. Download and install [Minikube](https://github.com/kubernetes/minikube/releases) (tested with [versions 1.3 to 1.10](../k8s-support)).

1. Create a new Minikube profile (named keptn) with at least 6 CPU cores and 14 GB memory using:

    ```console
    minikube start -p keptn --cpus 6 --memory 14000
    ``` 

1. (Optional) Start the Minikube LoadBalancer service in a second terminal by executing:

    ```console
   minikube tunnel 
   ``` 
</p>
</details>

<details><summary>Any other Kubernetes distribution</summary>
<p>

Keptn runs on any other Kubernetes distribution as it only consists of Kubernetes deployments, services, RBAC rules, and PVCs.
If you are facing problems, please let us know on https://slack.keptn.sh.

</p>
</details>

