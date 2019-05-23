---
title: Deployments with Quality Gates
description: Gives an overview of deployments using quality gates and blue/green deployments of a new service version.
weight: 25
keywords: []
aliases:
---

This use case gives an overview of deployments using quality gates and blue/green deployments of a new service version.

## About this use case

When developing an application, sooner or later you need to update a service in a `production` environment. To conduct this in a controlled manner and without impacting end-user experience, the quality of the new service has to be ensured and adequate deployment strategies must be in place. For example, blue-green deployments are well-known strategies to rollout a new service version by also keeping the previous service version available if something goes wrong.

To illustrate this use case, we prepared a *slow* version of the carts service. This *slow* version has to pass a quality gate
in the `staging` environment to get promoted to  the `production` enviornment.
This quality gate checks whether the average response time of the service is under 1&nbsp;second. If the response time exceeds this threshold, the performance evaluation will be marked as failed.

In this use case, keptn will conduct the following steps:
When the *slow* version of the service is pushed, keptn will deploy this new version into the `dev` environment
where functional tests are exucted.
After passing these functional tests, keptn will promote this service into the `staging` environment
by releasing it as the blue or green version next to the previous version of the service.
Then, keptn will route traffic to this new version by changing the configuration of the virtual service 
(i.e. by setting weights for the routes between blue and green) and keptn will start the defined performance test.
Using the monitoring results of this performance test allows [Pitometer](https://github.com/keptn/pitometer)
to evaluate the quality gate. In this use case, the slow version will not pass the quality gate and, hence, 
the service deployment will be rejected. 
Furthermore, keptn will direct the requests to the service to the previous working deployment of the service. 


## Prerequisites
In this use case we will be using either the open source monitoring solution *Prometheus* or *Dynatrace*.

1. Either [Prometheus](../../monitoring/prometheus) or [Dynatrace](../../monitoring/dynatrace) monitoring set up.

1. In order to start this use case, please deploy the `carts` service by completing the use case [Onboarding a Service](../onboard-carts-service/).

## Set up of Monitoring for the carts service
Since this use case relies on the concept of quality gates, you will need to set up monitoring for your carts service.
The [Pitometer](https://github.com/keptn/pitometer) service will then evaluate the data coming from the monitoring solution to determine a score for the quality gate.

### Fork carts example into your GitHub organization

For using the quality gate, Pitometer requires a performance specification.
This performance specification has to be located in a repository having the name of 
your service (for this use case `carts`) in the configured GitHub organization (i.e. used in [keptn configure](../../reference/cli/#keptn-configure)).
Therefore, please fork the `carts` service in your GitHub organization and clone it:

1. Go to https://github.com/keptn-sockshop/carts and click on the **Fork** button on the top right corner.

1. Select the GitHub organization you use for keptn.

1. Clone the forked carts service to your local machine. Please note that you have to use your own GitHub organization.
  ```console
    $ cd ~
    $ git clone https://github.com/your-github-org/carts.git
    $ cd carts
    ```

### Option 1: Prometheus
<details><summary>Expand instructions</summary>
<p>
Please make sure you have followed the instructions for setting up [Prometheus](../../monitoring/prometheus).

To set up the quality gates for the carts service, please navigate to the `perfspec` folder of your carts service. This folder contains files defining the quality gate that will be evaluated against Prometheus. 

1. Rename the file `perfspec_prometheus.json` to `perfspec.json`. 
1. Commit and push the file.

  ```console
  git add .
  git commit -m "use prometheus perfspec"
  git push
  ```

Now, you have quality gates in place, which will check whether the average response time of the service is under 1&nbsp;second.
 </p>
</details>

### Option 2: Dynatrace
<details><summary>Expand instructions</summary>
<p>
Please make sure you have followed the instructions for setting up [Dynatrace](../../monitoring/dynatrace).

To set up the quality gates for the carts service, please navigate to the `perfspec` folder of your carts service. This file contains the quality gate that will be evaluated against Dynatrace. 

1. Rename the file `perfspec_dynatrace.json` to `perfspec.json`. 
1. Commit and push the file.

  ```console
  git add .
  git commit -m "use dynatrace perfspec"
  git push
  ```

Now, you have quality gates in place, which will check whether the average response time of the service is under 1&nbsp;second.
</p>
</details>



## Access service via ingress gateway

1. Run the `kubectl get svc istio-ingressgateway -n istio-system` command to get the *EXTERNAL-IP* of your `istio-ingressgateway` service.

    ```console
    kubectl get svc istio-ingressgateway -n istio-system

    NAME                   TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                                      AGE
    istio-ingressgateway   LoadBalancer   172.21.109.129   3*.2**.1**.8*   80:31380/TCP,443:31390/TCP,31400:31400/TCP   17h
    ```

1. Open a browser and navigate to: `http://carts.sockshop-production.EXTERNAL-IP.xip.io/version`

1. You should be able to retrieve the version of the service.


## Try to deploy a carts version with slowdown to production

1. Use the keptn CLI to send a version of the `carts` artifact, which contains a heavy slowdown in each request. 
  ```console
  $ send new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.8.1
  ```

1. This automatically changes the configuration of the service and automatically triggers the pipelines. Watch keptn deploying the new artifact by following the pipelines in Jenkins.
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
For verifying this, open a browser and navigate to `http://carts.sockshop-production.EXTERNAL-IP.xip.io/version`.
Here, you see that the version of the carts service has not changed.

## Deploy a carts version without slowdown to production

1. Use the keptn CLI to send a new version of the `carts` artifact, which does **not** contain any slowdown.
  ```console
  $ send new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.8.2
  ```

1. This automatically changes the configuration of the service and automatically triggers the pipelines.

1. In this case, the quality gate is passed and the service gets deployed in the production namespace. 

1. To verify the deployment in production, open a browser an navigate to `http://carts.sockshop-production.EXTERNAL-IP.xip.io/version`. As a result, you see `Version: v3`.

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
        Image:      docker.io/keptnexamples/carts:0.8.2
    ```

    ```console
    kubectl describe deployment carts-green -n sockshop-production

    ...
    Pod Template:
      Labels:  app=sockshop-selector-carts
               deployment=carts-green
      Containers:
      carts:
        Image:      docker.io/keptnexamples/carts:0.8.0
    ```

    ```console
    kubectl describe virtualService -n sockshop-production
    
    ...
    Route:
      Destination:
        Host:    carts.sockshop-production.svc.cluster.local
        Subset:  blue
      Weight:    100
      Destination:
        Host:    carts.sockshop-production.svc.cluster.local
        Subset:  green
      Weight:    0
    ```
