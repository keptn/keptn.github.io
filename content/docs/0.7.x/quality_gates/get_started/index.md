---
title: Get started with Quality Gates
description: Get started with Keptn Quality Gates for your project.
weight: 5
keywords: [0.7.x-quality_gates]
---


In this section, you will get an overview of the use-case and learn how to get started setting up a quality gate for your project assuming you are [authenticated](../../operate/install/#authenticate-keptn-cli) against a Keptn installation and have a deployed application.

:information_source: If you are not familiar with the concept of a quality gate, learn [here](../../../concepts/quality_gates) more. 

**Quality gate result**

:bulb: *A quality gate answers one question: Does my service meet all my defined quality criteria?*

Keptn quality gates help you answering this question by representing a quality gate results like this: 

{{< popup_image
  link="./assets/quality_gate.png"
  caption="Quality gate result"
  width="50%">}}

* First and most important, *did the service met all my defined quality criteria*? 
  * :one: The overall result is a *warning* as shown by the orange bar and with the total score between 50 (fail) and 90 (pass).
* Which criteria did not meet its objective?
  * :two: The response time P95 was measured with 1,048 ms. This value is higher than the pass criteria of 600 ms.
* What does the <=10% mean? 
  * :three: This is a relative comparision for which the quality gate result of a previous evaluation is taken into account. In fact, the last passed comparison is taken as reference value.
* How did this quality result perform compared to others? 
  * :four: The answer to this question can be found in the Heatmap and Chart on the top.
  * The Heatmap highlights the currently selected quality gate result with a gray and solid border. The quality gate result that are taken into comparison is highlighted by the dashed border. 
  * :five: The total score of a quality gate result is depicted by the cell on the top.
  * The individual criteria are then represented by a seperate cell in the column. 
   
## Definition of project, stage and service

You have an application that is running in an environment and composed of one or multiple services (aka. microservices). For example, you have an application called `easyBooking`, which can be broken down into the `booking` and `payment` service. The application is running in a `quality_assurance` environment (aka. stage).

Given the `easyBooking` application, the Keptn entities of a project, stage, and service map to the example as follows:

* `project`: *easyBooking*
* `stage`: *quality_assurance*
* `service`: *booking* & *payment* (For the sake of simplicity, we want to configure just a quality gate for `booking`.)

Before heading on, it is required to bring in the specification of the [Shipyard](../../continuous_delivery/multi_stage/#declare-shipyard-before-creating-a-project) that declares the environment of the project and the processes a service has to go through. Due to the fact that a quality gate should be configured for the *quality_assurance* environment only, the Shipyard for the *easyBooking* project looks as follows:

```yaml
stages:
  - name: "quality_assurance"
```

## Create project and service

* To create the Keptn project `easyBooking`, use the [keptn create project](../../reference/cli/commands/keptn_create_project/) command.

* To create the Keptn service `booking`, use the [keptn create service](../../reference/cli/commands/keptn_create_service/) command.

**Note:** It is not needed to create the stage, since it is declared in the Shipyard that is applied during the project creation. 

## Configure Keptn to use your SLI-provider and add SLIs

Depending on the monitoring solution you have in place, a corresponding SLI-provider needs to be running inside Keptn. This SLI-provider gets its queries for the individual metrics from the [Service-Level Indicator (SLI)](../sli/#service-level-indicator) config. 

* Familiarize with the concept of an [SLI](../sli/#service-level-indicator) and derive the set of indicators required for the `booking` service. 

* Follow the steps of deploying an SLI-provider and uploading an SLI config as described [here](../sli-provider/).

## Add SLO configuration to a service

By adding an [Service-Level Objective (SLO)](../slo/#service-level-objective) config to your service you *activate* a quality gate for the service.

* To add an SLO to the `booking` service, use the [keptn add-resource](../../reference/cli/commands/keptn_add-resource/) command.

## Trigger the quality gate

At this point, you have:

:heavy_check_mark: created the project `easyBooking` and the service `booking`

:heavy_check_mark: configured Keptn to use your SLI-provider with custom SLIs

:heavy_check_mark: activated the quality gate for `booking` by providing an SLO

To trigger a quality gate evaluation, execute the [keptn send event start-evaluation](../../reference/cli/commands/keptn_send_event_start-evaluation/) command. This command sends an event to Keptn, which acknowledges receipt of the event by returning a unique ID (`keptn-context`). This unique ID is required to fetch the result of the quality gate evaluation.

:information_source: Learn [here](../integration/) more about working with a quality gate and integrating it into an exisiting pipeline.
