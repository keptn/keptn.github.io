---
title: Onboarding the carts service
description: Shows you how to onboard the carts service including its database.
weight: 20
keywords: [onboarding]
aliases:
---

Shows you how to onboard the carts service including its database. Besides, this use case builds and deploys a new artifact that will be automatically deployed via keptn.

## About this use case

The goal of this use case is to automatically deploy a service - and new artifacts of this service - into a multi-stage environment using keptn. The stages of the environment are described in a *shipyard* file that defines the name, deployment strategy and test strategy of each stage. In case an additional stage is needed, the shipyard file can be easily extended by a stage definition before creating the project. After creating the project, the service that is going to be managed by keptn need to be onboarded. Therefore, keptn provides the functionality to create the deployment and service definition of the onboarded service for each stage. 

To illustrate the scenario this use case addresses, keptn relies on two services: github-service and jenkins-service. These services have the following responsibilities: 
* **github-service**: 
  
  * Creating a project
  * Onboarding a service
  * Listening to a new artefact event - to update the reference to the new artifact in the service configuration. 

* **jenkins-service**:
  
  * Listening to configuration changed event - to deploy a service based on the new configuration.
  * Listening to a deployment finised event - to test a freshly deployed service.
  * Listening to a test finished event - to promote the service to the next stage meaning to send a new artifact event for the next stage. 

## Prerequisits

1. A GitHub organization, user, and personal access token, which are used by keptn 

1. The endpoint and API token provided by the keptn installation.

1. Git clone artifacts for this use case.

    ```console
    $ cd ~
    $ git clone https://github.com/keptn/examples.git
    ```

## Step 1: Authenticate, configure keptn and create project

1. Authentication against the keptn installation using the `keptn auth` command:

    ```console
    $ keptn auth --endpoint=https://contorl.keptn.***.239.5.***.xip.io --api-token=***
    ```

1. Configure the used GitHub organization, user, and personal access token using the `keptn configure` command:
  
    ```console
    keptn configure --org=keptn-tiger --user=johannes-b --token=**
    ```

1. Create a new project for your carts service. In this example, the project is called *sockshop*.

    ```console
    $ cd ~/examples/onboarding-carts
    $ ls
    deployment.yaml  service.yaml  shipyard.yaml  values_carts.yaml  values_carts_db.yaml
    $ keptn create project sockshop shipyard.yaml
    ```

## Step 2: Onboard carts service and carts database
After creating the project, you are ready to onboard the first service.

1. Onboard the `carts` service using the `keptn onboard service` command. In this onboarding scenario, a default deployment and service template will be provided by the github-service.

    ```console
    $ keptn onboard service --project=sockshop --values=values_carts.yaml
    ```

1. Onboard the `carts-db` service using the `keptn onboard service` command. In this onboarding scenario, the  deployment and service files are handed over to the github-service.

    ```console
    $ keptn onboard service --project=sockshop --values=values_carts_db.yaml --deployment=deployment.yaml --service=service.yaml
    ```

## Step 3: Fork carts example into your GitHub organization

1. Go to `https://github.com/keptn-sockshop/carts` and click on the **Fork** button on the top right corner.

1. Select the Github repository you use for keptn.

## Step 4: Add CI pipeline to Jenkins

1. Run the `kubectl get svc` command to get the **EXTERNAL-IP** of the Istio ingress gateway.  
    
    **Note:** It is highly recommended to change these credentials right after the first login.

    ```console
    $ kubectl get svc istio-ingressgateway -n istio-system
    NAME                    TYPE            CLUSTER-IP      EXTERNAL-IP       PORT(S)                            AGE
    istio-ingressgateway    LoadBalancer    10.23.245.***   ***.198.26.***    80:32399/TCP,443:31203/TCP,...     10m
    ``` 

1. Then use a browser to open Jenkins with the url `jenkins.keptn.EXTERNAL-IP.xip.io` and login using the default Jenkins credentials: `admin` / `AiTx4u8VyUV8tCKk`.

1. Afterwards, click on the **New Item** button and enter `carts` as name.

1. Select **Multibranch Pipeline** and click on **OK**.
    1. At *Branch Source* select *Git* and specify at *Project Repository* the github repository of your forked carts service.
    1. At *Build Configurtion* add the extension `.ci` to the Jenkinsfile.

      {{< popup_image
      link="./assets/carts_ci.png"
      caption="CI Pipeline config for carts">}}

## Step 5: Build new artifact and watch keptn doing the deployment 

1. After creating the CI pipeline, in Jenkins go to **carts** > **master** > **Build Now**.

1. Go back to the Jenkins dashboard to see how the invidiual steps of the CD pipeline get triggered.
