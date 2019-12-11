---
title: Keptn Quality Gates only
description: Describes how Keptn allows to use quality gates without deployment and testing features of Keptn.
weight: 26
keywords: [quality-gates]
aliases:
---

Describes how Keptn allows to use quality gates without deployment and testing features of Keptn.

## About this tutorial

Let's say you want to use your existing tools for deploying and testing your applications - you can still use Keptn Quality Gates for extensive evaluation of service level objectives (SLOs).

*A brief recap of SLOs and SLIs:* A service level objective (SLO) is a target value or range of values for a service level that is measured by a service level indicator (SLI). An SLI is a carefully defined quantitative measure of some aspect of the level of service that is provided. By default, the following SLIs can be used for evaluation, inspired by the [Site Reliability Engineering](https://landing.google.com/sre/sre-book/chapters/service-level-objectives) book from Google:

* *Response Time*: The time it takes for a service to execute and complete a task or how long it takes to return a response to a request.
* *System Throughput*: The number of requests per second that have been processed.
* *Error Rate*: The fraction of all received requests that produced an error.

For more information about SLO and SLI, please take a look at [Specifications for Site Reliability Engineering with Keptn](https://github.com/keptn/spec/blob/0.1.1/sre.md).

## Prerequisites

* Running Keptn installation or a quality gates only installation as explained below

* Clone example files used for this tutorial:

    ```console
    git clone --branch 0.6.0.beta https://github.com/keptn/examples.git --single-branch
    ```

    ```console
    cd examples/onboarding-carts
    ```

## Install Keptn just for this use case

If you want to install Keptn just to explore the capabilities of Keptn quality gates, you have the option to roll-out Keptn **without** components for automated delivery and operations. Therefore, set the `use-case` flag to `quality-gates` when executing the [install](../../reference/cli/#keptn-install) command as shown below:

```console
keptn install --platform=[aks|eks|gke|openshift|pks|kubernetes] --use-case=quality-gates
```

## Configure Keptn

If you have completed another tutorial with the sockshop project and carts service, you can either delete the project using the [delete project](../../reference/cli/#keptn-delete-project) command, or you use another project name throughout this tutorial, e.g., *rockshop*.

* Create the Keptn project *sockshop* with only one the *hardening* stage declared in the shipyard file:

  ```
  keptn create project sockshop --shipyard shipyard_quality_gates.yaml
  ```

  *shipyard_quality_gates.yaml:*
  ```yaml
  stages:
  - name: "hardening"
  ```

* Create the Keptn service *carts* that you want to evaluate using Keptn quality gates. 

  ```console
  keptn create service carts --project sockshop
  ```

## Set up quality gate and monitoring

* Activate the quality gates for the carts service. Therefore, navigate to the `examples/onboarding-carts` folder and upload the `slo_quality-gates.yaml` file using the [add-resource](../../reference/cli/#keptn-add-resource) command:

  ```console
  keptn add-resource --project=sockshop --service=carts --stage=staging --resource=slo_quality-gates.yaml --resourceUri=slo.yaml
  ```

For this tutorial you will need to set up monitoring for the carts service, either using the open-source monitoring solution *Prometheus* or *Dynatrace*. 

### Option 1: Prometheus
<details><summary>Expand instructions</summary>
<p>

1. Configure Prometheus monitoring for the **sockshop** project and **carts** service as explained [here](../../reference/monitoring/prometheus/#setup-prometheus).

1. Configure the Prometheus SLI provider for the **sockshop** project as explained [here](../../reference/monitoring/prometheus/#setup-prometheus-sli-provider). The ConfigMap that need to be applied is provided in the `examples/onboarding-carts` folder.

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

</p>
</details>

### Option 2: Dynatrace
<details><summary>Expand instructions</summary>
<p>

1. Please complete the instructions for setting up [Dynatrace monitoring](../../reference/monitoring/dynatrace#setup-dynatrace).

1. Configure the Dynatrace SLI provider for the **sockshop** project as explained [here](../../reference/monitoring/dynatrace/#setup-dynatrace-sli-provider).

1. To configure Keptn to use the Dynatrace SLI provider for the **sockshop** project, apply the below ConfigMap by executing the following command from within the `examples/onboarding-carts` folder:

    ```console
    kubectl apply -f lighthouse-source-prometheus.yaml
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

</p>
</details>

## Evaluate Keptn quality gates

At this stage, your project is ready and we can now start triggering evaluations of our SLOs. The Keptn quality gates is a two step procedure that consists of starting the evaluation and polling for the results.

At a specific point in time, e.g., after you have executed your tests or you have waited for enough live traffic, you can either start the evaluation of the Keptn quality gates manually using the Keptn CLI, or automate it by either including the Keptn CLI calls in your automation scripts, or by directly accessing the Keptn REST API. 

### Keptn CLI

* Execute a quality gate evaluation by using the Keptn CLI to [send event start-evaluation](../../reference/cli/#keptn-send-event-start-evaluation): 

  ```console
  keptn send event start-evaluation --project=sockshop --stage=hardening --service=carts --period=5m
  ```

  The `start-evaluation` event will kick off the evaluation of the SLO of the carts service over the last 5 minutes. Evaluations can be done in seconds but may also take a while as every SLI provider needs to query each SLIs first. This is why the Keptn CLI will return the `keptnContext`, which is basically a token we can use to poll the status of this particular evaluation. The output of the previous command looks like this:

  ```console
  Starting to send a start-evaluation event to evaluate the service sampleservice in project sample
  ID of Keptn context: 6cd3e469-cbd3-4f73-xxxx-8b2fb341bb11
  ```

* Retrieve the evaluation results by using the Keptn CLI to [get event evaluation-done](../../reference/cli/#keptn-send-event-start-evaluation): 
    
  ```console
  keptn get evaluation-results --keptnContext=6cd3e469-cbd3-4f73-xxxx-8b2fb341bb11
  ```

  The result comes in the form of the `evaluation-done` event, that is specified [here](https://github.com/keptn/spec/blob/0.1.1/cloudevents.md#evaluation-done).

### Keptn API

* First, get the Keptn API endpoint and token by executing the following commands: 

  ```console
  KEPTN_ENDPOINT=https://api.keptn.$(kubectl get cm keptn-domain -n keptn -ojsonpath={.data.app_domain})
  KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
  ```

* Prepare the POST request body by filling out the next JSON object: 

  ```yaml
  {
    "type": "sh.keptn.event.start-evaluation"
    "data": {
      "start": "2019-11-21T11:00:00.000Z",
      "end": "2019-11-21T11:05:00.000Z",
      "project": "sockshop",
      "stage": "hardening",
      "service": "carts",
      "teststrategy": "manual"
    }
  }
  ```

* Execute a quality gate evaluation by sending the POST request to trigger an evaluation using the curl command:

  ```console
  curl -X POST "http://api.keptn.12.34.56.78.xip.io/v1/event" -H "accept: application/json" -H "x-token: YOUR_KEPTN_TOKEN" -H "Content-Type: application/json" -d "{ \"data\": { \"end\": \"2019-11-21T11:05:00.000Z\", \"project\": \"sockshop\", \"service\": \"carts\", \"stage\": \"hardening\", \"start\": \"2019-11-21T11:00:00.000Z\", \"teststrategy\": \"manual\" }, \"type\": \"sh.keptn.event.start-evaluation\"}"
  ```

  This request will trigger the evaluation of the service level objects of the specified service in the specified project over the last 5 minutes. As response you will receive a `keptnContext` ID that you will need for querying the results of the evaluation.

  ```console
  {"keptnContext":"384dae76-2d31-41e6-9204-39f2c1513906","token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDU0NDA4ODl9.OdkhIoJ9KuT4bm7imvEXHdEPjnU0pl5S7DqGibNa924"}
  ```

* Send a GET request to retrieve the evaluation result: 

  ```console
  curl -X GET "http://api.keptn.12.34.56.78.xip.io/v1/event?keptnContext=KEPTN_CONTEXT_ID&type=sh.keptn.events.evaluation-done" -H "accept: application/json" -H "x-token: YOUR_KEPTN_TOKEN"
  ```

  The result comes in the form of the `evaluation-done` event, that is specified [here](https://github.com/keptn/spec/blob/0.1.1/cloudevents.md#evaluation-done).