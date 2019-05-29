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
  - one `n1-standard-16` node
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
    gcloud beta container --project $PROJECT clusters create $CLUSTERNAME --zone $ZONE --no-enable-basic-auth --cluster-version $GKEVERSION --machine-type "n1-standard-16" --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --no-enable-ip-alias --network "projects/$PROJECT/global/networks/default" --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --no-enable-autoupgrade
    ```
- GitHub
  - [Own organization](https://github.com/organizations/new) for keptn to store its configuration repositories
  - [Personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line) for a user with access to said organization

      -  Needed scopes: [x] `repo`

        <details><summary>Expand Screenshot</summary>
          {{< popup_image link="./assets/github-access-token.png" 
        caption="GitHub Personal Access Token Scopes" width="50%">}}
          </details>

- Bash + Local tools
  - [gcloud](https://cloud.google.com/sdk/gcloud/)
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (configured to be used with your cluster) 
  - [git](https://git-scm.com/)
  - (required for Ubuntu 19.04) [python 2.7](https://www.python.org/downloads/release/python-2716/)

    ```console
    gcloud container clusters get-credentials $CLUSTERNAME --zone $ZONE --project $PROJECT
    ```

## Install keptn CLI
Every release of keptn provides binaries for the keptn CLI. These binaries are available for Linux, macOS, and Windows.

- Download the version for your operating system from https://github.com/keptn/keptn/tree/develop
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
in the version of the latest release.

    ```console
    keptn install
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
            <li>The services required to run the delivery pipelines and the self-healing use cases:</li>
                <ul>
                    <li>github-services</li>
                    <li>jenkins-service</li>
                    <li>pitometer-service</li>
                    <li>serviceNow-service</li>
                </ul>
            <li>The channels to which events are published:</li>
                <ul>
                    <li>configuration-changed</li>
                    <li>deployment-finished</li>
                    <li>evaluation-done</li>
                    <li>keptn-channel</li>
                    <li>new-artefact</li>
                    <li>problem</li>
                    <li>tests-finished</li>
                </ul>
            </ul>
        </details>


- **Important:** Due to a [known issue](https://issues.jenkins-ci.org/browse/JENKINS-14880) in Jenkins, it is necessary to open the Jenkins configuration and click **Save** although nothing is changed.

    You can open the configuration page of Jenkins with the credentials `admin` / `AiTx4u8VyUV8tCKk` by generating the URL and copy it in your browser (the installation has to be finished at this point):
    
    ```
    echo http://jenkins.keptn.$(kubectl get svc istio-ingressgateway -n istio-system -ojsonpath={.status.loadBalancer.ingress[0].ip}).xip.io/configure
    ```

## Verifying the installation

- Run the following command to get the **EXTERNAL-IP** and **PORT** of your cluster's ingress gateway.
  
  ```console    
  kubectl get svc istio-ingressgateway -n istio-system
  ```

  ```console
  NAME                     TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)
  istio-ingressgateway     LoadBalancer   10.11.246.127   <EXTERNAL_IP>    80:32399/TCP 
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
  kubectl delete pod $(
  | awk '/jenkins-service/' | awk '{print $1}') -n keptn
  ``` 

- Navigate to **Jenkins** > **Manage Jenkins** > **Configure System**, scroll to the environment variables and verify that the variables are set correctly.
  {{< popup_image link="./assets/jenkins-env-vars.png" caption="Jenkins environment variables">}}
  **Important:** Due to a [known issue](https://issues.jenkins-ci.org/browse/JENKINS-14880) in Jenkins, it is necessary to click **Save** although nothing is changed in this verification step.

- To verify your keptn installation, retrieve the pods running in the `keptn` namespace.

  ```console
  kubectl get pods -n keptn
  ```

  ```console
  NAME                                                 READY     STATUS    RESTARTS   AGE
  authenticator-fvq2c-deployment-565597c98c-fqj46      3/3       Running   0          30m
  control-kwhms-deployment-6d7b8b8d94-v7xsj            3/3       Running   0          30m
  docker-registry-66bb5d6d98-rz5pl                     2/2       Running   0          30m
  event-broker-ext-2v84b-deployment-856cf65b99-96zpd   3/3       Running   0          30m
  event-broker-z8tc6-deployment-7997b998b4-jhvq4       3/3       Running   0          30m
  github-service-xcn9w-deployment-545866fc6f-hl4gc     3/3       Running   0          30m
  jenkins-deployment-78dcd99964-zntbz                  2/2       Running   0          30m
  jenkins-service-p4j5d-deployment-64755bddd7-7cbnp    3/3       Running   0          30m
  ```

- Next, check that all routes for the keptn core services, as well as for the bridge, jenkins-service, pitometer-service, github-service, and servicenow-service have been created:

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
  github-service       31m
  jenkins-service      31m
  pitometer-service    31m
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
  new-artefact            31m
  problem                 31m
  start-deployment        31m
  start-evaluation        31m
  start-tests             31m
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
- Clone the keptn installer repository of the latest release:

  ``` console
  git  clone --branch 0.2.2 https://github.com/keptn/installer
  cd  ./installer/scripts
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
