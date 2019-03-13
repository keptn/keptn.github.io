---
title: Onboarding the carts service
description: Shows you how to onboard the carts service including its database.
weight: 20
keywords: [onboarding]
aliases:
---

Shows you how to onboard the carts service including its database. Besides, this use case builds and deploys a new artifact.

## About this use case

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

## Step 1: Authenticate against keptn and create project

  ```console
  $ keptn auth --endpoint=https://contorl.keptn.***.239.5.***.xip.io --api-token=***
  ```

  ```console
  $ keptn create project sockshop shipyard.yaml
  ```

## Step 2: Onboard carts service

  ```console
  $ keptn onboard service --project=sockshop --values=values_carts.yaml
  ```

## Step 3: Onboard carts database

  ```console
  $ keptn onboard service --project=sockshop --values=values_carts_db.yaml --deployment=deployment.yaml --service=service.yaml
  ```

## Step 4: Fork carts example into your repository

1. Go to `https://github.com/keptn-sockshop/carts` and click on the **Fork** button on the top right corner.

1. Select the Github repository you use for keptn.

## Step 5: Add CI pipeline to Jenkins

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

## Step 6: Build new artifact and watch keptn doing the deployment 

1. After creating the CI pipeline, in Jenkins go to **carts** > **master** > **Build Now**.

1. Go back to the Jenkins dashboard to see how the invidiual steps of the CD pipeline get triggered.
