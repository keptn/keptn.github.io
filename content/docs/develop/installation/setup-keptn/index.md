---
title: Install keptn
description: How to setup keptn.
weight: 10
icon: setup
keywords: setup
---

## Prerequisites
- Local tools
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  - For Linux: [bc](https://www.gnu.org/software/bc/manual/html_mono/bc.html)

## Setup Kubernetes Cluster
<!--
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

<details><summary>Amazon Elastic Container Service (EKS)</summary>
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
-->
<details><summary>Google Kubernetes Engine (GKE)</summary>
<p>

1. Install local tools
  - [gcloud](https://cloud.google.com/sdk/gcloud/)
  - [python 2.7](https://www.python.org/downloads/release/python-2716/) (required for Ubuntu 19.04)

2. Create GKE cluster
  - Master version >= `1.11.x` (tested version: `1.12.8-gke.10`)
  - One **n1-standard-4** node
  - Image type `ubuntu` or `cos` (if you plan to use Dynatrace monitoring, select `ubuntu` for a more [convenient setup](../../monitoring/dynatrace/))
  - Sample script to create such cluster (adapt the values according to your needs)

    ```console
    // set environment variables
    PROJECT=nameofgcloudproject
    CLUSTER_NAME=nameofcluster
    ZONE=us-central1-a
    REGION=us-central1
    GKE_VERSION="1.12.8-gke.10"
    ```

    ```console
    gcloud beta container --project $PROJECT clusters create $CLUSTER_NAME --zone $ZONE --no-enable-basic-auth --cluster-version $GKE_VERSION --machine-type "n1-standard-4" --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --no-enable-ip-alias --network "projects/$PROJECT/global/networks/default" --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --no-enable-autoupgrade
    ```
 </p>
</details>

<!--
<details><summary>Pivotal Container Service (PKS)</summary>
<p>

1. Install local tools
  - [pks CLI - v1.0.4](https://docs.pivotal.io/runtimes/pks/1-4/installing-pks-cli.html)

1. Create PKS cluster on GCP
  - Use the provided instructions for [Enterprise Pivotal Container Service (Enterprise PKS) installation on GCP](https://docs.pivotal.io/runtimes/pks/1-4/gcp-index.html)

  - Create a PKS cluster by using the PKS CLI and executing the following command:

    ```console
    // set environment variables
    CLUSTER_NAME=nameofcluster
    HOST_NAME=hostname
    PLAN=small
    ```

    ```console
    pks create-cluster $CLUSTER_NAME --external-hostname $HOST_NAME --plan $PLAN
    ```

* **Note** For the keptn installation, the *Cluster CIDR Range* and *Services CIDR Range* are required. The values for these two properties you find in your PCF OpsManager. 

    * Login to your PCF OpsManager
    * Click on the **Enterprise PKS** tile and go to **Networking**
    * The networking configuration shows the values for the *Kubernetes Pod Network CIDR Range* (Cluster CIDR Range) and *Kubernetes Service Network CIDR Range* (Services CIDR Range).
    {{< popup_image link="./assets/cluster-services-ip.png" caption="Kubernetes Pod and Services Network CIDR Range" width="40%">}}

</p>
</details>
-->

<!--
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
--> 
## Install keptn CLI
Every release of keptn provides binaries for the keptn CLI. These binaries are available for Linux, macOS, and Windows.

- Download the version for your operating system from https://github.com/keptn/keptn/releases/tag/0.5.0.beta
- Unpack the download
- Find the `keptn` binary in the unpacked directory.
  - Linux / macOS
    
        add executable permissions (``chmod +x keptn``), and move it to the desired destination (e.g. `mv keptn /usr/local/bin/keptn`)

  - Windows

        move/copy the executable to the desired folder and, optionally, add the executable to your PATH environment variable for a more convenient experience.

- Now, you should be able to run the keptn CLI: 
    - Linux / macOS

    ```console
    keptn --help
    ```
    
    - Windows

    ```console
    .\keptn.exe --help
    ```

    Please note that for the rest of the documentation we will stick to the Mac OS / Linux version of the commands.

## Install keptn

- Execute the CLI command `keptn install` and provide the requested information. This command will install keptn in the version of the latest release. Since v0.3 of keptn, the install command accepts a parameter to select the platform you would like to install keptn on. <!--Currently supported platforms are Google Kubernetes Engine (GKE), OpenShift and Azure Kubernetes Services (AKS). Depending on your platform, enter the following command to start the installation:-->

<!--
  - For **AKS**:
    ```console
    keptn install --platform=aks
    ```
  
  - For **EKS**:
    ```console
    keptn install --platform=eks
    ```
-->
  - For **GKE**:
    ```console
    keptn install --platform=gke
    ```
<!--
  - For **OpenShift**:
    ```console
    keptn install --platform=openshift
    ```
-->
In your cluster, this command installs the complete infrastructure necessary to run keptn. 
    <details><summary>This includes:</summary>
        <ul>
        <li>Istio</li>
        <li>A MongoDb database for the keptn's log</li>
        <li>A NATS Cluster</li>
        <li>The keptn core services:</li>
            <ul>
                <li>api</li>
                <li>bridge</li>
                <li>configuration-service</li>
                <li>distributors</li>
                <li>eventbroker</li>
                <li>eventbroker</li>
                <li>gatekeeper service</li>
                <li>mongodb-datastore</li>
                <li>shipyard-service</li>
                <li>wait-service</li>
            </ul>
        <li>The services are required to deploy artifacts and to demonstrate the self-healing use cases:</li>
            <ul>
                <li>helm-service</li>
                <li>jmeter-service</li>
                <li>gatekeeper-service</li>
                <li>pitometer-service</li>
                <li>prometheus-service</li>
                <li>serviceNow-service</li>
                <li>openshift-route-service (OpenShift only)</li>
            </ul>
        </ul>
    </details>
    
<!--
## Configure a custom domain (required for EKS)
  
In case you have a custom domain or cannot use xip.io (e.g., because you are running in AWS which will create ELBs for you), there is a 
CLI command provided to configure keptn to use your custom domain:
```console
keptn configure domain YOUR_DOMAIN
```
-->
## Verifying the installation

- To verify your keptn installation, retrieve the pods running in the `keptn` namespace.

  ```console
  kubectl get pods -n keptn
  ```

  ```console
  NAME                                                              READY     STATUS    RESTARTS   AGE
  api-55b57db797-8kgxd                                              1/1       Running   0          2m
  bridge-6fc5bd679b-745fz                                           1/1       Running   0          2m
  configuration-service-845997dd7d-sf5f6                            1/1       Running   0          1m
  eventbroker-go-68d5f9d789-pp7n4                                   1/1       Running   0          2m
  gatekeeper-service-6469d5f4f7-96cjl                               1/1       Running   0          1m
  gatekeeper-service-evaluation-done-distributor-5b5f77c6ff-pf8hb   1/1       Running   0          1m
  helm-service-569dc7d48f-dzs6n                                     1/1       Running   0          1m
  helm-service-configuration-change-distributor-55ddcdbc94-6v8jj    1/1       Running   0          1m
  helm-service-service-create-distributor-7896c55ccf-fn8cj          1/1       Running   0          1m
  jmeter-service-57c9d4d999-mfxlr                                   1/1       Running   0          1m
  jmeter-service-deployment-distributor-687b778dfd-hvd8q            1/1       Running   0          1m
  keptn-nats-cluster-1                                              1/1       Running   0          2m
  nats-operator-67d8dd94d5-7929b                                    1/1       Running   0          2m
  pitometer-service-775dfb4bf4-6bqqm                                1/1       Running   0          1m
  pitometer-service-tests-finished-distributor-785bdc79d4-xgwdd     1/1       Running   0          1m
  prometheus-service-5d84cd45df-kcft8                               1/1       Running   0          4m
  prometheus-service-monitoring-configure-distributor-5f4f9f54jks   1/1       Running   0          4m
  servicenow-service-64cb58c879-f868m                               1/1       Running   0          4m
  servicenow-service-problem-distributor-6d4fc577d9-8b97g           1/1       Running   0          4m
  shipyard-service-58b5d5df74-2k8d5                                 1/1       Running   0          1m
  shipyard-service-create-project-distributor-5d56b4fcfd-6hmt6      1/1       Running   0          1m
  wait-service-d749fc4bb-qzfzk                                      1/1       Running   0          1m
  wait-service-deployment-distributor-7cd55f5cfb-7f7cb              1/1       Running   0          1m
  openshift-route-service-57b45c4dfc-4x5lm                          1/1       Running   0          33s (OpenShift only)
  openshift-route-service-create-project-distributor-7d4454cs44xp   1/1       Running   0          33s (OpenShift only)
  ```

  In the `keptn-datastore` namespace, you should see the following pods:

  ```console
  kubectl get pods -n keptn-datastore
  ```

  ```console
  NAME                                             READY   STATUS    RESTARTS   AGE
  fluent-bit-jc55r                                 1/1     Running   0          73m
  mongodb-7d956d5775-rflh5                         1/1     Running   0          73m
  mongodb-datastore-d65b468d7-4q5bh                1/1     Running   0          73m
  mongodb-datastore-distributor-6cc947d554-ncfm7   1/1     Running   0          73m
  ```
    
- To verify the Istio installation, retrieve all pods within the `istio-system` namespace and check whether they are in a running state:
  
  ```console
  kubectl get pods -n istio-system
  ```

  ```console
  NAME                                    READY     STATUS    RESTARTS   AGE
  istio-citadel-6c456d967c-bpqbd            1/1     Running     0          76m
  istio-cleanup-secrets-1.2.5-22gts         0/1     Completed   0          76m
  istio-ingressgateway-5d49795589-tfl4k     1/1     Running     0          76m
  istio-init-crd-10-rzlf7                   0/1     Completed   0          76m
  istio-init-crd-11-chvzr                   0/1     Completed   0          76m
  istio-init-crd-12-8zvn4                   0/1     Completed   0          76m
  istio-pilot-79b78c894b-zsz5j              2/2     Running     0          76m
  istio-security-post-install-1.2.5-glswk   0/1     Completed   0          76m
  istio-sidecar-injector-bcf445789-gkfjf    1/1     Running     0          76m
  ```

  If that is not the case, there may have been a problem during the installation. In that case, we kindly ask you to clean your cluster and restart the installation described in the **Troubleshooting** section below.

## Uninstall

- In order to uninstall keptn from your cluster, run the uninstall command using the keptn CLI:
    ``` console
    keptn uninstall
    ``` 

 - To verify the cleanup, retrieve the list of namespaces in your cluster and ensure that the `keptn` namespace is not included in the output of the following command:

    ```console
    kubectl get namespaces
    ```

## Troubleshooting

Please note that in case of any errors, the install process might leave some files in an inconsistent state. Therefore `keptn install` cannot be executed a second time without an uninstall.
