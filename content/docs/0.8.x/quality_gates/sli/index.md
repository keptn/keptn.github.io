---
title: Service-Level Indicators (SLI)
description: Configure Service-Level Indicators (SLIs) for your service.
weight: 2
keywords: [0.8.x-quality_gates]
---

A Service-Level Indicator (SLI) is a defined quantitative measure of some aspects of the service level. The query for an SLI is provider/tool-dependent. This is the reason why each SLI-provider relies on an individual SLI configuration. This SLI configuration lists those SLIs that are supported by the SLI-provider by their name and query whereas the query is provider specific. 

## Service-Level Indicator

* An SLI is a key-value pair with the SLI name as key and the provider-specific query as value.
* An SLI configuration can contain any number of SLIs.

**Example of Service-Level Indicators (SLIs):**

```yaml
spec_version: "1.0"
indicators:
  throughput: "builtin:service.requestCount.total:merge(0):count?scope=tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
  error_rate: "builtin:service.errors.total.count:merge(0):avg?scope=tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
  response_time_p50: "builtin:service.response.time:merge(0):percentile(50)?scope=tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
  response_time_p90: "builtin:service.response.time:merge(0):percentile(90)?scope=tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
  response_time_p95: "builtin:service.response.time:merge(0):percentile(95)?scope=tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
```

## Provider-specific SLIs

Please follow the links to the provider-specific SLIs: 

* [Dynatrace](../../monitoring/dynatrace/sli_provider/#configure-custom-dynatrace-slis) 

* [Prometheus](../../monitoring/prometheus/sli-provider/#configure-custom-prometheus-slis) 

## Add SLI configuration to a Service, Stage, or Project

**Important:** In the following commands, the value of the `resourceUri` must specifiy the SLI-provider that can fetch the declared SLIs. In case of Dynatrace, for example, the value of the `resourceUri` must be: `dynatrace/sli.yaml`.

* To add an SLI configuration to a service, use the [keptn add-resource](../../reference/cli/commands/keptn_add-resource) command:

  ```console
  keptn add-resource --project=sockshop --stage=staging --service=carts --resource=sli-config.yaml  --resourceUri=dynatrace/sli.yaml
  ```

* To add an SLI configuration to a stage, use the [keptn add-resource](../../reference/cli/commands/keptn_add-resource) command:

  ```console
  keptn add-resource --project=sockshop --stage=staging --resource=sli-config.yaml --resourceUri=dynatrace/sli.yaml
  ```

  **Note:** This SLI configuration is applied for all services in this stage. 


* To add an SLI configuration to a project, use the [keptn add-resource](../../reference/cli/commands/keptn_add-resource) command:

  ```console
  keptn add-resource --project=sockshop --resource=sli-config.yaml --resourceUri=dynatrace/sli.yaml
  ```

  **Note:** This SLI configuration is applied for all services in all stages of this project.

**Example of multiple SLI configurations:**

* Let's assume, we add the following SLI configurations to a project, stage, and service: 

    * SLI configuration on project-level:

    ```yaml
    spec_version: "1.0"
    indicators:
      throughput: "query A-1"
      error_rate: "query B-1"
      response_time_p95: "query C-1"
    ```

    * SLI configuraiton on stage-level:

    ```yaml
    spec_version: "1.0"
    indicators:
      response_time_p95: "query C-2"
      response_time_p99: "query D-2"
    ```

    * SLI configuraiton on service-level: 

    ```yaml
    spec_version: "1.0"
    indicators:
      response_time_p99: "query D-3"
      sql-statements: "query E-3"
    ```

* If an evaluation of a service gets triggered, the following SLI configuration will be used: 

    ```yaml
    spec_version: "1.0"
    indicators:
      throughput: "query A-1"         # SLI from project level
      error_rate: "query B-1"         # SLI from project-level
      response_time_p95: "query C-2"  # SLI from stage-level overrides SLI from project-level
      response_time_p99: "query D-3"  # SLI from service-level overrides SLI from stage-level
      sql-statements: "query E-3"     # SLI from service-level
    ```

