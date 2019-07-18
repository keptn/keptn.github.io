---
title: Install keptn
description: How to setup keptn.
weight: 10
icon: setup
keywords: setup
---

## Prerequisites
- GitHub
  - [GitHub organization](https://github.com/organizations/new) for keptn to store its configuration repositories
  - [Personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line) for a user with access to said organization

      -  Needed scopes: [x] `repo`

        <details><summary>Expand Screenshot</summary>
          {{< popup_image link="./assets/github-access-token.png" 
        caption="GitHub Personal Access Token Scopes" width="50%">}}
          </details>

- Local tools
  - [git](https://git-scm.com/)
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  - For Linux: [bc] (https://www.gnu.org/software/bc/manual/html_mono/bc.html)

## Setup Kubernetes Cluster
Select one of the following options:

<details><summary>Google Kubernetes Engine (GKE)</summary>
<p>

1. Install local tools
  - [gcloud](https://cloud.google.com/sdk/gcloud/)
  - [python 2.7](https://www.python.org/downloads/release/python-2716/) (required for Ubuntu 19.04)

2. Create GKE cluster
  - Master version >= `1.11.x` (tested version: `1.11.7-gke.12` and `1.12.7-gke.10`)
  - One `n1-standard-16` node
    <details><summary>Expand for details</summary>
    {{< popup_image link="./assets/gke-cluster-size.png" 
      caption="GKE cluster size" width="50%">}}
    </details>
  - Image type `ubuntu` or `cos` (if you plan to use Dynatrace monitoring, select `ubuntu` for a more [convenient setup](../../monitoring/dynatrace/))
  - Sample script to create such cluster (adapt the values according to your needs)

    ```console
    // set environment variables
    PROJECT=nameofgcloudproject
    CLUSTER_NAME=nameofcluster
    ZONE=us-central1-a
    REGION=us-central1
    GKE_VERSION="1.12.7-gke.10"
    ```

    ```console
    gcloud beta container --project $PROJECT clusters create $CLUSTER_NAME --zone $ZONE --no-enable-basic-auth --cluster-version $GKE_VERSION --machine-type "n1-standard-16" --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --no-enable-ip-alias --network "projects/$PROJECT/global/networks/default" --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --no-enable-autoupgrade
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

1. Determine the **Cluster CIDR Range** and **Services CIDR Range** that are required during the installation. On OpenShift, those values correlate to the following fields in the file `/etc/origin/master/master-config.yaml` on the OpenShift master node: 

  ```yaml
  
  networkConfig:
    clusterNetworks:
    - cidr: "10.128.0.0/14"
      hostSubnetLength: 9
    externalIPNetworkCIDRs:
    - "0.0.0.0/0"
    ingressIPNetworkCIDR: ""
    networkPluginName: redhat/openshift-ovs-subnet
    serviceNetworkCIDR: "172.30.0.0/16"
    
  ```

  In this example, the **Cluster CIDR Range** has the value `10.128.0.0/14` and the **Services CIDR Range** is set to `172.30.0.0/16`. Please note those values, as you will be asked for them as during the installation of keptn via the CLI.
</p>
</details>

<details><summary>Azure Kubernetes Service (AKS)</summary>
<p>

1. Install local tools
  - [az](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

2. Create AKS cluster
  - Master version >= `1.12.x` (tested version: `1.12.8`)
  - One `D16s_v3` node
    <details><summary>Expand for details</summary>
    {{< popup_image link="./assets/aks-cluster-size.png" 
      caption="AKS cluster size" width="100%">}}
    </details>  
 </p>
</details>

<!-- 
<details><summary>Amazon Elastic Container Service (EKS)</summary>
<p>

1. Install local tools

1. Create EKS cluster on AWS
</p>
</details>

-->

## Install keptn CLI
Every release of keptn provides binaries for the keptn CLI. These binaries are available for Linux, macOS, and Windows.

- Download the version for your operating system from https://github.com/keptn/keptn/releases/tag/0.3.0
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

- Execute the CLI command `keptn install` and provide the requested information. This command will install keptn
in the version of the latest release. Since v0.3 of keptn, the install command accepts a parameter to select the platform you would like to install keptn on. Currently supported platforms are Google Kubernetes Engine (GKE), OpenShift and Azure Kubernetes Services (AKS). Depending on your platform, enter the following command to start the installation:

  - For **GKE**:

    ```console
    keptn install --platform=gke
    ```

  - For **OpenShift**:

    ```console
    keptn install --platform=openshift
    ```

  - For **AKS**:

    ```console
    keptn install --platform=aks
    ```

    In your cluster, this command installs the complete infrastructure necessary to run keptn. 
        <details><summary>This includes:</summary>
            <ul>
            <li>Istio</li>
            <li>Knative</li>
            <li>An Elasticsearch/Kibana Stack for the keptn's log</li>
            <li>The keptn core services:</li>
                <ul>
                    <li>authenticator</li>
                    <li>bridge</li>
                    <li>control</li>
                    <li>eventbroker</li>
                    <li>eventbroker-ext</li>
                </ul>
            <li>The services are required to deploy artifacts and to demonstrate the self-healing use cases:</li>
                <ul>
                    <li>github-services</li>
                    <li>helm-service</li>
                    <li>jmeter-service</li>
                    <li>gatekeeper-service</li>
                    <li>pitometer-service</li>
                    <li>serviceNow-service</li>
                    <li>openshift-route-service (OpenShift only)</li>
                </ul>
            <li>The channels to which events are published:</li>
                <ul>
                    <li>configuration-changed</li>
                    <li>deployment-finished</li>
                    <li>evaluation-done</li>
                    <li>keptn-channel</li>
                    <li>new-artifact</li>
                    <li>problem</li>
                    <li>tests-finished</li>
                </ul>
            </ul>
        </details>


## Verifying the installation

- To verify your keptn installation, retrieve the pods running in the `keptn` namespace.

  ```console
  kubectl get pods -n keptn
  ```

  ```console
  NAME                                                 READY     STATUS    RESTARTS   AGE
  authenticator-fvq2c-deployment-565597c98c-fqj46      3/3       Running   0          30m
  control-kwhms-deployment-6d7b8b8d94-v7xsj            3/3       Running   0          30m
  event-broker-ext-2v84b-deployment-856cf65b99-96zpd   3/3       Running   0          30m
  event-broker-z8tc6-deployment-7997b998b4-jhvq4       3/3       Running   0          30m
  gatekeeper-service-svvqm-deployment-8f559dc8c-k42s4  3/3       Running   0          30m
  github-service-xcn9w-deployment-545866fc6f-hl4gc     3/3       Running   0          30m
  helm-service-2hdsb-deployment-665fdb697d-hwtmv       3/3       Running   0          30m
  jmeter-service-n5xrq-deployment-75644db9c4-c9fhn     3/3       Running   0          30m
  ```

- Next, check that all routes for the keptn core services, as well as for the bridge, gatekeeper-service, github-service, helm-service, pitometer-service, jmeter-service, and the servicenow-service have been created:

  ```console
  kubectl get routes -n keptn
  ```

  ```console
  NAME                 AGE
  authenticator        31m
  bridge               31m
  control              31m
  eventbroker          31m
  eventbroker-ext      31m
  gatekeeper-service   31m
  helm-service         31m
  github-service       31m
  pitometer-service    31m
  jmeter-service       31m
  servicenow-service   31m
  ```

- Finally, check that all keptn channels have been created:

  ```console
  kubectl get channels -n keptn
  ```

  ```console
  NAME                    AGE
  configuration-changed   31m
  deployment-finished     31m
  evaluation-done         31m
  keptn-channel           31m
  new-artifact            31m
  problem                 31m
  tests-finished          31m
  ```

- To verify the Istio installation, retrieve all pods within the `istio-system` namespace and check whether they are in a running state:
  
  ```console
  kubectl get pods -n istio-system
  ```

  ```console
  NAME                                      READY     STATUS      RESTARTS   AGE
  cluster-local-gateway-775b6cbf4c-bxxx8    1/1       Running     0          20m
  istio-citadel-796c94878b-fhzf8            1/1       Running     0          20m
  istio-cleanup-secrets-nbdff               0/1       Completed   0          20m
  istio-egressgateway-864444d6ff-g7c6m      1/1       Running     0          20m
  istio-galley-6c68c5dbcf-fzdzb             1/1       Running     0          20m
  istio-ingressgateway-694576c7bb-w52j7     1/1       Running     0          20m
  istio-pilot-79f5f46dd5-c62bv              2/2       Running     0          20m
  istio-pilot-79f5f46dd5-wjwmf              2/2       Running     0          22m
  istio-pilot-79f5f46dd5-zgbwm              2/2       Running     0          22m
  istio-policy-5bd5578b94-nggnx             2/2       Running     0          20m
  istio-sidecar-injector-6d8f88c98f-mqrpj   1/1       Running     0          20m
  istio-telemetry-5598f86cd8-7s4t7          2/2       Running     0          20m
  istio-telemetry-5598f86cd8-bzfb5          2/2       Running     0          20m
  istio-telemetry-5598f86cd8-hxkhm          2/2       Running     0          20m
  istio-telemetry-5598f86cd8-pgstj          2/2       Running     0          20m
  istio-telemetry-5598f86cd8-wkh7g          2/2       Running     0          20m
  zipkin-6b4d5d66-jwqzk                     1/1       Running     0          20m
  ```

- To verify the Knative installation, check the pods in the `knative-serving` namespace:

  ```console
  kubectl get pods -n knative-serving
  ```

  ```console
  NAME                          READY     STATUS      RESTARTS   AGE
  activator-6f7d494f55-fthpr    2/2       Running     0          17m
  autoscaler-5cb4d56d69-qz7dh   2/2       Running     0          17m
  controller-6d65444c78-8wqb8   1/1       Running     0          17m
  webhook-55f88654fb-tq8ps      1/1       Running     0          17m
  ```

  If that is not the case, there may have been a problem during the installation. In that case, we kindly ask you to clean your cluster and restart the installation described in the **Troubleshooting** section below.

## Uninstall

- Please follow these instructions to uninstall keptn from your cluster:

  - For **GKE** and **AKS**:
    - Clone the keptn installer repository of the latest release:

      ``` console
      git  clone --branch 0.3.0 https://github.com/keptn/installer
      cd  ./installer/scripts/common
      ``` 

    - Execute `uninstallKeptn.sh` and all keptn resource will be deleted

      ```console
      ./uninstallKeptn.sh
      ```
  - For **OpenShift**:
    - Clone the keptn installer repository of the latest release:

      ``` console
      git  clone --branch 0.3.0 https://github.com/keptn/installer
      cd  ./installer/scripts/openshift
      ``` 

    - Execute `uninstallKeptn.sh` and all keptn resource will be deleted

      ```console
      ./uninstallKeptn.sh
      ``` 

- To verify the cleanup, retrieve the list of namespaces in your cluster and ensure that the `keptn` namespace is not included in the output of the following command:

  ```console
  kubectl get namespaces
  ```

- **Note**: In some cases, it might occure that the `keptn` namespace remains stuck in the `Terminating` state. If that happens, you can enforce the deletion of the namespace as follows:

  ```console
  NAMESPACE=keptn
  kubectl proxy &
  kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json
  curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
  rm temp.json
  ```

- **Note:** In future releases of the keptn CLI, a command `keptn uninstall` will be added, which replaces the shell script `uninstallKeptn.sh`.

## Troubleshooting

Please note that in case of any errors, the install process might leave some files in an inconsistent state. Therefore `keptn install` cannot be executed a second time without an uninstall.
