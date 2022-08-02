---
title: sli
description: Configure and add Service-Level Indicators (SLIs) to your service.
weight: 725
keywords: [0.18.x-quality_gates]
---

The *sli.yaml* file contains definitions of the Service-Level Indicators (SLIs)
defined for your Keptn installation.
The SLI definition maps a query provided for the observability platform
you are using as a data source to a metric value that Keptn uses.

Each SLI is a defined quantitative measure of some aspects of the service level.
The query for an SLI is provider/tool-dependent;
therefore, each SLI-provider relies on a specific SLI configuration.

Provider-specific SLIs are discussed in the documentation
for the [integrations](../../../../integrations)
of each monitoring platform:

* [Datadog](https://artifacthub.io/packages/keptn/keptn-integrations/datadog-service)

* [Dynatrace](https://artifacthub.io/packages/keptn/keptn-integrations/dynatrace-service)

* [Prometheus](https://artifacthub.io/packages/keptn/keptn-integrations/prometheus-service)

You can also create and add your custom SLI-provider to Keptn.
Follow the instructions [Custom SLI-Provider](../../../integrations/sli_provider).

## Service-Level Indicator format

The SLI configuration contains a list of indicators,
each of which always consists of a name and the provider-specific query.

* Each SLI is a key-value pair
  * The SLI name or metric is the `key`
  * The provider-specific query is the `value`.
* The *sli.yaml* file can contain any number of SLIs.

## Add SLI configuration to a Service, Stage, or Project

You must add the SLI the Keptn service for your monitoring platform
to your service, stage, or project.

**Important:** In the following commands,
the value of the `resourceUri` must specify the SLI-provider
that can fetch the declared SLIs.
For Dynatrace, the value of the `resourceUri` must be: `dynatrace/sli.yaml`.

* To add an SLI configuration to a service,
use the [keptn add-resource](../../cli/commands/keptn_add-resource) command:

  ```console
  keptn add-resource --project=sockshop --stage=staging --service=carts --resource=sli-config.yaml  --resourceUri=dynatrace/sli.yaml
  ```

* To add an SLI configuration to a stage,
use the [keptn add-resource](../../cli/commands/keptn_add-resource) command:

  ```console
  keptn add-resource --project=sockshop --stage=staging --resource=sli-config.yaml --resourceUri=dynatrace/sli.yaml
  ```

  **Note:** This SLI configuration is applied for all services in this stage. 


* To add an SLI configuration to a project,
use the [keptn add-resource](../../cli/commands/keptn_add-resource) command:

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

    * SLI configuration on stage-level:

    ```yaml
    spec_version: "1.0"
    indicators:
      response_time_p95: "query C-2"
      response_time_p99: "query D-2"
    ```

    * SLI configuration on service-level: 

    ```yaml
    spec_version: "1.0"
    indicators:
      response_time_p99: "query D-3"
      sql-statements: "query E-3"
    ```

* If an evaluation of a service gets triggered, the following SLI configuration is used: 

    ```yaml
    spec_version: "1.0"
    indicators:
      throughput: "query A-1"         # SLI from project level
      error_rate: "query B-1"         # SLI from project-level
      response_time_p95: "query C-2"  # SLI from stage-level overrides SLI from project-level
      response_time_p99: "query D-3"  # SLI from service-level overrides SLI from stage-level
      sql-statements: "query E-3"     # SLI from service-level
    ```

## See also

* [slo](../slo)

* [Dynatrace](https://artifacthub.io/packages/keptn/keptn-integrations/dynatrace-service)

* [Prometheus](https://artifacthub.io/packages/keptn/keptn-integrations/prometheus-service)

* [Datadog](https://artifacthub.io/packages/keptn/keptn-integrations/datadog-service)

* [Quality Gates](../../../define/quality-gates)



