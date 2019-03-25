---
title: Production Deployments
description: Gives an overview of production deployments, deployment strategies, and depicts those using Istio on Kubernetes to canary-deploy a new front-end version.
weight: 20
keywords: []
aliases:
---

This use case gives an overview of production deployments, deployment strategies, and depicts those using Istio on Kubernetes to canary-deploy a new service version.

## About this use case

When developing an application, sooner or later you need to update a service in a production environment. To conduct this in a controlled manner and without impacting end-user experience,  deployment strategies must be in place. For example, blue-green or canary deployment are well known strategies to rollout a new service version. Additionally, these strategies keep the previous service available if something goes wrong.

To illustrate the benefit this use case addresses, you will create a second version of the carts service. Then, this version will be deployed to the production environment in a dark-launch manner. To route traffic to this new service version, the configuration of a virtual service will be changed by setting weights for the routes. In other words, this configuration change defines how much traffic is routed to the old and to the new version of the carts service.

## Step 1: Deploy carts v1 and clone the forked repository

1. Complete the use case [Onboarding a Service](../onboard-carts-service/index.md).

1. Clone the forked carts service to your local machine.

    ```console
    $ cd ~
    $ git clone https://github.com/your-github-org/carts.git
    $ cd carts
    ```

## Step 2: Verify Istio installation and access ingress gateway

<!--
1. Ensure that the label `istio-injection` has been applied to the production namespace by executing the `kubectl get namespace -L istio-injection` command:

    ```console
    $ kubectl get namespace -L istio-injection
    NAME           STATUS    AGE       ISTIO-INJECTION
    keptn          Active    10h
    default        Active    10h
    dev            Active    10h
    istio-system   Active    10h        disabled
    kube-public    Active    10h
    kube-system    Active    10h
    production     Active    10h        enabled
    staging        Active    10h        enabled
    ```
-->

1. Run the `kubectl get svc istio-ingressgateway -n istio-system` command to get the *EXTERNAL-IP* of your *Gateway*.

    ```console
    $ kubectl get svc istio-ingressgateway -n istio-system
    NAME                   TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                                      AGE
    istio-ingressgateway   LoadBalancer   172.21.109.129   3*.2**.1**.8*   80:31380/TCP,443:31390/TCP,31400:31400/TCP   17h
    ```

1. Open browser and navigate to: `http://carts.production.EXTERNAL-IP.xip.io/version`
  
## Step 3. Create carts v2 with slowdown
In this step, you will change the version number of the carts service to see the effect of traffic routing between two different artefact versions.

1. In the directory of your `carts` repository:
    * open the file `version` and change `0.6.0` to `0.6.1`.
    * open the file `src/main/resources/application.properties` and change `version=v1` to `version=v2` and  `delayInMillis=0` to `delayInMillis=1000`.

1. Save the changes.

1. Commit the changes and then push it to the remote git repository.

    ```console
    $ git add .
    $ git commit -m "Increased the service version."
    $ git push
    ```

<!--
## Step 4. Change Istio traffic routing (manually)
In this step, you will configure traffic routing in Istio to redirect traffic to both versions of the `carts` service.

1. Go to your github organization used by keptn (i.e., the github organization used for `keptn configure`).

1. Click on the repository called `sockshop` and change the branch to `production`.

1. Click on `helm-chart`, `templates` and open the file `istio-virtual-service-carts.yaml`.

1. Click on `Edit this file` [1] and change the weights [2] as shown in the screenshot below:

      {{< popup_image
      link="./assets/istio_traffic.png"
      caption="Traffic routing configuration for carts">}}

1. Finally, click on *Commit changes*.
--> 
## Step 4. Deploy carts v2 to production

1. Trigger the CI pipeline for the `carts` service to create a new artefact.

1. When the artifact is pushed to the docker registry, the configuration of the service is automatically updated and the CD pipeline gets triggered.

1. Watch keptn deploying the new artefact.
  * The Jenkins `deploy` pipeline deploys the new artifact to dev.
  * The Jenkins `test` pipeline runs a basic health check and functional check in dev.
  * The Jenkins `evaluate` pipeline does a test validation and sends a new artefact event for staging.
  * The Jenkins `deploy` pipeline deploys the new artifact to staging using a blue/green deployment strategy.
  * The Jenkins `test` pipeline runs a performance test in staging.
  * The Jenkins `evaluate` pipeline fails since the quality gate is not passed. This automatically switches re-routes traffic to the previous color (blue or green).

## Step 5. Create carts v3 without slowdown
In this step, you will change the version number of the carts service to see the effect of traffic routing between two different artefact versions.

1. In the directory of your `carts` repository:
    * open the file `version` and change `0.6.1` to `0.6.2`.
    * open the file `src/main/resources/application.properties` and change `version=v2` to `version=v3` and  `delayInMillis=1000` to `delayInMillis=0`.

1. Save the changes.

1. Commit the changes and then push it to the remote git repository.

    ```console
    $ git add .
    $ git commit -m "Increased the service version."
    $ git push
    ```

## Step 6. Deploy carts v3 to production and verify result

1. Trigger the CI pipeline for the `carts` service to create a new artefact.

1. When the artifact is pushed to the docker registry, the configuration of the service is automatically updated and the CD pipeline gets triggered.

1. In this case, the quality gate is passed and the service gets deployed in the production namespace. 

1. To verify the deployment in production, open a browser an navigate to: `http://carts.production.EXTERNAL-IP.xip.io/version`. As a result, you see `Version = v3`.

1. Besides, you can verify the deployments in you K8s cluster using the following commands: 

    ```console
    $ kubectl get deployments -n production
    NAME             DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    carts-blue       1         1         1            0           1h
    carts-db-blue    1         1         1            0           1h
    carts-db-green   1         1         1            0           1h
    carts-green      1         1         1            0           1h
    ```

    ```console
    $ kubectl describe deployment carts-blue -n production
    ...
    Pod Template:
      Labels:  app=sockshop-selector-carts
               deployment=carts-blue
      Containers:
      carts:
        Image:      10.11.245.27:5000/sockshopcr/carts:0.6.0-1
    ```

    ```console
    $ kubectl describe deployment carts-green -n production
    ...
    Pod Template:
      Labels:  app=sockshop-selector-carts
               deployment=carts-blue
      Containers:
      carts:
        Image:      10.11.245.27:5000/sockshopcr/carts:0.6.2-3
    ```

    ```console
    $ kubectl describe virtualService -n production
    ...
    Route:
      Destination:
        Host:    carts-db.production.svc.cluster.local
        Subset:  blue
      Weight:    0
      Destination:
        Host:    carts-db.production.svc.cluster.local
        Subset:  green
      Weight:    100
    ```
  