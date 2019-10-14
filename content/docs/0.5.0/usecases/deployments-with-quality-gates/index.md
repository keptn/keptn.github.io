---
title: Deployments with Quality Gates
description: Describes how Keptn allows to deploy an artifact using automatic quality gates and blue/green deployments.
weight: 25
keywords: []
aliases:
---

Describes how Keptn allows to deploy an artifact using automatic quality gates and blue/green deployments.

## About this tutorial

When developing an application, sooner or later you need to update a service in a *production* environment. To conduct this in a controlled manner and without impacting end-user experience, the quality of the new service has to be ensured and adequate deployment strategies must be in place. For example, blue-green deployments are well-known strategies to roll out a new service version by also keeping the previous service version available if something goes wrong.

For this tutorial, we prepared a *slow* and a *regular* version of the carts service:

| Image                                 | Description                                        |
|---------------------------------------|----------------------------------------------------|
| docker.io/keptnexamples/carts:0.9.2   | Processes each request with a slowdown of 1 second |
| docker.io/keptnexamples/carts:0.9.3   | Processes each request without any slowdown        |

In this tutorial, we will deploy these two versions. During this deployment process, the versions have to pass a quality gate
in the *staging* environment in order to get promoted to the *production* environment.
This quality gate checks whether the average response time of the service is under 1&nbsp;second. If the response time exceeds this threshold, the performance evaluation will be marked as failed.

In overview, we will conduct these two scenarios:

First, we will *try* to deploy the *slow* version of the carts service (v0.9.2). Therefore, Keptn will deploy this new version into the **dev** environment where functional tests will be executed. After passing these functional tests, Keptn will promote this service into the **staging** environment by releasing it as the blue or green version next to the previous version of the service. Then, Keptn will route traffic to this new version by changing the configuration of the virtual service (i.e., by setting weights for the routes between blue and green) and Keptn will start the defined performance test. Using the monitoring results of this performance test will allow [Pitometer](https://github.com/keptn/pitometer) to evaluate the quality gate. This *slow* version will not pass the quality gate and, hence, the deployment will be rejected. Furthermore, Keptn will direct the requests to the service to the previous working deployment of the service. 

Second, we will deploy the *regular* version of the carts service (v0.9.3). Therefore, Keptn will conduct the same steps as before except that this version will now pass the quality gate. Hence, this *regular* version will be promoted into the **production** environment.

## Prerequisites

- Finish the [Onboarding a Service](../onboard-carts-service/) tutorial.

## Set up of monitoring for the carts service
Since this tutorial relies on the concept of quality gates, you will need to set up monitoring for your carts service.
The [Pitometer](https://github.com/keptn/pitometer) service will then evaluate the data coming from the monitoring solution to determine a score for the quality gate.

For using the quality gate, Pitometer requires a performance specification.
This performance specification is described by two files, namely the `service-indicators.yaml` file, which describes the available types of metrics and their data sources (e.g., Prometheus or Dynatrace), and the `service-objectives.yaml`, which describe the desired values for those metrics. To learn more about the *service-indicator*, and *service-objective* file, click here [Specifications for Site Reliability Engineering with Keptn](https://github.com/keptn/keptn/blob/0.5.0/specification/sre.md).

In this tutorial, we will be using either the open source monitoring solution *Prometheus* or *Dynatrace*.

### Option 1: Prometheus
<details><summary>Expand instructions</summary>
<p>

To set up the quality gates for the carts service, please navigate to the `examples/onboarding-carts` folder. This folder contains the files `service-indicators.yaml` and `service-objectives-prometheus-only.yaml`. To set the quality gates based on those files, upload it via the following command:

```console
keptn add-resource --project=sockshop --service=carts --stage=staging --resource=service-indicators.yaml --resourceUri=service-indicators.yaml
keptn add-resource --project=sockshop --service=carts --stage=staging --resource=service-objectives-prometheus-only.yaml --resourceUri=service-objectives.yaml
```

Afterwards, execute the following command to set up the rules for the Prometheus Alerting Manager based on those quality gates:

```
keptn configure monitoring prometheus --project=sockshop --service=carts
```

To verify that the rules are correctly set up, you can access Prometheus by enabling port-forwarding for the prometheus-service:

```console
kubectl port-forward svc/prometheus-service 8080 -n monitoring
```

It is then available on [localhost:8080/targets](http://localhost:8080/targets) where you can see the three targets for the carts service:

  {{< popup_image link="./assets/prometheus-targets.png" caption="Prometheus Targets">}}

 </p>
</details>

### Option 2: Dynatrace
<details><summary>Expand instructions</summary>
<p>
Please make sure you have followed the instructions for setting up [Dynatrace](../../reference/monitoring/dynatrace).

To set up the quality gates for the carts service, please navigate to the `examples/onboarding-carts` folder. This folder contains the files `service-indicators.yaml` and `service-objectives-with-dynatrace.yaml`. To set the quality gates based on those files, upload it via the following command:

  ```console
  keptn add-resource --project=sockshop --service=carts --stage=staging --resource=service-indicators.yaml --resourceUri=service-indicators.yaml
  ```
  
  ```console
  keptn add-resource --project=sockshop --service=carts --stage=staging --resource=service-objectives-dynatrace-only.yaml --resourceUri=service-objectives.yaml
  ```

</p>
</details>

## View carts service

- Get the URL for your carts service with the following commands in the respective namespaces:

  ```console
  echo http://carts.sockshop-dev.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
  ```
  ```console
  echo http://carts.sockshop-staging.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
  ```
  ```console
  echo http://carts.sockshop-production.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
  ```

- Navigate to `http://carts.sockshop-production.YOUR.DOMAIN` for viewing the carts service in your **production** environment and you should receive an output similar to the following:

    {{< popup_image
      link="./assets/carts-production.png"
      caption="carts service"
      width="50%">}}

## Deploy the slow carts version

1. Use the Keptn CLI to deploy a version of the carts service, which contains an artificial **slowdown of 1 second** in each request.

  ```console
  keptn send event new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.9.2
  ```

<details><summary>*Click here to learn more about Keptn internal services.*</summary>
<p>
The [send event new-artifact](../../reference/cli/#keptn-send-event-new-artifact) command changes the configuration of the service and automatically triggers the following Keptn services:

* **Phase 1**: Deploying, testing and evaluating the test in the *dev* stage:
    * **helm-service**: This service deploys the new artifact to *dev*.
    * **jmeter-service**: This service runs a basic health check and a functional tests in *dev*. Afterwards, this service sends an event of type `sh.keptn.events.tests-finished`. 
    * **pitometer-service**: This service picks up the event and evaluates the test runs based on the  performance signature. Since in the *dev* environment only functional tests are executed, the pitometer-service will mark the test run as successful (functional failures would have been detected by the **jmeter-service**).
    * **gatekeeper-service**: This service promotes the artifact to the next stage, i.e., *staging*.

* **Phase 2**: Deploying, testing and evaluating the test in the *staging* stage:
    * **helm-service**: This service deploys the new artifact to *staging* using a blue/green deployment strategy.
    * **jmeter-service**: This service runs a performance test in *staging* and sends the `sh.keptn.events.tests-finished` event.
    * **pitometer-service**: This service picks up the event and this time, the quality gates of the service will be evaluated because we are using the performance-test-strategy for this stage. This means that the pitometer-service will fetch the metrics for the *carts* service from either Prometheus or Dynatrace, depending on how you set up the monitoring for your service earlier. Based on the results of that evaluation, the pitometer-service will mark the test run execution as successful or failed. In our scenario, the pitometer-service will mark it as failed since the response time thresholds will be exceeded.
    * **gatekeeper-service**: This service receives a `sh.keptn.events.evaluation-done` event, which contains the result of the evaluation of the pitometer-service. Since in this case the performance test run failed, the gatekeeper-service automatically initiates an rollback to the previous version in *staging* and the artifact won't be promoted to *production*.

</p>
</details>

## Quality gate in action

After triggering the deployment of the carts service in version v0.9.2, the following status is expected:

* **Dev stage:** The new version is deployed in the dev namespace and the functional tests passed.
  * To verify, open a browser and navigate to: `http://carts.sockshop-dev.YOUR.DOMAIN`

* **Staging stage:** In this stage, version v0.9.2 will be deployed and the performance test starts to run for about 10 minutes. After the test is completed, Keptn triggers the test evaluation and identifies the slowdown. Consequently, a roll-back to version v0.9.1 in this stage is conducted and the promotion to production is not triggered.
  * To verify, the [Keptn's bridge](../../reference/keptnsbridge/#usage) shows the deployment of v0.9.2 and then the failed test in staging including the roll-back:

    {{< popup_image
      link="./assets/quality_gates.png"
      caption="Quality gate in staging"
      width="100%">}}

* **Production stage:** The slow version is **not promoted** to the production namespace because of the active quality gate in place. Thus, still version v0.9.1 is expected to be in production.
  * To verify, navigate to: `http://carts.sockshop-production.YOUR.DOMAIN`

## Deploy the regular carts version

1. Use the Keptn CLI to send a new version of the *carts* artifact, which does **not** contain any slowdown.
  ```console
  keptn send event new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.9.3
  ```

1. This automatically changes the configuration of the service and automatically triggers the deployment.

1. In this case, the quality gate is passed and the service gets deployed in the *production* namespace. 

1. To verify the deployment in *production*, open a browser an navigate to `http://carts.sockshop-production.YOUR.DOMAIN`. As a result, you see `Version: v3`.

1. Besides, you can verify the deployments in your Kubernetes cluster using the following commands: 

    ```console
    kubectl get deployments -n sockshop-production
    ``` 

    ```console
    NAME            DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    carts-db        1         1         1            1           63m
    carts-primary   1         1         1            1           98m
    ```

    ```console
    kubectl describe deployment carts-primary -n sockshop-production
    ``` 
    
    ```console
    ...
    Pod Template:
      Labels:  app=carts-primary
      Containers:
        carts:
          Image:      docker.io/keptnexamples/carts:0.9.3
    ```
