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
Every release of keptn provides binaries for the keptn CLI. These binaries are available for Linux, macOS, and Windows.

- Download the version for your operating system from https://github.com/keptn/keptn/releases/tag/0.4.0
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

- Execute the CLI command `keptn install` and provide the requested information. This command will install keptn in the version of the latest release. Since v0.3 of keptn, the install command accepts a parameter to select the platform you would like to install keptn on. Currently supported platforms are Google Kubernetes Engine (GKE), OpenShift and Azure Kubernetes Services (AKS). Depending on your platform, enter the following command to start the installation:

  - For **GKE**:
    ```console
    keptn install --platform=gke
    ```

  - For **OpenShift**:
    ```console
    keptn install --platform=openshift
    ```
    <details><summary>Configure a custom domain</summary>
    <p>
    In case you have a custom domain or can not use xip.io (e.g., because you are running in AWS which will create ELBs for you), there is a script provided to configure keptn to use your custom domain.
    Checkout the script:
    ```console
    git clone --branch 0.4.0 https://github.com/keptn/installer 
    cd installer/scripts/common
    ```
    Run the script:
    ```console
    ./updateDomain.sh YOURDOMAIN
    ```
    This will provide you a KEPTN_ENDPOINT and KEPTN_API_TOKEN at the end of the script which you can use to [authenticate the keptn CLI](../../reference/cli/#keptn-auth).
    </p>
    </details>


  - For **AKS**:
    ```console
    keptn install --platform=aks
    ```

    In your cluster, this command installs the complete infrastructure necessary to run keptn. 
        <details><summary>This includes:</summary>
            <ul>
            <li>Istio</li>
            <li>An Elasticsearch/Kibana Stack for the keptn's log</li>
            <li>A NATS Cluster</li>
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
            </ul>
        </details>


## Verifying the installation

- To verify your keptn installation, retrieve the pods running in the `keptn` namespace.

  ```console
  kubectl get pods -n keptn
  ```

  ```console
  NAME                                                              READY     STATUS    RESTARTS   AGE
  authenticator-75ffd6bbdc-8tks2                                    1/1       Running   0          2m
  bridge-d5bc7c9b6-72h6n                                            1/1       Running   0          2m
  control-599858b499-b8rmf                                          1/1       Running   0          2m
  event-broker-ext-796fbb94f6-2dcs7                                 1/1       Running   0          2m
  eventbroker-go-77d4fc7fdd-rmzxk                                   1/1       Running   0          2m
  gatekeeper-service-787c6f7d84-j8s4f                               1/1       Running   0          1m
  gatekeeper-service-evaluation-done-distributor-5b5f77c6ff-fhbbq   1/1       Running   0          32s
  github-service-78d59d549d-qdfzg                                   1/1       Running   0          1m
  github-service-configure-distributor-5955b674d6-7d44w             1/1       Running   0          33s
  github-service-create-project-distributor-79fcbb7855-t9blj        1/1       Running   0          34s
  github-service-new-artifact-distributor-5cf8d5c6f5-5szdt          1/1       Running   0          33s
  github-service-onboard-service-distributor-56db7595cb-z2qkx       1/1       Running   0          34s
  helm-service-85c9cbc96f-7t86h                                     1/1       Running   0          1m
  helm-service-configuration-changed-distributor-545b8849b-wl2pq    1/1       Running   0          33s
  jmeter-service-65b474cd75-pxn2m                                   1/1       Running   0          1m
  jmeter-service-deployment-distributor-687b778dfd-twqrp            1/1       Running   0          33s
  keptn-nats-cluster-1                                              1/1       Running   0          2m
  nats-operator-67d8dd94d5-wjlsj                                    1/1       Running   0          3m
  openshift-route-service-57b45c4dfc-4x5lm                          1/1       Running   0          1d (OpenShift only)
  openshift-route-service-create-project-distributor-7d4454cs44xp   1/1       Running   0          1d (OpenShift only)
  pitometer-service-56d75f9fcc-hcbbw                                1/1       Running   0          1m
  pitometer-service-tests-finished-distributor-785bdc79d4-xbnpb     1/1       Running   0          33s
  servicenow-service-86d6dfb7f7-dqcx6                               1/1       Running   0          1m
  servicenow-service-problem-distributor-6d4fc577d9-wmfn4           1/1       Running   0          32s
  ```
- To verify the Istio installation, retrieve all pods within the `istio-system` namespace and check whether they are in a running state:
  
  ```console
  kubectl get pods -n istio-system
  ```

  ```console
  NAME                                    READY     STATUS    RESTARTS   AGE
  istio-ingressgateway-6f46678699-c742n   1/1       Running   0          5m
  istio-pilot-85b956b4bb-rbhnn            1/1       Running   0          5m
  ```
  If that is not the case, there may have been a problem during the installation. In that case, we kindly ask you to clean your cluster and restart the installation described in the **Troubleshooting** section below.

## Uninstall

- Please follow these instructions to uninstall keptn from your cluster:

  - Clone the keptn installer repository of the latest release:

    ``` console
    git  clone --branch 0.4.0 https://github.com/keptn/installer
    cd  ./installer/scripts/common
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
