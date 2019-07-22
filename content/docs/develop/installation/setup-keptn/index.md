---
title: Install keptn
description: How to setup keptn.
weight: 10
icon: setup
keywords: setup
---

## Prerequisites
- GitHub
  - [GitHub organization](https://github.com/organizations/new) for Keptn to store its configuration repositories
  - [Personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line) for a user with access to said organization

      -  Needed scopes: [x] `repo`

        <details><summary>Expand Screenshot</summary>
          {{< popup_image link="./assets/github-access-token.png" 
        caption="GitHub Personal Access Token Scopes" width="50%">}}
          </details>

- Local tools
  - [git](https://git-scm.com/)
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  - For Linux: [bc](https://www.gnu.org/software/bc/manual/html_mono/bc.html)

## Setup Kubernetes Cluster
Select one of the following options:

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
    GKE_VERSION="1.18.8-gke.10"
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

<details><summary>Azure Kubernetes Service (AKS)</summary>
<p>

1. Install local tools
  - [az](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

2. Create AKS cluster
  - Master version >= `1.12.x` (tested version: `1.12.8`)
  - One **B4ms** node
 
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
Every release of Keptn provides binaries for the Keptn CLI. These binaries are available for Linux, macOS, and Windows.

- Download the version for your operating system from https://github.com/keptn/keptn/releases/tag/0.4.0
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

    Please note that for the rest of the documentation we will stick to the Mac OS / Linux version of the commands.

## Install Keptn

- Execute the CLI command `keptn install` and provide the requested information. This command will install Keptn in the version of the latest release. Since v0.3 of Keptn, the install command accepts a parameter to select the platform you would like to install Keptn on. Currently supported platforms are Google Kubernetes Engine (GKE), OpenShift and Azure Kubernetes Services (AKS). Depending on your platform, enter the following command to start the installation:

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

    In your cluster, this command installs the complete infrastructure necessary to run Keptn. 
        <details><summary>This includes:</summary>
            <ul>
            <li>Istio</li>
            <li>An Elasticsearch/Kibana Stack for the Keptn's log</li>
            <li>A NATS Cluster</li>
            <li>The Keptn core services:</li>
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
            </ul>
        </details>


## Verifying the installation

- To verify your Keptn installation, retrieve the pods running in the `keptn` namespace.

  ```console
  kubectl get pods -n keptn
  ```

  ```console
  NAME                                                 READY     STATUS    RESTARTS   AGE
  authenticator-c7cdfbd76-qdnbt                                     1/1       Running   0          1d
  bridge-569c8447d-cl4sn                                            1/1       Running   0          1d
  control-d7d6d88bb-s6mn2                                           1/1       Running   0          1d
  dispatcher-c9899f967-nncfz                                        1/1       Running   4          8d
  dynatrace-service-65d5f564d7-dt4vv                                1/1       Running   0          21h
  dynatrace-service-deployment-finished-distributor-78b4c9f94bsjr   1/1       Running   0          21h
  dynatrace-service-evaluation-done-distributor-5759df98dd-dz9cc    1/1       Running   0          21h
  dynatrace-service-tests-finished-distributor-9d8896665-vw7lm      1/1       Running   0          21h
  event-broker-ext-678c4dc5b5-772x7                                 1/1       Running   0          1d
  event-broker-nats-8456c59fcc-q4qmj                                1/1       Running   4          8d
  eventbroker-go-cf967f7f5-h7vlh                                    1/1       Running   0          1d
  gatekeeper-service-5956b8f566-fh9h7                               1/1       Running   0          1d
  gatekeeper-service-evaluation-done-distributor-7447546786-f6mk2   1/1       Running   0          1d
  github-service-7c7694d879-r7tkn                                   1/1       Running   0          1d
  github-service-configure-distributor-787f669c8c-pfw4z             1/1       Running   0          1d
  github-service-create-project-distributor-69f9f64c9b-hr2z5        1/1       Running   0          1d
  github-service-new-artifact-distributor-75b8969c5b-vtgx5          1/1       Running   0          1d
  github-service-onboard-service-distributor-7d9bc4b8f7-h67mv       1/1       Running   0          1d
  helm-service-66ffc548b7-d5xwq                                     1/1       Running   0          1d
  helm-service-configuration-changed-distributor-6cd44bfd5-smmpl    1/1       Running   0          1d
  jmeter-service-7d67f8df49-4gr59                                   1/1       Running   0          1d
  jmeter-service-deployment-distributor-c59bf6bd7-58cgk             1/1       Running   0          1d
  keptn-nats-cluster-1                                              1/1       Running   0          21h
  nats-operator-67945f5c9f-5mdp2                                    1/1       Running   2          8d
  openshift-route-service-57b45c4dfc-4x5lm                          1/1       Running   0          1d (Openshift only)
  openshift-route-service-create-project-distributor-7d4454cs44xp   1/1       Running   0          1d (Openshift only)
  pitometer-service-6795d67c45-4hcds                                1/1       Running   0          1d
  pitometer-service-tests-finished-distributor-8675f778f-dksht      1/1       Running   0          1d
  servicenow-service-7b5784c589-dsrkx                               1/1       Running   0          1d
  ```
- To verify the Istio installation, retrieve all pods within the `istio-system` namespace and check whether they are in a running state:
  
  ```console
  kubectl get pods -n istio-system
  ```

  ```console
  NAME                                      READY     STATUS      RESTARTS   AGE
  istio-ingressgateway-67f6df7897-gfrvf   1/1       Running   2          8d
  istio-pilot-7884d46f6-6526d             1/1       Running   0          8d
  ```
  If that is not the case, there may have been a problem during the installation. In that case, we kindly ask you to clean your cluster and restart the installation described in the **Troubleshooting** section below.

## Uninstall

- Please follow these instructions to uninstall Keptn from your cluster:

  - Clone the keptn installer repository of the latest release:

    ``` console
    git  clone --branch 0.4.0 https://github.com/keptn/installer
    cd  ./installer/scripts/common
    ``` 

  - Execute `uninstallKeptn.sh` and all Keptn resource will be deleted

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

- **Note:** In future releases of the Keptn CLI, a command `keptn uninstall` will be added, which replaces the shell script `uninstallKeptn.sh`.

## Troubleshooting

Please note that in case of any errors, the install process might leave some files in an inconsistent state. Therefore `keptn install` cannot be executed a second time without an uninstall.
