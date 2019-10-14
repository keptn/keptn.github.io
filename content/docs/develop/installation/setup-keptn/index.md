---
title: Install Keptn
description: How to install Keptn on one of the supported Kubernetes platforms.
weight: 10
icon: setup
keywords: setup
---

## Prerequisites
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- For Linux: [bc](https://www.gnu.org/software/bc/manual/html_mono/bc.html)

## Setup Kubernetes cluster

Select one of the following options:

<details><summary>Azure Kubernetes Service (AKS)</summary>
<p>

1. Install local tools
  - [az](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

2. Create AKS cluster
  - Master version >= `1.12.x` (tested version: `1.12.8`)
  - One **B4ms** node
 
 </p>
</details>

<details><summary>Amazon Elastic Kubernetes Service (EKS)</summary>
<p>

1. Install local tools
  - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) (version >= 1.16.156)

1. Create EKS cluster on AWS
  - version >= `1.13` (tested version: `1.13`)
  - One `m5.xlarge` node
  - Sample script using [eksctl](https://eksctl.io/introduction/installation/) to create such a cluster

    ```console
    eksctl create cluster --version=1.13 --name=keptn-cluster --node-type=m5.xlarge --nodes=1 --region=eu-west-3
    ```
    In our testing we learned that the default CoreDNS that comes with certain EKS versions has a bug. In order to solve that issue we can use eksctl to update the CoreDNS service like this: 
    ```console
    eksctl utils update-coredns --name=keptn-cluster --region=eu-west-3 --approve
    ```

</p>
</details>

<details><summary>Google Kubernetes Engine (GKE)</summary>
<p>

1. Install local tools
  - [gcloud](https://cloud.google.com/sdk/gcloud/)
  - [python 2.7](https://www.python.org/downloads/release/python-2716/) (required for Ubuntu 19.04)

2. Create GKE cluster
  - Master version >= `1.12.x` (tested version: `1.13.7-gke.24`)
  - One **n1-standard-8** node
  - Image type `ubuntu` or `cos` (if you plan to use Dynatrace monitoring, select `ubuntu` for a more [convenient setup](../../reference/monitoring/dynatrace/))
  - Sample script to create such cluster (adapt the values according to your needs)

    ```console
    // set environment variables
    PROJECT=name_of_gcloud_project
    CLUSTER_NAME=name_of_cluster
    ZONE=us-central1-a
    REGION=us-central1
    GKE_VERSION="1.13.7-gke.24"
    ```

    ```console
    gcloud beta container --project $PROJECT clusters create $CLUSTER_NAME --zone $ZONE --no-enable-basic-auth --cluster-version $GKE_VERSION --machine-type "n1-standard-8" --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --no-enable-ip-alias --network "projects/$PROJECT/global/networks/default" --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --no-enable-autoupgrade
    ```
 </p>
</details>

<details><summary>OpenShift 3.11</summary>
<p>

1. Install local tools

  - [oc CLI - v3.11](https://github.com/openshift/origin/releases/tag/v3.11.0)


1. On the OpenShift master node, execute the following steps:

    - Set up the required permissions for your user:

      ```
      oc adm policy --as system:admin add-cluster-role-to-user cluster-admin <OPENSHIFT_USER_NAME>
      ```

    - Set up the required permissions for the installer pod:

      ```
      oc adm policy  add-cluster-role-to-user cluster-admin system:serviceaccount:default:default
      oc adm policy  add-cluster-role-to-user cluster-admin system:serviceaccount:kube-system:default
      ```

    - Enable admission WebHooks on your OpenShift master node:

      ```
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

<details><summary>Pivotal Container Service (PKS)</summary>
<p>

1. Install local tools
  - [pks CLI - v1.0.4](https://docs.pivotal.io/runtimes/pks/1-4/installing-pks-cli.html)

1. Create PKS cluster on GCP
  - Use the provided instructions for [Enterprise Pivotal Container Service (Enterprise PKS) installation on GCP](https://docs.pivotal.io/runtimes/pks/1-4/gcp-index.html)

  - Create a PKS cluster by using the PKS CLI and executing the following command:

    ```console
    // set environment variables
    CLUSTER_NAME=name_of_cluster
    HOST_NAME=host_name
    PLAN=small
    ```

    ```console
    pks create-cluster $CLUSTER_NAME --external-hostname $HOST_NAME --plan $PLAN
    ```
</p>
</details>

## Install Keptn CLI
Every release of Keptn provides binaries for the Keptn CLI. These binaries are available for Linux, macOS, and Windows.

- Download the version for your operating system from https://github.com/keptn/keptn/releases/tag/0.5.0
- Unpack the download
- Find the `keptn` binary in the unpacked directory.
  - Linux / macOS
    
    add executable permissions (``chmod +x keptn``), and move it to the desired destination (e.g. `mv keptn /usr/local/bin/keptn`)

  - Windows

    move/copy the executable to the desired folder and, optionally, add the executable to your PATH environment variable for a more convenient experience.

- Now, you should be able to run the Keptn CLI: 
    - Linux / macOS
      ```console
      keptn --help
      ```
    
    - Windows
      ```console
      .\keptn.exe --help
      ```

**Note:** For the rest of the documentation we will stick to the Mac OS / Linux version of the commands.

## Install Keptn

To install the latest release of Keptn on a Kuberntes cluster, execute the [keptn install](../../reference/cli/#keptn-install) command and provide the requested information. Since v0.3 of Keptn, the install command accepts a parameter to select the platform you would like to install Keptn on. Currently supported platforms are: 

- Azure Kubernetes Services (AKS):

    ```console
    keptn install --platform=aks
    ```
  
- Amazon Elastic Kubernetes Service (EKS):

    ```console
    keptn install --platform=eks
    ```

- Google Kubernetes Engine (GKE):

    ```console
    keptn install --platform=gke
    ```

- OpenShift 3.11:

    ```console
    keptn install --platform=openshift
    ```

- Pivotal Container Service (PKS):

    ```console
    keptn install --platform=pks
    ```

In the Kubernetes cluster, this command creates the `keptn`, `keptn-datastore` and `istio-system` namespace. While `istio-system` contains all Istio related resources, `keptn` and `keptn-datastore` contain the complete infrastructure to run Keptn. 
    <details><summary>The `keptn` and `keptn-datastore` namespace contain:</summary>
        <ul>
        <li>mongoDb database for the Keptn's log</li>
        <li>NATS cluster</li>
        <li>Keptn core services:</li>
            <ul>
                <li>api</li>
                <li>bridge</li>
                <li>configuration-service</li>
                <li>distributors</li>
                <li>event-broker</li>
                <li>gatekeeper-service</li>
                <li>helm-service</li>
                <li>jmeter-service</li>
                <li>mongodb-datastore</li>
                <li>pitometer-service</li>
                <li>remediation-service</li>
                <li>shipyard-service</li>
                <li>wait-service</li>
            </ul>
        <li>Services to deploy artifacts and to demonstrate the self-healing use cases:</li>
            <ul>
                <li>prometheus-service</li>
                <li>servicenow-service</li>
                <li>openshift-route-service (OpenShift only)</li>
            </ul>
        </ul>
    </details>
    

## Configure a custom domain (required for EKS)

In case you have a custom domain or cannot use *xip.io* (e.g., when running Keptn on EKS, AWS will create an ELB), there is a 
CLI command to configure Keptn for your custom domain:

```console
keptn configure domain YOUR_DOMAIN
```

## Uninstall

- In order to uninstall Keptn from your cluster, run the uninstall command using the Keptn CLI:

    ``` console
    keptn uninstall
    ``` 

- To verify the cleanup, retrieve the list of namespaces in your cluster and ensure that the `keptn` namespace is not included in the output of the following command:

    ```console
    kubectl get namespaces
    ```

## Troubleshooting

Please note that in case of any errors, the install process might leave some files in an inconsistent state. Therefore `keptn install` cannot be executed a second time without `keptn uninstall`. To address a unsuccessful installation: 

1. [Verify the Keptn installation](../../reference/troubleshooting#verifying-a-keptn-installation).

1. Uninstall Keptn by executing the [keptn uninstall](../../reference/cli#keptn-uninstall) command before conducting a re-installation.  
