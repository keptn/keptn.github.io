---
title: Upgrade keptn on GKE
description: How to upgrade keptn in GKE.
weight: 11
icon: setup
keywords: setup
---

For upgrading an existing keptn 0.2.0 or 0.2.1 installation, an upgrade script is provided. This will update all keptn core components to their new version and installs the keptn's bridge.

## Prerequisites
   
- Please note that all [command line tools](../setup-keptn-gke#prerequisites) are needed when upgrading keptn.
  
    - Additionally, [yq](https://github.com/mikefarah/yq) is required.
  
- Make sure you are connected with the cluster running the keptn installation, which should be upgraded. Verify the connection by 
  using the following command:

  ``` console
  kubectl config current-context
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

- Instructions for creating a project are provided [here](../../usecases/onboard-carts-service/#create-project-sockshop).

- Instructions for onboarding a service are provided [here](../../usecases/onboard-carts-service/#onboard-carts-service-and-carts-database).