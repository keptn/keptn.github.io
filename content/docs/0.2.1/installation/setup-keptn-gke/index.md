---
title: Install keptn on GKE
description: How to setup keptn in GKE.
weight: 10
icon: setup
keywords: setup
---

## Prerequisites
- GKE cluster
  - master version >= `1.11.x` (tested version: `1.11.7-gke.12` and `1.12.7-gke.10`)
  - one `n1-standard-8` node
    <details><summary>Expand for details</summary>
    {{< popup_image link="./assets/gke-cluster-size.png" 
      caption="GKE cluster size">}}
    </details>
  - image type `ubuntu` or `cos` (if you plan to use Dynatrace monitoring, select `ubuntu` for a more [convenient setup](../../monitoring/dynatrace/))
  - Sample script to create such cluster (adapt the values according to your needs)

    ```console
    // set environment variables
    PROJECT=nameofgcloudproject
    CLUSTERNAME=nameofcluster
    ZONE=us-central1-a
    REGION=us-central1
    GKEVERSION="1.12.7-gke.10"
    ```

    ```console
    gcloud beta container --project $PROJECT clusters create $CLUSTERNAME --zone $ZONE --no-enable-basic-auth --cluster-version $GKEVERSION --machine-type "n1-standard-8" --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --no-enable-ip-alias --network "projects/$PROJECT/global/networks/default" --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --no-enable-autoupgrade
    ```
- GitHub
  - [Own organization](https://github.com/organizations/new) for keptn to store its configuration repositories
  - [Personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line) for a user with access to said organization

      -  Needed scopes:
        
          - repo

        <details><summary>Expand Screenshot</summary>
          {{< popup_image link="./assets/github-access-token.png" 
        caption="GitHub Personal Access Token Scopes" width="50%">}}
          </details>

- Bash + Local tools
  - [jq](https://stedolan.github.io/jq/)
  - [yq](https://github.com/mikefarah/yq)
  - [git](https://git-scm.com/)
  - [helm 2.12.3](https://helm.sh/)
  - [gcloud](https://cloud.google.com/sdk/gcloud/)
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (configured to be used with your cluster) 

    ```console
    gcloud container clusters get-credentials $CLUSTERNAME --zone $ZONE --project $PROJECT
    ```


## Install keptn
- Clone the GitHub repository of the latest release.
    ```console
    git clone --branch 0.2.1 https://github.com/keptn/keptn
    ```

- Execute `./defineCredentials.sh` and provide the needed information.
    ```console
    cd keptn/install/scripts
    ./defineCredentials.sh
    ```

- Execute `./installKeptn.sh`: this script sets up all necessary component for keptn 0.2 (~10-15mins)
    ```console
    ./installKeptn.sh
    ```

    Please note that this error message during installation can be ignored:
    ```console
    Error from server (AlreadyExists): namespaces "keptn" already exists
    ```

-  **Important:** Due to a [known issue](https://issues.jenkins-ci.org/browse/JENKINS-14880) in Jenkins, it is necessary to open the Jenkins configuration and click **Save** although nothing is changed.

    You can open the configuration page of Jenkins with the credentials `admin` / `AiTx4u8VyUV8tCKk` by generating the URL and copy it in your browser (the installation has to be finished at this point):
    ```
    echo http://jenkins.keptn.$(kubectl describe svc istio-ingressgateway -n istio-system | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~').xip.io/configure
    ```

The script will install the complete infrastructure necessary to run keptn. This includes:

- Istio
- Knative
- An Elasticsearch/Kibana Stack for the keptn's log
- The keptn Core Services:
  - Event-broker
  - Event-broker-ext
  - Control
  - Authenticator
- The services required to run the delivery pipelines, as well as the self healing use cases:
  - Github Services
  - Jenkins Service
  - Pitometer Service
  - ServiceNow Service
- The channels to which events are published:
  - new-artefact
  - configuration-changed
  - deployment-finished
  - tests-finished
  - evaluation-done
  - problem




## Install keptn CLI
Every release of keptn provides binaries for the keptn CLI. These binaries are available for Linux, macOS, and Windows.

- Download the version for your operatoring system from https://github.com/keptn/keptn/releases/tag/0.2.1
- Unpack the download
- Find the `keptn` binary in the unpacked directory.
  - Linux / macOS
    
        add executable permissions (``chmod +x keptn``), and move it to the desired destination (e.g. `mv keptn /usr/local/bin/keptn`)

  - Windows

        move/copy the executable to the desired folder and, optionally, add the executable to your PATH environment variable for a more convenient experience.

- Now, you should be able to run the keptn CLI by 
    - Mac OS / Linux

        ```console
        keptn --help
        ```
    - Windows

        ```console
        .\keptn.exe --help
        ```

    Please note that for the rest of the documentation we will stick to the Mac OS / Linux version of the commands.

## Verifying the installation

- Run the following command to get the **EXTERNAL-IP** and **PORT** of your cluster's ingress gateway.
    ```console    
    kubectl get svc istio-ingressgateway -n istio-system
    ```

    ```console
    NAME                     TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)
    istio-ingressgateway     LoadBalancer   10.11.246.127   <EXTERNAL_IP>   80:32399/TCP 
    ```

- Go to Jenkins at `http://jenkins.keptn.<EXTERNAL_IP>.xip.io/` and login with the credentials `admin` / `AiTx4u8VyUV8tCKk`
  <br><br>**Note:** For security reasons, we recommend to change these credentials right after the first login:
  1. Change credentials in Jenkins
  1. Update credentials in the kubernetes secret named `jenkins-secret` in the `keptn` namespace, by using the following command. Please note that the password has to be base64 encoded.
  ```console
  kubectl edit secret jenkins-secret -n keptn     
  ```

  1. Restart the `jenkins-service` pod.
 ```
kubectl delete pod $(kubectl get pods -n keptn | awk '/jenkins-service/' | awk '{print $1}') -n keptn
 ``` 
  <br><br>

  Navigate to **Jenkins** > **Manage Jenkins** > **Configure System**, scroll to the environment variables and verify that the variables are set correctly.
  {{< popup_image link="./assets/jenkins-env-vars.png" caption="Jenkins environment variables">}}
  **Important:** Due to a [known issue](https://issues.jenkins-ci.org/browse/JENKINS-14880) in Jenkins, it is necessary to click **Save** although nothing is changed in this verification step.

- To verify your installation, retrieve the pods runnning in the `keptn` namespace.
  ```console
  kubectl get pods -n keptn
  ```

  ```console
  authenticator-h7ftc-pod-cd730a                      0/1       Completed   0          10d
  authenticator-hghrm-deployment-85985b6c56-894zm     3/3       Running     0          10d
  control-9hw4x-pod-7d4b93                            0/1       Completed   0          10d
  control-tjkl6-deployment-5bb45669c6-8h2d6           3/3       Running     0          10d
  docker-registry-754b7797bd-v86pn                    2/2       Running     0          10d
  event-broker-2fwtg-deployment-ffdd57984-t8jbn       3/3       Running     0          23m
  event-broker-bcsdr-pod-15d743                       0/1       Completed   0          25m
  event-broker-ext-2rndl-pod-0fe9f3                   0/1       Completed   0          10d
  event-broker-ext-8wn6q-deployment-7bc86dcd9-zjc7r   3/3       Running     0          10d
  github-service-gl2f9-deployment-854f4d747b-dhz89    3/3       Running     0          10d
  github-service-kt7x5-pod-cd2884                     0/1       Completed   0          10d
  jenkins-deployment-69fb95d575-mz6fp                 2/2       Running     0          10d
  jenkins-service-82wsp-deployment-74f9f78856-k5z5f   3/3       Running     0          56m
  jenkins-service-ghcpz-pod-1f5a6a                    0/1       Completed   0          57m
  pitometer-service-v8n47-pod-99ace2                  0/1       Completed   0          1d
  servicenow-service-bj9hv-pod-650ed4                 0/1       Completed   0          7d
  ```
  If those pods do not show up after a few minutes, please check if all pods within the `istio-system` pods are in a running state: 
  
  ```console
  kubectl get pods -n istio-system
  ```

  ```console
  cluster-local-gateway-775b6cbf4c-bxxx8    1/1       Running
  istio-citadel-796c94878b-fhzf8            1/1       Running
  istio-cleanup-secrets-nbdff               0/1       Completed
  istio-egressgateway-864444d6ff-g7c6m      1/1       Running
  istio-galley-6c68c5dbcf-fzdzb             1/1       Running
  istio-ingressgateway-694576c7bb-w52j7     1/1       Running
  istio-pilot-79f5f46dd5-c62bv              2/2       Running
  istio-pilot-79f5f46dd5-wjwmf              2/2       Running
  istio-pilot-79f5f46dd5-zgbwm              2/2       Running
  istio-policy-5bd5578b94-nggnx             2/2       Running
  istio-sidecar-injector-6d8f88c98f-mqrpj   1/1       Running
  istio-telemetry-5598f86cd8-7s4t7          2/2       Running
  istio-telemetry-5598f86cd8-bzfb5          2/2       Running
  istio-telemetry-5598f86cd8-hxkhm          2/2       Running
  istio-telemetry-5598f86cd8-pgstj          2/2       Running
  istio-telemetry-5598f86cd8-wkh7g          2/2       Running
  zipkin-6b4d5d66-jwqzk                     1/1       Running
  ```

  Next, please check the pods in the `knative-serving` namespace:

  ```console
  kubectl get pods -n knative-serving
  ```

  ```console
  activator-6f7d494f55-fthpr    2/2       Running
  autoscaler-5cb4d56d69-qz7dh   2/2       Running
  controller-6d65444c78-8wqb8   1/1       Running
  webhook-55f88654fb-tq8ps      1/1       Running
  ```

  Next, check that all routes for the core services, as well as for the jenkins-service, pitometer-service, github-service and servicenow-service have been created:

  ```console
  kubectl get routes -n keptn
  ```

  ```console
  authenticator        10d
  control              10d
  event-broker         16m
  event-broker-ext     10d
  github-service       10d
  jenkins-service      48m
  pitometer-service    1d
  servicenow-service   7d
  ```

  The channels have to be created as well:

  ```console
  kubectl get channels -n keptn
  ```

  ```console
  configuration-changed   10d
  deployment-finished     10d
  evaluation-done         10d
  keptn-channel           10d
  new-artefact            10d
  problem                 10d
  start-deployment        10d
  start-evaluation        10d
  start-tests             10d
  tests-finished          10d
  ```

  If that is not the case, there may have been a problem during the installation. In that case we kindly ask you to clean your cluster and restart the installation, as described in the **Troubleshooting** section below.


## Authenticate keptn CLI and configure keptn

1. The CLI needs to be authenticated against the keptn server. Therefore, please copy the values from your installation log output into the next command and execute it:

    ```console
    keptn auth --endpoint=YOUR_ENDPOINT --api-token=YOUR_TOKEN
    ```

1. Configure the used GitHub organization, user, and personal access token using the `keptn configure` command:
  
    ```console
    keptn configure --org=<YOUR_GITHUB_ORG> --user=<YOUR_GITHUB_USER> --token=<YOUR_GITHUB_TOKEN>
    ```


## Uninstall
- Execute `./uninstallKeptn.sh` and all keptn resource will be deleted

  ```console
  cd keptn
  ./install/scripts/uninstallKeptn.sh
  ```
- To verify the cleanup, retrieve the list of namespaces in your cluster, and ensure that the `keptn` namespace is not included in the output of the following command:

  ```console
  kubectl get namespaces
  ```

- *Note*: In some cases, it might occure that the `keptn` namespace remains stuck in the `Terminating` state. If that happens, you can enforce the deletion of the namespace as follows:

  ```console
  NAMESPACE=keptn
  kubectl proxy &
  kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json
  curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
  rm temp.json
  ```


## Troubleshooting

Please note that in case of any errors, the install script might leave some files in a inconsistent state, therefore the `installKeptn.sh` file can not be run a second time without a cleanup. To prevent any issues with subsequent setup runs, we recommend to fully delete the GitHub organization, the keptn installation folder and checkout the keptn release again. (Some files may have been edited already that are not reverted in case of aborting the setup script.)
