---
title: Get started with Quality Gates
description: Get started with Keptn Quality Gates for your project.
weight: 5
keywords: [0.7.x-quality_gates]
---

In this section, you will get an overview of the use-case and learn how to get started setting up a quality gate for your project.

:information_source: If you are not familiar with the concept of a quality gate, learn more [here](../../../concepts/quality_gates). 

**Quality gate result**

:bulb: *A quality gate answers one question: Does my service meet all defined quality criteria?*

Keptn quality gates help you answer this question by representing a quality gate results like this: 

<!--TODO: Change image and add annotations [1] ... [5] -->

{{< popup_image
  link="./assets/quality_gate.png"
  caption="Quality gate result"
  width="50%">}}

This visualization in the Keptn Bridge allows you to answer the following questions:
* First and most important, *does the service meet all defined quality criteria*? 
  * :one: Here, the overall result is a *warning* as shown by the orange bar and with the total score between 50 (fail) and 90 (pass) points.
* Which criteria did not meet its objective?
  * :two: The *response time P95* was measured with 1048 ms. This value is higher than the pass criteria set at 600 ms.
* What does the <=10% mean? 
  * :three: This is a relative comparison for which the quality gate result of a previous evaluation is taken into account. In fact, the last passed comparison is taken as a reference value.
* How did this quality result perform compared to others? 
  * :four: The answer to this question can be found in the Heatmap and Chart on the top.
  * The Heatmap highlights the currently selected quality gate result with a gray and solid border. The quality gate result that is taken into comparison is highlighted by the dashed border. 
  * :five: The total score of a quality gate result is depicted by the cell on the top.
  * The individual criteria are represented by a separate cell in the column. 

The rest of this section assumes you have Keptn [installed](../../operate/install/) on your cluster, your Keptn CLI is [authenticated](../../operate/install/#authenticate-keptn-cli), and you have a deployed application that is monitored by your favorite monitoring solution.

Given these requirements, this section defines the entities of a Keptn project, stage, and services using an example. Afterwards, five steps explain how to set up the quality gate, trigger it, and finally see the quality gate evaluation result.

## Definition of project, stage, and service

Let's assume you have an application that is running in an environment and composed of one or multiple services (aka. microservices). For example, you have an application called `easyBooking`, which can be broken down into the `booking` and `payment` service. Besides, the application is running in a `quality_assurance` environment (aka. stage).
In order to manage your application and services in Keptn, you need a Keptn [project, stage](../../manage/project/) and [services](../../manage/service).
For the `easyBooking` application, the Keptn entities of a project, stage, and service map to the example as follows:

* `project`: *easyBooking*
* `stage`: *quality_assurance*
* `service`: *booking* & *payment* (For the sake of simplicity, a quality gate will be configured for `booking` only.)

For defining the stage(s) but also the tasks a service has to go through, a [Shipyard](../../continuous_delivery/multi_stage/#declare-shipyard-before-creating-a-project) file is needed. Since a quality gate should be configured for the *quality_assurance* environment only, the corresponding Shipyard for the *easyBooking* project looks as follows:

```yaml
stages:
  - name: "quality_assurance"
```

**Note**: You do not have to define any tasks in the Shipyard file because quality gates are a Keptn built-in task.

## Create project and service

* To create the Keptn project `easyBooking`, use the [keptn create project](../../reference/cli/commands/keptn_create_project/) command.

* To create the Keptn service `booking`, use the [keptn create service](../../reference/cli/commands/keptn_create_service/) command.

**Note:** It is not needed to create the stage since it is declared in the Shipyard that is applied during the project creation. 

## Step 1: Create project and service

* To create the Keptn project (e.g., `easyBooking`), use the [keptn create project](../../reference/cli/commands/keptn_create_project/) CLI command. Here the Shipyard file is needed, which desclares the stages.

* To create the Keptn service (e.g., `booking`), use the [keptn create service](../../reference/cli/commands/keptn_create_service/) CLI command.

## Step 2: Configure Keptn to use your SLI-provider and add SLIs

Depending on the monitoring solution you have in place, a corresponding SLI-provider is required by Keptn. This SLI-provider gets its queries for the individual metrics from the [Service-Level Indicator (SLI)](../sli/#service-level-indicator) config. 

* Familiarize with the concept of an [SLI](../sli/#service-level-indicator) and derive the set of indicators required for, e.g., the `booking` service. 

* Follow the steps of deploying an SLI-provider and uploading an SLI config as described [here](../sli-provider/).

## Step 3: Add SLO configuration to a service

By adding an [Service-Level Objective (SLO)](../slo/#service-level-objective) config to your service, you *activate* a quality gate for that service.

* To add an SLO to the `booking` service, use the [keptn add-resource](../../reference/cli/commands/keptn_add-resource/) CLI command.

## Step 4: Trigger the quality gate

At this point, you have:

:heavy_check_mark: created the project e.g. `easyBooking` and the service e.g. `booking`

:heavy_check_mark: configured Keptn to use your SLI-provider with custom SLIs

:heavy_check_mark: activated the quality gate for e.g. `booking` by providing an SLO

To trigger a quality gate evaluation, execute the [keptn send event start-evaluation](../../reference/cli/commands/keptn_send_event_start-evaluation/) CLI command. This CLI command sends an event to Keptn, which acknowledges receipt of the event by returning a unique ID (`keptn-context`). This unique ID is required to fetch the result of the quality gate evaluation.

:information_source: Learn [here](../integration/) more about working with a quality gate and integrating it into an existing pipeline.

## Step 5: See quality gate evaluation result in Keptn Bridge

<!--TODO: Add screeshot from a single run -->
