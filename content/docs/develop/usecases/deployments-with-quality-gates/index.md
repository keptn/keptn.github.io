---
title: Deployments with Quality Gates
description: Gives an overview of deployments using quality gates and blue/green deployments of a new service version.
weight: 25
keywords: []
aliases:
---

This use case gives an overview of deployments using quality gates and blue/green deployments of a new service version.

## About this use case

When developing an application, sooner or later you need to update a service in a production environment. To conduct this in a controlled manner and without impacting end-user experience, the quality of the new service has to be ensured and adequate deployment strategies must be in place. For example, blue-green deployments are well-known strategies to rollout a new service version by also keeping the previous service version available if something goes wrong.

To illustrate the benefit this use case addresses, we prepared a second version of the carts service. This version will be pushed through the different stages and has to pass quality gates. To increase resilience, the service is deployed to the production environment by releasing it as the blue or green version next to the previous version of the service. To route traffic to this new service version, the configuration of a virtual service will be changed by setting weights for the routes between blue and green.

## Prerequisites

1. Either [Prometheus](../../monitoring/prometheus) or [Dynatrace](../../monitoring/dynatrace) monitoring set up.

1. In order to start this use case, please deploy the `carts` service by completing the use case [Onboarding a Service](../onboard-carts-service/).

## Set up Monitoring for the carts service
Since this use case relies on the concept of quality gates, you will need to set up monitoring for your carts service.
In this use case we will be using either the open source monitoring solution *Prometheus* or *Dynatrace*.
The [Pitometer](https://github.com/keptn/pitometer) service will then evaluate the data coming from these sources to determine a score for the quality gate.

### Option 1: Prometheus
<details><summary>Expand instructions</summary>
<p>
Please make sure you have followed the instructions for setting up [Prometheus](../../monitoring/prometheus).

To set up the quality gates for the carts service, please navigate to the `perfspec` folder of your carts service. This folder contains files defining the quality gate that will be evaluated against Prometheus. 

This quality gate will check that the average response time of the service is under 1&nbsp;second. If the response time exceeds this threshold, the performance evaluation will be marked as failed, the service deployment will be rejected and the requests to the service will be directed to the previous working deployment of the service. The evaluation is done with the [Pitometer](https://github.com/keptn/pitometer) component that is installed along with keptn.

1. Rename the file `perfspec_prometheus.json` to `perfspec.json`. 
1. Commit and push the file.

  ```console
  git add .
  git commit -m "use prometheus perfspec"
  git push
  ```
</p>
</details>

### Option 2: Dynatrace
<details><summary>Expand instructions</summary>
<p>
Please make sure you have followed the instructions for setting up [Dynatrace](../../monitoring/dynatrace).

To set up the quality gates for the carts service, please navigate to the `perfspec` folder of your carts service. This file contains the quality gate that will be evaluated against Dynatrace. 

This quality gate will check that the average response time of the service is under 1&nbsp;second. If the response time exceeds this threshold, the performance evaluation will be marked as failed, the service deployment will be rejected and the requests to the service will be directed to the previous working deployment of the service. The evaluation is done with the [Pitometer](https://github.com/keptn/pitometer) component that is installed along with keptn.

1. Rename the file `perfspec_dynatrace.json` to `perfspec.json`. 
1. Commit and push the file.

  ```console
  git add .
  git commit -m "use dynatrace perfspec"
  git push
  ```



</p>
</details>


## Access service via ingress gateway

1. Run the `kubectl get svc istio-ingressgateway -n istio-system` command to get the *EXTERNAL-IP* of your `istio-ingressgateway` service.

    ```console
    kubectl get svc istio-ingressgateway -n istio-system

    NAME                   TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                                      AGE
    istio-ingressgateway   LoadBalancer   172.21.109.129   3*.2**.1**.8*   80:31380/TCP,443:31390/TCP,31400:31400/TCP   17h
    ```

1. Open a browser and navigate to: `http://carts.production.EXTERNAL-IP.xip.io/version`

1. You should be able to retrieve the version of the service.


## Try to deploy a carts version with slowdown to production

1. Use the keptn CLI to send a version of the `carts` artifact, which contains a heavy slowdown. Therefore, choose the image depending on 
your monitoring solution, i.e., for Prometheus 
  ```console
  $ send new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.6.1_prometheus
  ```
  and for Dynatrace
  ```console
  $ send new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.6.1_dynatrace
  ```

1. This automatically changes the configuration of the service and automatically triggers the pipelines.

1. Watch keptn deploying the new artifact by following the pipelines in Jenkins.
  * **Phase 1**: Deploying, testing and evaluating the test in the `dev` stage:
      * **deploy**: The new artifact gets deployed to dev.
      * **run_tests**: Runs a basic health check and functional check in dev. Whenever the test pipeline has been executed, an event of the type `sh.keptn.events.tests-finished` is generated. 
      * **Pitometer test evaluation**: This event will be picked up by the Pitometer service, which is responsible for evaluating test runs, based on the quality gates specified earlier in the `perfspec.json` file. Since in the dev environment, only functional tests are executed, the Pitometer service will mark the test run as successful (functional failures would have led the **run-tests** pipeline to fail).
      * **evaluation_done**: This pipeline will promote the artifact to the next stage, i.e., staging.
  * **Phase 2**: Deploying, testing and evaluating the test in the `staging` stage:
      * **deploy**: The new artifact gets deployed to staging using a blue/green deployment strategy.
      * **run_tests**: Runs a performance test in staging and sends the `sh.keptn.events.tests-finished` event.
      * **Pitometer test evaluation**: This time, the quality gates of the service will be evaluated, because we are using the performance-tests strategy for this stage. This means that the Pitometer service will fetch the metrics for the `carts` service from either Prometheus or Dynatrace, depending on how you set up the monitoring for your service earlier. Based on the results of that evaluation, the Pitometer service will mark the test run execution as successful or failed. In our scenario, the Pitometer service will mark it as failed since the response time thresholds will be exceeded.
      * **evaluation_done**:  If the evaluation would have been successful, the artefact would be promoted to production. Since in our case we failed the performance test run, this pipeline automatically re-routes traffic to the previous colored blue or green version in staging and the artifact won't be promoted to production.
      
  **Outcome**: This slow version is **not** promoted to the production namespace because of the active quality gate in place.

## Deploy a carts version without slowdown to production

1. Use the keptn CLI to send a new version of the `carts` artifact. Therefore, choose the image depending on 
your monitoring solution, i.e., for Prometheus 
  ```console
  $ send new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.6.2_prometheus
  ```
  and for Dynatrace
  ```console
  $ send new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.6.2_dynatrace
  ```

1. This automatically changes the configuration of the service and automatically triggers the pipelines.

1. In this case, the quality gate is passed and the service gets deployed in the production namespace. 

1. To verify the deployment in production, open a browser an navigate to: `http://carts.production.EXTERNAL-IP.xip.io/version`. As a result, you see `Version = Fast`.

1. Besides, you can verify the deployments in your K8s cluster using the following commands: 

    ```console
    kubectl get deployments -n sockshop-production

    NAME             DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    carts-blue       1         1         1            0           1h
    carts-db-blue    1         1         1            0           1h
    carts-db-green   1         1         1            0           1h
    carts-green      1         1         1            0           1h
    ```

    ```console
    kubectl describe deployment carts-blue -n sockshop-production

    ...
    Pod Template:
      Labels:  app=sockshop-selector-carts
               deployment=carts-blue
      Containers:
      carts:
        Image:      docker.io/keptnexamples/carts:0.6.2_prometheus
    ```

    ```console
    kubectl describe deployment carts-green -n sockshop-production

    ...
    Pod Template:
      Labels:  app=sockshop-selector-carts
               deployment=carts-green
      Containers:
      carts:
        Image:      docker.io/keptnexamples/carts:0.6.0
    ```

    ```console
    kubectl describe virtualService -n sockshop-production
    
    ...
    Route:
      Destination:
        Host:    carts-db.sockshop-production.svc.cluster.local
        Subset:  blue
      Weight:    100
      Destination:
        Host:    carts-db.sockshop-production.svc.cluster.local
        Subset:  green
      Weight:    0
    ```
