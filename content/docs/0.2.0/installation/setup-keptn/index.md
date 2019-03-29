---
title: Setup keptn
description: How to setup keptn in Kubernetes.
weight: 10
icon: setup
keywords: setup
---

## Prerequisites
- GKE cluster
  - master version >= `1.10.11`
  - one `n1-standard-8` node
  - image type `ubuntu` or `cos`
- GitHub
  - Organization for configuration repositories
  - Personal access token for a user with access to said organization
- Bash + Local tools
  - [jq](https://stedolan.github.io/jq/), [yq](https://github.com/mikefarah/yq), [git](https://git-scm.com/), [gcloud](https://cloud.google.com/sdk/gcloud/), [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/), [helm 2.12.3](https://helm.sh/)

## Install keptn
- Clone the GitHub repository of the latest release branch
    ```console
    $ git clone --branch prerelease-0.2.x https://github.com/keptn/keptn
    ```

- Execute `./defineCredentials.sh` and provide the needed information
    ```console
    $ cd keptn/install/scripts
    $ ./defineCredentials.sh
    ```

- Execute `./installKeptn.sh`: this script sets up all necessary component for keptn 0.2 (~10-15mins)
    ```console
    $ ./installKeptn.sh
    ```

## Install keptn CLI
Every release of keptn provides binaries for the keptn CLI. These binaries are available for Linux, macOS, and Windows.

- Download your [desired version](https://github.com/keptn/keptn/releases/)
- Unpack the download
- Find the `keptn` binary in the unpacked directory.
  - Linux / macOS
    
        add executable permissions (``chmod +x keptn``), and move it to the desired destination (e.g. `mv keptn /usr/local/bin/keptn`)

  - Windows

        move/copy the executable to the desired folder

- Now, you should be able to run the keptn CLI by 
    ```console
    keptn --help
    ```

## Verifying the installation

- Run the following command to get the **EXTERNAL-IP** and **PORT** of your cluster's ingress gateway.
    ```console    
    $ kubectl get svc istio-ingressgateway -n istio-system
    NAME                     TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)
    istio-ingressgateway     LoadBalancer   10.11.246.127   <EXTERNAL_IP>   80:32399/TCP 
    ```

- Go to Jenkins at `http://jenkins.keptn.<EXTERNAL_IP>.xip.io/` and login with the credentials `admin` / `AiTx4u8VyUV8tCKk`.
  <br><br>**Note:** Please change these credentials right after the first login!<br><br>
  Navigate to **Jenkins** > **Manage Jenkins** > **Configure System**, scroll to the environment variables and verify that the variables are set correctly.
  {{< popup_image link="./assets/jenkins-env-vars.png" caption="Jenkins environment variables">}}
  Due to a [known issue](https://issues.jenkins-ci.org/browse/JENKINS-14880) in Jenkins, it is necessary to click **Save** although nothing is changed in this verification step.

- To verify your installation, retrieve the pods runnning in the `keptn` namespace.
  ```console
  $ kubectl get pods -n keptn
  authenticator-85jzg-deployment-6c5b596998-b5lhc       3/3       Running
  control-zbpdw-deployment-6b5bdcf9b7-4djv4             3/3       Running
  docker-registry-55bd8d967c-lx8z6                      2/2       Running
  event-broker-ext-grqwq-deployment-76fc5975fb-9s2ct    3/3       Running
  event-broker-vqw2d-deployment-db6bdcf99-jgkfr         3/3       Running
  jenkins-deployment-84d5d5d8d7-lt5sw                   2/2       Running
  ```
  If those pods do not show up after a few minutes, please check if all pods within the `istio-system` pods are in a running state. If that is not the case, there may have been a problem during the Istio installation. In that case we kindly ask you to clean your cluster and restart the installation, as described in the **Troubleshooting** section below
- Channels
- keptn help

## Uninstall
- Execute `./uninstallKeptn.sh` and all keptn resource will be deleted

  ```console
  $ cd keptn
  $ ./scripts/uninstallKeptn.sh
  ```
- To verify the cleanup, retrieve the list of namespaces in your cluster, and ensure that the `keptn` namespace is not included in the output of the following command:

  ```console
  $ kubectl get namespaces
  ```

- *Note*: In some cases, it might occure that the `keptn` namespace remains stuck in the `Terminating` state. If that happens, you can enforce the deletion of the namespace as follows:

  ```console
  $ NAMESPACE=keptn
  $ kubectl proxy &
  $ kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json
  $ curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
  $ rm temp.json
  ```


## Troubleshooting

Please note that in case of any errors, the install script might leave some files in a inconsistent state, therefore the `installKeptn.sh` file can not be run a second time without a cleanup. To prevent any issues with subsequent setup runs, we recommend to fully delete the GitHub organization, the keptn installation folder and checkout the keptn release again. (Some files may have been edited already that are not reverted in case of aborting the setup script.)
