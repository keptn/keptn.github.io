---
title: Deployments with Quality Gates
description: Describes how Keptn allows deploying an artifact using automatic quality gates and blue/green deployments.
weight: 25
keywords: []
aliases:
---

Describes how Keptn allows deploying an artifact using automatic quality gates and blue/green deployments.

## About this tutorial

When developing an application, sooner or later you need to update a service in a *production* environment. To conduct this in a controlled manner and without impacting end-user experience, the quality of the new service has to be ensured and adequate deployment strategies must be in place. For example, blue-green deployments are well-known strategies to roll out a new service version by also keeping the previous service version available if something goes wrong.

For this tutorial, we prepared a *slow* and a *regular* version of the carts service:

| Image                                 | Description                                        |
|---------------------------------------|----------------------------------------------------|
| docker.io/keptnexamples/carts:0.10.2  | Processes each request with a slowdown of 1 second |
| docker.io/keptnexamples/carts:0.10.3  | Processes each request without any slowdown        |

In this tutorial, we will deploy these two versions. During this deployment process, the versions have to pass a quality gate in the *staging* environment to get promoted to the *production* environment.
This quality gate checks whether the average response time of the service is under 1&nbsp;second. If the response time exceeds this threshold, the performance evaluation will be marked as failed.

<details><summary>*Click here to learn more about the tutorial.*</summary>
<p>

1. We will *try* to deploy the *slow* version of the carts service (0.10.2). 
  * Keptn will deploy this new version into the **dev** environment where functional tests will be executed. 
  * After passing these functional tests, Keptn will promote this service into the **staging** environment by releasing it as the blue or green version next to the previous version of the service. 
  * Then, Keptn will route traffic to this new version by changing the configuration of the virtual service (i.e., by setting weights for the routes between blue and green) and Keptn will start the defined performance test (e.g., using JMeter). Using the monitoring results of this performance test will allow [lighthouse](https://github.com/keptn/keptn/tree/master/lighthouse-service) to evaluate the quality gate. 
  * The *slow* version of carts (0.10.2) will not pass the quality gate and, hence, the new version will not be promoted to the **production** stage (i.e., the deployment will be rejected).
  * Furthermore, Keptn will change the weights within the **staging** stage back to the previous working deployment of the service. 

2. We will deploy the *regular* version of the carts service (v0.10.3). 
  * Keptn will conduct the same steps as before except that this version will pass the quality gate. 
  * Hence, this *regular* version will be promoted into the **production** environment.

</p>
</details>

## Prerequisites

- Finish the [Onboarding a Service](../onboard-carts-service/) tutorial (deploys carts version 0.10.1).

## Set up the quality gate and monitoring
Keptn requires a performance specification for the quality gate. This specification is described in a file called `slo.yaml`, which contains a description of Service Level Objectives (SLO) that should be met by a service. To learn more about the *slo.yaml* and *sli.yaml* files, go to [Specifications for Site Reliability Engineering with Keptn](https://github.com/keptn/spec/blob/0.1.1/sre.md).

* Activate the quality gates for the carts service. Therefore, navigate to the `examples/onboarding-carts` folder and upload the `slo-quality-gates.yaml` file using the [add-resource](../../reference/cli/#keptn-add-resource) command:

```console
keptn add-resource --project=sockshop --stage=staging --service=carts --resource=slo-quality-gates.yaml --resourceUri=slo.yaml
```

For this tutorial, you will need to set up monitoring for the carts service, either using the open-source monitoring solution *Prometheus* or *Dynatrace*.

### Option 1: Prometheus
<details><summary>Expand instructions</summary>
<p>

1. Configure Prometheus monitoring for the **sockshop** project and **carts** service as explained [here](../../reference/monitoring/prometheus/#setup-prometheus).

1. Configure the Prometheus SLI provider for the **sockshop** project as explained [here](../../reference/monitoring/prometheus/#setup-prometheus-sli-provider). The ConfigMap that needs to be applied is provided in the `examples/onboarding-carts` folder.

1. To configure Keptn to use the Prometheus SLI provider for the **sockshop** project, apply the below ConfigMap by executing the following command from within the `examples/onboarding-carts` folder:

    ```console
    kubectl apply -f lighthouse-source-prometheus.yaml
    ```

    ```yaml
    apiVersion: v1
    data:
      sli-provider: prometheus
    kind: ConfigMap
    metadata:
      name: lighthouse-config-sockshop
      namespace: keptn
    ```

1. Finally, upload the Prometheus-specific SLI configuration as stored in the `sli-config-prometheus.yaml` file:

    ```console
    keptn add-resource --project=sockshop --stage=staging --service=carts --resource=sli-config-prometheus.yaml --resourceUri=prometheus/sli.yaml
    ```

</p>
</details>

### Option 2: Dynatrace
<details><summary>Expand instructions</summary>
<p>

1. Please complete the instructions for setting up [Dynatrace monitoring](../../reference/monitoring/dynatrace#setup-dynatrace).

1. Configure the Dynatrace SLI provider for the **sockshop** project as explained [here](../../reference/monitoring/dynatrace/#setup-dynatrace-sli-provider).

1. To configure Keptn to use the Dynatrace SLI provider for the **sockshop** project, apply the below ConfigMap by executing the following command from within the `examples/onboarding-carts` folder:

    ```console
    kubectl apply -f lighthouse-source-dynatrace.yaml
    ```

    ```yaml
    apiVersion: v1
    data:
      sli-provider: dynatrace
    kind: ConfigMap
    metadata:
      name: lighthouse-config-sockshop
      namespace: keptn
    ```

1. Finally, upload the Dynatrace-specific SLI configuration as stored in the `sli-config-dynatrace.yaml` file:

    ```console
    keptn add-resource --project=sockshop --stage=staging --service=carts --resource=sli-config-dynatrace.yaml --resourceUri=dynatrace/sli.yaml
    ```

</p>
</details>

## View carts service

1. Get the URL for your carts service with the following commands in the respective namespaces:

    ```console
    echo http://carts.sockshop-dev.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
    ```
    ```console
    echo http://carts.sockshop-staging.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
    ```
    ```console
    echo http://carts.sockshop-production.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
    ```

2. Navigate to `http://carts.sockshop-production.YOUR.DOMAIN` for viewing the carts service in your **production** environment and you should receive an output similar to the following:

    {{< popup_image
      link="./assets/carts-production.png"
      caption="carts service"
      width="50%">}}

## Deploy the slow carts version

* Use the Keptn CLI to deploy a version of the carts service, which contains an artificial **slowdown of 1 second** in each request.

  ```console
  keptn send event new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.10.2
  ```

<details><summary>*Click here to learn more about Keptn internal services.*</summary>
<p>
The [send event new-artifact](../../reference/cli/#keptn-send-event-new-artifact) command changes the configuration of the service and automatically triggers the following Keptn services:

* **Phase 1**: Deploying, testing, and evaluating the test in the *dev* stage:
    * **helm-service**: This service deploys the new artifact to *dev*.
    * **jmeter-service**: This service runs a basic health check and a functional test in *dev*. Afterwards, this service sends an event of type `sh.keptn.events.tests-finished`. 
    * **lighthouse-service**: This service picks up the event and evaluates the test runs based on the performance signature. Since in the *dev* environment only functional tests are executed, the lighthouse-service will mark the test run as successful (functional failures would have been detected by the **jmeter-service**).
    * **gatekeeper-service**: This service promotes the artifact to the next stage, i.e., *staging*.

* **Phase 2**: Deploying, testing, and evaluating the test in the *staging* stage:
    * **helm-service**: This service deploys the new artifact to *staging* using a blue/green deployment strategy.
    * **jmeter-service**: This service runs a performance test in *staging* and sends the `sh.keptn.events.tests-finished` event.
    * **lighthouse-service**: This service picks up the event and this time, the quality gates of the service will be evaluated because we are using the performance-test-strategy for this stage. This means that the lighthouse-service will send a `get-sli` event to fetch the metrics for the *carts* service from either Prometheus or Dynatrace, depending on how you set up the monitoring for your service earlier. Based on the results of that evaluation, the lighthouse-service will mark the test run execution as successful or failed. In our scenario, the lighthouse-service will mark it as failed since the response time thresholds will be exceeded.
    * **gatekeeper-service**: This service receives a `sh.keptn.events.evaluation-done` event, which contains the result of the evaluation of the lighthouse-service. Since in this case the performance test failed, the gatekeeper-service automatically initiates a rollback to the previous version in *staging* and the artifact won't be promoted to *production*.

</p>
</details>

## Quality gate in action

After triggering the deployment of the carts service in version v0.10.2, the following status is expected:

* **Dev stage:** The new version is deployed in the dev namespace and the functional tests passed.
  * To verify, open a browser and navigate to: `http://carts.sockshop-dev.YOUR.DOMAIN`

* **Staging stage:** In this stage, version v0.10.2 will be deployed and the performance test starts to run for about 10 minutes. After the test is completed, Keptn triggers the test evaluation and identifies the slowdown. Consequently, a roll-back to version v0.10.1 in this stage is conducted and the promotion to production is not triggered.
  * To verify, the [Keptn's bridge](../../reference/keptnsbridge/#usage) shows the deployment of v0.10.2 and then the failed test in staging including the roll-back:

    {{< popup_image
      link="./assets/quality_gates.png"
      caption="Quality gate in staging"
      width="100%">}}

* **Production stage:** The slow version is **not promoted** to the production namespace because of the active quality gate in place. Thus, still version v0.10.1 is expected to be in production.
  * To verify, navigate to: `http://carts.sockshop-production.YOUR.DOMAIN`

## Deploy the regular carts version

1. Use the Keptn CLI to send a new version of the *carts* artifact, which does **not** contain any slowdown:
 
   ```console
   keptn send event new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.10.3
   ```

1. To verify the deployment in *production*, open a browser and navigate to `http://carts.sockshop-production.YOUR.DOMAIN`. As a result, you see `Version: v3`.

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
          Image:      docker.io/keptnexamples/carts:0.10.3
    ```
