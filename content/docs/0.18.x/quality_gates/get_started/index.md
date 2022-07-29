---
title: Get started with Quality Gates
description: Get started with Keptn Quality Gates for your project.
weight: 5
keywords: [0.18.x-quality_gates]
---

In this section, you will learn how to get started setting up a quality gate for your project.

:information_source: If you are not familiar with the concept of a quality gate, learn more [here](../../../concepts/quality_gates). 

## Definition of project, stage, and service

Let's assume you have an application that is running in an environment and composed of one or multiple services (aka. microservices). For example, you have an application called `easyBooking`, which can be broken down into the `booking` and `payment` service. Besides, the application is running in a `quality_assurance` environment (aka. stage).
In order to manage your application and services in Keptn, you need a Keptn [project, stage](../../manage/project/) and [services](../../manage/service).
For the `easyBooking` application, the Keptn entities of a project, stage, and service map to the example as follows:

* `project`: *easyBooking*
* `stage`: *quality_assurance*
* `service`: *booking* & *payment* (For the sake of simplicity, a quality gate will be configured for `booking` only.)

For defining the stage(s) a service has to go through, a [Shipyard](../../reference/files/shipyard) file is needed.
Since a quality gate should be configured for the *quality_assurance* environment only, the corresponding Shipyard for the *easyBooking* project looks as follows:

```yaml
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "quality-assurance"
```

<details><summary>*Why I do not need to specify a task sequence for quality gates in this stage?*</summary>
<p>

You do not have to define any task sequence in a stage because quality gates (aka. `evaluation`) are a built-in Keptn capability. Hence, there is no need to explicitly add an `evaluation` sequence. However, the explicit form of the above Shipyard file would look as the following one, which behaves the same way: 

```yaml
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "quality-assurance"
      sequences:
       - name: "evaluation"
         tasks:
         - name: "evaluation"
```

</p>
</details>

## Create project and service

* To create the Keptn project `easyBooking`, use the [keptn create project](../../reference/cli/commands/keptn_create_project/) command.

* To create the Keptn service `booking`, use the [keptn create service](../../reference/cli/commands/keptn_create_service/) command.

**Note:** It is not necessary to create the stage since it is declared in the Shipyard that is applied during the project creation.

## Step 1: Create project and service

* To create the Keptn project (e.g., `easyBooking`), use the [keptn create project](../../reference/cli/commands/keptn_create_project/) CLI command. Here the Shipyard file is needed, which declares the stages.

* To create the Keptn service (e.g., `booking`), use the [keptn create service](../../reference/cli/commands/keptn_create_service/) CLI command.

## Step 2: Configure Keptn to use your SLI-provider and add SLIs

Depending on the monitoring solution you have in place, a corresponding SLI-provider is required by Keptn.
This SLI-provider gets its queries for the individual metrics as discussed in the
[Service-Level Indicator (SLI)](../../reference/files/sli/) reference page.

* Familiarize yourself with the concept of an [SLI](../../reference/files/sli/)
and derive the set of indicators required for, e.g., the `booking` service.

* Follow the steps of deploying an SLI-provider and uploading an SLI config as described
on the reference page for the monitoring service you are using as a data source:

* [Datadog](https://artifacthub.io/packages/keptn/keptn-integrations/datadog-service)

* [Dynatrace](https://artifacthub.io/packages/keptn/keptn-integrations/dynatrace-service)

* [Prometheus](https://artifacthub.io/packages/keptn/keptn-integrations/prometheus-service)

## Step 3: Add SLO configuration to a service

By adding an [Service-Level Objective (SLO)](../../reference/files/slo/#service-level-objective) config to your service, you *activate* a quality gate for that service.

* To add an SLO to the `booking` service, use the [keptn add-resource](../../reference/cli/commands/keptn_add-resource/) CLI command.

## Step 4: Trigger the quality gate

At this point, you have:

:heavy_check_mark: created the project e.g. `easyBooking` and the service e.g. `booking`

:heavy_check_mark: configured Keptn to use your SLI-provider with custom SLIs

:heavy_check_mark: activated the quality gate for e.g. `booking` by providing an SLO

To trigger a quality gate evaluation, execute the [keptn trigger evaluation](../../reference/cli/commands/keptn_trigger_evaluation/) CLI command. This CLI command sends an event to Keptn, which acknowledges receipt of the event by returning a unique ID (`keptn-context`). This unique ID is required to fetch the result of the quality gate evaluation.

:information_source: Learn [here](../integration/) more about working with a quality gate and integrating it into an existing pipeline.

