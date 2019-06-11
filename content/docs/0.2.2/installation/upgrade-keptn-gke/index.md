---
title: Upgrade keptn on GKE
description: How to upgrade keptn in GKE.
weight: 11
icon: setup
keywords: setup
---

For upgrading an existing keptn 0.2.0 or 0.2.1 installation, an upgrade script is provided. This will update all keptn core components to their new version and installs the keptn's bridge.
Furthermore, a new version of the CLI needs to be downloaded.

## Prerequisites
   
- Please note that all [command line tools](../setup-keptn-gke#prerequisites) are needed when upgrading keptn.
  
    - Additionally, [yq](https://github.com/mikefarah/yq) is required.

- Furthermore, please note that we increaded the GKE cluster size to one `n1-standard-16` node.

- Make sure you are connected with the cluster running the keptn installation, which should be upgraded. Verify the connection by 
  using the following command:

  ``` console
  kubectl config current-context
  ```
## Upgrade keptn CLI

- Download the version for your operating system from https://github.com/keptn/keptn/releases/tag/0.2.2
- Unpack the download
- Find the `keptn` binary in the unpacked directory.
  - Linux / macOS
    
        add executable permissions (``chmod +x keptn``), and move it to the desired destination (e.g. `mv keptn /usr/local/bin/keptn`)

  - Windows

        move/copy the executable to the desired folder and, optionally, add the executable to your PATH environment variable for a more convenient experience.

- For double checking the version of the CLI, run the `version` command in the CLI: 
    - Linux / macOS

    ```console
    keptn version
    ```

    ```console
    CLI version: 0.2.2
    ```
    
    - Windows

    ```console
    .\keptn.exe version
    ```

     ```console
    CLI version: 0.2.2
    ```

## Upgrade keptn from 0.2.x to 0.2.2

- Clone the keptn installer repository of the latest release:

  ``` console
  git  clone --branch 0.2.2 https://github.com/keptn/installer
  ``` 

- Navigate to the scripts folder:

  ```
  cd  ./installer/scripts
  ```

- Run the keptn upgrade script:

  ```
  ./upgradeKeptn.sh github_username github_access_token
  ```

-  **Important:** Due to a [known issue](https://issues.jenkins-ci.org/browse/JENKINS-14880) in Jenkins, it is necessary to open the Jenkins configuration and click **Save** although nothing is changed.

    You can open the configuration page of Jenkins with the credentials `admin` / `AiTx4u8VyUV8tCKk` by taking the URL from the upgrade script or generating it and copying it in your browser:

  ```
  echo http://jenkins.keptn.$(kubectl describe svc istio-ingressgateway -n istio-system | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer  Ingress:[ \t]*~~').xip.io/configure
  ```

- **Note:** In future releases of the keptn CLI, a command `keptn upgrade` will be added, which replaces the shell script `upgradeKeptn.sh`.

## Create project and onboard services

Due to a breaking change from keptn 0.2.1 to 0.2.2 regarding the naming convention of Kubernetes namespaces, it is necessary to re-create a keptn project and to onboard your services again.

- Delete your configuration repository in your GitHub organization.

- Delete your releases using [Helm](https://helm.sh):

  ``` console
  helm ls
  ```

  ``` console
  NAME               	REVISION	UPDATED                 	STATUS  	CHART         	APP VERSION	NAMESPACE 
  sockshop-dev       	1       	Wed May 29 10:59:56 2019	DEPLOYED	sockshop-0.1.0	           	dev       
  sockshop-production	1       	Wed May 29 11:12:44 2019	DEPLOYED	sockshop-0.1.0	           	production
  sockshop-staging   	1       	Wed May 29 11:07:16 2019	DEPLOYED	sockshop-0.1.0	           	staging 
  ```

  ``` console
  helm delete --purge sockshop-dev
  helm delete --purge sockshop-production
  helm delete --purge sockshop-staging
  ```

  ``` console
  release "sockshop-dev" deleted
  release "sockshop-staging" deleted
  release "sockshop-production" deleted
  ```

- Instructions for creating a project are provided [here](../../usecases/onboard-carts-service/#create-project-sockshop).

- Instructions for onboarding a service are provided [here](../../usecases/onboard-carts-service/#onboard-carts-service-and-carts-database).

## Upgrade monitoring

If Dynatrace is used for monitoring, please follow the upgrade instructions [here](../../monitoring/dynatrace/#upgrade-dynatrace-monitoring-for-keptn-0.2.2).