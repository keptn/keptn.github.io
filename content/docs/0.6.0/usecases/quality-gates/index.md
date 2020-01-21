---
title: Quality Gates for external Deployments
description: Describes how Keptn allows using quality gates without delivery and testing capabilities of Keptn.
weight: 26
keywords: [quality-gates]
aliases:
---

Describes how Keptn allows using quality gates without delivery and testing capabilities of Keptn.

## About this tutorial

Let's say you want to use your existing tools to deploy and test your applications - you can still use *Keptn`s Quality Gates* for the evaluation of Service Level Objectives (SLOs).

*A brief recap of SLO and SLI:* A Service Level Objective (SLO) is a target value or range of values for a service level that is measured by a Service Level Indicator (SLI). An SLI is a carefully defined quantitative measure of some aspect of the level of service that is provided. By default, the following SLIs can be used for evaluation, inspired by the [Site Reliability Engineering](https://landing.google.com/sre/sre-book/chapters/service-level-objectives) book from Google:

* *Response time*: The time it takes for a service to execute and complete a task or how long it takes to return a response to a request.
* *System throughput*: The number of requests per second that have been processed.
* *Error rate*: The fraction of all received requests that produced an error.

For more information about SLO and SLI, please take a look at [Specifications for Site Reliability Engineering with Keptn](https://github.com/keptn/spec/blob/0.1.2/sre.md).

## Prerequisites

* Running Keptn installation or a quality gates only installation as explained below.

* Clone example files used for this tutorial:

    ```console
    git clone --branch 0.6.0 https://github.com/keptn/examples.git --single-branch
    ```

    ```console
    cd examples/onboarding-carts
    ```

    The files you need are:

    * `shipyard-quality-gates.yaml` 
    * `slo-quality-gates.yaml`
    * `lighthouse-source-prometheus.yaml` | `lighthouse-source-dynatrace.yaml`

* **Bring your own monitored service**: This tutorial is slightly different compared to the others because you need to bring your own monitored service depending on the monitoring solution you want to use. For the sake of clarification, this tutorial uses a service called *catalogue* from the project *musicshop* meaning that you must adapt the commands to match your service and project name.  

    <details><summary>*Details for a service monitored by Prometheus*</summary>
    <p>
    
    This tutorial assumes that you have Prometheus that is either managed by Keptn or not. 

    * To use a Prometheus instance other than the one that is being managed by Keptn for a certain project, a secret containing the URL and the access credentials has to be deployed into the `keptn` namespace. The secret must have the following format:

          ```yaml
          user: username
          password: ***
          url: http://prometheus-service.monitoring.svc.cluster.local:8080
          ```

          If this information is stored in a file, e.g. `prometheus-creds.yaml`, the secret can be created with the following command. Please note that there is a naming convention for the secret because this can be configured per **project**. Thus, the secret has to have the name `prometheus-credentials-<project>`. Do not forget to replace the `<project>` placeholder with the name of your project:

          ```console
          kubectl create secret -n keptn generic prometheus-credentials-<project> --from-file=prometheus-credentials=./prometheus-creds.yaml
          ```
  
    Besides, this tutorial assumes that the service is properly monitored by Prometheus. Therefore, a *scrape job* and an *alert rule* are required:

    * A **scrape job** for your service. For more information about configuring a scrape job, see the official Prometheus documentation at section [scrape_config](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config). 
    
        To configure a scrape job for a Prometheus deployed on Kubernetes, you need to update the `prometheus-server-conf` ConfigMap at the `prometheus.yml` section with an additional scrape job:

            prometheus.yaml:
            ----
            scrape_configs: 
            - job_name: catalogue-musicshop-hardening
              honor_timestamps: false
              metrics_path: /prometheus
              static_configs:
              - targets:
                - catalogue.musicshop-hardening:80

    * An **alert rule** for the SLI and the scrape job. For more information about configuring alert rules, see the official Prometheus documentation at section [alerting_rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/). 
    
        To add an alert rule to a Prometheus deployed on Kubernetes, you need to update the `prometheus-server-conf` ConfigMap at the `prometheus.rules` section with an additional group. Please be aware that the values of the label service, stage, and project must match your service, stage, and project as created in the [below step](./#configure-keptn-and-activate-the-quality-gate).

              prometheus.rules:
              ----
              groups:
              - name: catalogue musicshop-hardening alerts
                rules:
                - alert: response_time_p95>600
                  expr: histogram_quantile(0.95,sum(rate(http_response_time_milliseconds_bucket{job='catalogue-musicshop-hardening'}[180s]))by(le))>600
                  for: 5m
                  labels:
                    severity: webhook
                    pod_name: catalogue
                    service: catalogue
                    stage: hardening
                    project: musicshop
                  annotations:
                    summary: response_time_p95>600
                    descriptions: Pod name {{ $labels.pod_name }}

    * Before continue, please verify that you have an alert rule as shown below: 

        {{< popup_image
          link="./assets/prometheus_alert.png"
          caption="Prometheus Alert for SLI"
          width="35%">}}

    </p>
    </details>

    <details><summary>*Details for a service monitored by Dynatrace*</summary>
    <p>

    To gather the monitoring data of your service, it must have the tags **keptn_project**, **keptn_stage**, and **keptn_service** attached: 
      {{< popup_image
        link="./assets/monitored_service.png"
        caption="Tags on catalogue service"
        width="35%">}}

    To add those tags:

    * Set the environment variable [DT_CUSTOM_PROP](../../reference/monitoring/dynatrace/#set-dt-custom-prop-before-onboarding-a-service) with a key-value pair for each tag in your deployment manifest and deploy your service: 

      ```
      env:
      - name: DT_CUSTOM_PROP
        value: "keptn_project=musicshop keptn_service=catalogue keptn_stage=hardening"
      ``` 

    * Add tagging rules in Dynatrace to detect these values and to create the tags for your monitored service. Therefore, you can use the scripts [applyAutoTaggingRules.sh](https://github.com/keptn-contrib/dynatrace-service/blob/release-0.5.0/deploy/scripts/applyAutoTaggingRules.sh) and
    [utils.sh](https://github.com/keptn-contrib/dynatrace-service/blob/release-0.5.0/deploy/scripts/utils.sh). Please run the following command with
    your Tenant ID and API Token as parameters: 

      ```console
      .\applyAutoTaggingRules.sh $DT_TENANT $DT_API_TOKEN
      ```
      
    </p>
    </details>

## Install Keptn just for this use case

If you want to install Keptn just to explore the capabilities of quality gates, you have the option to roll-out Keptn **without** components for automated delivery and operations. Therefore, set the `use-case` flag to `quality-gates` when executing the [install](../../reference/cli/#keptn-install) command:

```console
keptn install --platform=[aks|eks|gke|openshift|pks|kubernetes] --use-case=quality-gates
```

## Configure Keptn and activate the quality gate

* Create a Keptn project (e.g., *musicshop*) with only one the *hardening* stage declared in the `shipyard-quality-gates.yaml` file:

  ```
  keptn create project musicshop --shipyard=shipyard-quality-gates.yaml
  ```

* Create a Keptn service for your service (e.g., *catalogue*) you want to evaluate:

  ```console
  keptn create service catalogue --project=musicshop
  ```

  **Note:** Since you are not actively deploying a service in this tutorial, [keptn create service](../../reference/cli/#keptn-create-service) does not require you to provide a Helm chart compared to the [keptn onboard service](../../reference/cli/#keptn-onboard-service) command. 

* To activate the quality gate for your service, upload the `slo-quality-gates.yaml` file:

  ```console
  keptn add-resource --project=musicshop --stage=hardening --service=catalogue --resource=slo-quality-gates.yaml --resourceUri=slo.yaml
  ```

  **Note:** The activated quality gate is passed when the absolute value of the response time is below 600ms and the relative change of the response time compared to the previous evaluation is below 10%. The quality gate raises a warning when the absolute value of the response time is below 800ms.

## Install SLI provider

For this tutorial, you need to deploy the corresponding SLI provider for your monitoring solution. This can be for either the open-source monitoring solution *Prometheus* or *Dynatrace*. 

<details><summary>Prometheus SLI provider</summary>
<p>

1. Check if the Prometheus SLI provider is already available in your Keptn: 

    ```console
    kubectl get deployment -n keptn prometheus-sli-service
    ```

1. If the Prometheus SLI provider is not available, deploy and configure it for your project as explained [here](../../reference/monitoring/prometheus/#setup-prometheus-sli-provider).

1. To tell Keptn to use the deployed Prometheus SLI provider for your project, first adapt the ConfigMap in the `lighthouse-source-prometheus.yaml` file at the `metatdata.name` property to reference your project. Afterwards, apply the ConfigMap by executing the following command from within the `examples/onboarding-carts` folder:

    ```console
    kubectl apply -f lighthouse-source-prometheus.yaml
    ```

    ```yaml
    apiVersion: v1
    data:
      sli-provider: prometheus
    kind: ConfigMap
    metadata:
      name: lighthouse-config-PROJECTNAME
      namespace: keptn
    ```

1. Finally, upload the Prometheus-specific SLI configuration as stored in the `sli-config-prometheus.yaml` file:

    ```console
    keptn add-resource --project=musicshop --stage=hardening --service=catalogue --resource=sli-config-prometheus.yaml --resourceUri=prometheus/sli.yaml
    ```

</p>
</details>

<details><summary>Dynatrace SLI provider</summary>
<p>

1. Check if the Dynatrace SLI provider is already available in your Keptn: 

    ```console
    kubectl get deployment -n keptn dynatrace-sli-service
    ```

1. If the Dynatrace SLI provider is not available, deploy and configure it for your project as explained [here](../../reference/monitoring/dynatrace/#setup-dynatrace-sli-provider).

1. To tell Keptn to use the deployed Dynatrace SLI provider for your project, first adapt the ConfigMap in the `lighthouse-source-dynatrace.yaml` file at the `metatdata.name` property to reference your project. Afterwards, apply the ConfigMap by executing the following command from within the `examples/onboarding-carts` folder:

    ```console
    kubectl apply -f lighthouse-source-dynatrace.yaml
    ```

    ```yaml
    apiVersion: v1
    data:
      sli-provider: dynatrace
    kind: ConfigMap
    metadata:
      name: lighthouse-config-PROJECTNAME
      namespace: keptn
    ```

1. Finally, upload the Dynatrace-specific SLI configuration as stored in the `sli-config-dynatrace.yaml` file:

    ```console
    keptn add-resource --project=musicshop --stage=hardening --service=catalogue --resource=sli-config-dynatrace.yaml --resourceUri=dynatrace/sli.yaml
    ```

</p>
</details>

## Quality gates in action 

At this point, your service is ready and you can now start triggering evaluations of the SLO. A quality gate is a two-step procedure that consists of starting the evaluation and polling for the results.

At a specific point in time, e.g., after you have executed your tests or you have waited for enough live traffic, you can either start the evaluation of a quality gate manually using the Keptn CLI, or automate it by either including the Keptn CLI calls in your automation scripts, or by directly accessing the Keptn REST API. 

### Keptn CLI

* Execute a quality gate evaluation by using the Keptn CLI to [send event start-evaluation](../../reference/cli/#keptn-send-event-start-evaluation): 

  ```console
  keptn send event start-evaluation --project=musicshop --stage=hardening --service=catalogue --timeframe=5m
  ```

  This `start-evaluation` event will kick off the evaluation of the SLO of the catalogue service over the last 5 minutes. Evaluations can be done in seconds but may also take a while as every SLI provider needs to query each SLI first. This is why the Keptn CLI will return the `keptnContext`, which is basically a token we can use to poll the status of this particular evaluation. The output of the previous command looks like this:

  ```console
  Starting to send a start-evaluation event to evaluate the service catalogue in project musicshop
  ID of Keptn context: 6cd3e469-cbd3-4f73-xxxx-8b2fb341bb11
  ```

* Retrieve the evaluation results by using the Keptn CLI to [get event evaluation-done](../../reference/cli/#keptn-send-event-start-evaluation): 
    
  ```console
  keptn get evaluation-results --keptnContext=6cd3e469-cbd3-4f73-xxxx-8b2fb341bb11
  ```

  The result comes in the form of the `evaluation-done` event, which is specified [here](https://github.com/keptn/spec/blob/0.1.1/cloudevents.md#evaluation-done).

### Keptn API

* First, get the Keptn API endpoint and token by executing the following commands: 

  ```console
  KEPTN_ENDPOINT=https://api.keptn.$(kubectl get cm keptn-domain -n keptn -ojsonpath={.data.app_domain})
  KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
  ```

* Prepare the POST request body by filling out the next JSON object: 

  ```yaml
  {
    "type": "sh.keptn.event.start-evaluation",
    "data": {
      "start": "2019-11-21T11:00:00.000Z",
      "end": "2019-11-21T11:05:00.000Z",
      "project": "musicshop",
      "stage": "hardening",
      "service": "catalogue",
      "teststrategy": "manual"
    }
  }
  ```

* Execute a quality gate evaluation by sending a POST request with the Keptn API toke and the prepared payload:

  ```console
  curl -X POST "http://api.keptn.12.34.56.78.xip.io/v1/event" -H "accept: application/json" -H "x-token: YOUR_KEPTN_TOKEN" -H "Content-Type: application/json" -d "{ \"data\": { \"end\": \"2019-11-21T11:05:00.000Z\", \"project\": \"musicshop\", \"service\": \"catalogue\", \"stage\": \"hardening\", \"start\": \"2019-11-21T11:00:00.000Z\", \"teststrategy\": \"manual\" }, \"type\": \"sh.keptn.event.start-evaluation\"}"
  ```

  This request will kick off the evaluation of the SLO of the catalogue service over the last 5 minutes. Evaluations can be done in seconds but may also take a while as every SLI provider needs to query each SLI first. This is why the Keptn CLI will return the `keptnContext`, which is basically a token we can use to poll the status of this particular evaluation. The response to the POST request looks like this:

  ```console
  {"keptnContext":"384dae76-2d31-41e6-9204-39f2c1513906","token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDU0NDA4ODl9.OdkhIoJ9KuT4bm7imvEXHdEPjnU0pl5S7DqGibNa924"}
  ```

* Send a GET request to retrieve the evaluation result: 

  ```console
  curl -X GET "http://api.keptn.12.34.56.78.xip.io/v1/event?keptnContext=KEPTN_CONTEXT_ID&type=sh.keptn.events.evaluation-done" -H "accept: application/json" -H "x-token: YOUR_KEPTN_TOKEN"
  ```

  The result comes in the form of the `evaluation-done` event, which is specified [here](https://github.com/keptn/spec/blob/0.1.1/cloudevents.md#evaluation-done).
