---
title: Quality Gates
description: Implement Quality Gate evaluations in your project
weight: 70
keywords: [0.18.x-quality_gates]
---

A quality gate allows you to validate a deployment or release
using data provided by your observability platform
and using quality criteria that you define as Service Level Objectives (SLOs);
see the [SLO](../../reference/files/slo) reference page.

:information_source: If you are not familiar with the concept of a quality gate, learn more [here](../../../concepts/quality_gates). 

## Definition of project, stage, and service

Let's assume you have an application that is running in an environment and composed of one or multiple services (aka. microservices). For example, you have an application called `easyBooking`, which can be broken down into the `booking` and `payment` service. Besides, the application is running in a `quality_assurance` environment (aka. stage).
In order to manage your application and services in Keptn, you need a Keptn [project, stage](../../manage/project/) and [services](../service).
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

* To create the Keptn project `easyBooking`,
use the [keptn create project](../../reference/cli/commands/keptn_create_project/) command
as discussed in [Create a project](../../manage/project).

* To create the Keptn service `booking`,
use the [keptn create service](../../reference/cli/commands/keptn_create_service/) command
as discussed in [Create a service](../service/#create-a-service).

**Note:** It is not necessary to create the stage since it is declared in the Shipyard that is applied during the project creation.

**Step 1: Create project and service**

* To create the Keptn project (e.g., `easyBooking`), use the [keptn create project](../../reference/cli/commands/keptn_create_project/) CLI command. Here the Shipyard file is needed, which declares the stages.

* To create the Keptn service (e.g., `booking`), use the [keptn create service](../../reference/cli/commands/keptn_create_service/) CLI command.

**Step 2: Configure Keptn to use your SLI-provider and add SLIs**

Depending on the monitoring solution you have in place, a corresponding SLI-provider is required by Keptn.
This SLI-provider gets its queries for the individual metrics from the [Service-Level Indicator (SLI)](../../reference/files/sli/) config.

* Familiarize yourself with the concept of an [SLI](../../reference/files/sli/)
and derive the set of indicators required for, e.g., the `booking` service.

* Follow the steps of deploying an SLI-provider and uploading an SLI config as described
on the reference page for the monitoring service you are using as a data source:

* [Datadog](https://artifacthub.io/packages/keptn/keptn-integrations/datadog-service)

* [Dynatrace](https://artifacthub.io/packages/keptn/keptn-integrations/dynatrace-service)

* [Prometheus](https://artifacthub.io/packages/keptn/keptn-integrations/prometheus-service)

**Step 3: Add SLO configuration to a service**

By adding an [Service-Level Objective (SLO)](../../reference/files/slo/#service-level-objective) config to your service, you *activate* a quality gate for that service.

* To add an SLO to the `booking` service, use the [keptn add-resource](../../reference/cli/commands/keptn_add-resource/) CLI command.

**Step 4: Use the quality gate**

At this point, you have:

:heavy_check_mark: created the project e.g. `easyBooking` and the service e.g. `booking`

:heavy_check_mark: configured Keptn to use your SLI-provider with custom SLIs

:heavy_check_mark: activated the quality gate for e.g. `booking` by providing an SLO

To trigger a quality gate evaluation, execute the [keptn trigger evaluation](../../reference/cli/commands/keptn_trigger_evaluation/) CLI command. This CLI command sends an event to Keptn, which acknowledges receipt of the event by returning a unique ID (`keptn-context`). This unique ID is required to fetch the result of the quality gate evaluation.
This is discussed more below.

## Working with quality gates

In order to work with and integrate quality gates, two actions are needed:

1. Trigger a quality gate evaluation for a service in a specific project/stage and for a certain timeframe
1. Fetch the evaluation result of a quality gate 

This section explains how to use the Keptn CLI and the Keptn API for those two actions.

### Use the Keptn CLI to work with quality gates

* To work with the Keptn CLI, make sure your Keptn CLI is [authenticated](../../../install/authenticate-cli-bridge//#authenticate-keptn-cli) against your Keptn installation.

* To verify the CLI connection to your Keptn, execute [keptn status](../../reference/cli/commands/keptn_status/).

#### Trigger a quality gate evaluation

To trigger a quality gate evaluation for a service in the stage of a specific project, the Keptn CLI provides two commands: 

<details><summary>`keptn trigger evaluation` (*recommended*)</summary>
<p>

* The [keptn trigger evaluation](../../reference/cli/commands/keptn_trigger_evaluation/) command allows specifying the timeframe of the evaluation using the `--start`, `--end`, or `timeframe` flags. 

* To trigger a quality gate evaluation with a timeframe of `5` minutes starting at `2020-12-31T10:00:00`, use the following example:

```console
keptn trigger evaluation --project=easyBooking --stage=quality_assurance --service=booking --start=2020-12-31T11:59:59 --timeframe=5m
```

* This command returns a unique ID (`keptn-context`) that is required to retrieve the evaluation result. 

</p>
</details>

<details><summary>`keptn send event`</summary>
<p>

* First, specify a valid Keptn CloudEvent of type [sh.keptn.event.<stage>.evaluation.triggered](https://github.com/keptn/spec/blob/0.2.2/cloudevents.md#evaluation-triggered) and store it as JSON file, e.g., `trigger_quality_gate.json`. Choose one of the following three options to specify the event: 

    * *Option 1 - Define start and end time to evaluate:*
      ```json
      {
          "source": "keptn-cli",
          "specversion": "1.0",
          "type": "sh.keptn.event.quality_assurance.evaluation.triggered",
          "contenttype": "application/json",
          "data": {
            "evaluation": {
              "start": "2020-09-01T08:31:06Z",
              "end": "2020-09-01T08:36:06Z"
            },
            "labels": {
              "buildId": "build-17",
              "owner": "JohnDoe",
              "testNo": "47-11"
            },
            "project": "easyBooking",
            "service": "booking",
            "stage": "quality_assurance"
          }
      }
      ```

    * *Option 2 - Define time frame to evaluate*
      ```json
      {
          "source": "keptn-cli",
          "specversion": "1.0",
          "type": "sh.keptn.event.quality_assurance.evaluation.triggered",
          "contenttype": "application/json",
          "data": {
            "evaluation": {
              "timeframe": "5m"
            },
            "labels": {
              "buildId": "build-17",
              "owner": "JohnDoe",
              "testNo": "47-11"
            },
            "project": "easyBooking",
            "service": "booking",
            "stage": "quality_assurance"
          }
      }
      ```

    * *Option 3 - Define start and end time of previous test*
      ```json
      {
          "source": "keptn-cli",
          "specversion": "1.0",
          "type": "sh.keptn.event.quality_assurance.evaluation.triggered",
          "contenttype": "application/json",
          "data": {
            "test": {
              "start": "2020-09-01T08:31:06Z",
              "end": "2020-09-01T08:36:06Z"
            },
            "labels": {
              "buildId": "build-17",
              "owner": "JohnDoe",
              "testNo": "47-11"
            },
            "project": "easyBooking",
            "service": "booking",
            "stage": "quality_assurance"
          }
      }
      ```

* Trigger a quality gate evaluation by sending the CloudEvent to Keptn using the [keptn send event](../../reference/cli/commands/keptn_send_event/) command:

```console
keptn send event --file=trigger_quality_gate.json 
```

* This command returns a unique ID (`keptn-context`) that is required to retrieve the evaluation result. 

</p>
</details>

#### Fetch the evaluation result of a quality gate

* To fetch a quality gate evaluation result, the Keptn CLI provides the [keptn get event sh.keptn.event.evaluation.finished](../../reference/cli/commands/keptn_get_event/) command. This command requires the ID (`--keptn-context`) returned by the `trigger evaluation` or `send event` command, as well as the name of the project (`--project`).

```console
keptn get event sh.keptn.event.evaluation.finished --keptn-context=1234-5678-90ab-cdef --project=easyBooking
```

**Note:** The evaluation of the quality gate may take some time, especially because the metrics first have to be available in your monitoring solution and need to be queried by the SLI-provider. Consequently, the result is not immediately available.

### Use the Keptn API to work with quality gates

* To work with the Keptn API, get the API token from the [Keptn Bridge]() and follow the Keptn API link to the Swagger-UI. 

* If you want to interact with the Keptn API via cURL, you also need the Keptn API URL and API token

#### Trigger a quality gate evaluation 

To trigger a quality gate evaluation for a service in the stage of a specific project, the Keptn API provides two endpoints: 


<details><summary>**Trigger via: `/v1/project/{projectName}/stage/{stageName}/service/{serviceName}/evaluation`** (recommended)</summary>
<p>

* This endpoint requires the path parameters `projectName`, `stageName`, and `serviceName`: `/api/v1/project/{projectName}/stage/{stageName}/service/{serviceName}/evaluation`

* The required payload allows you to set the `start`, `end`, and `timeframe` (choose either the `end` or `timeframe` parameter):

```json
{
    "start": "2020-09-28T07:00:00",     // required
    "end": "2020-09-28T07:05:00",       // cannot be used in combination with 'timeframe'
    "timeframe": "5m",                  // cannot be used in combination with 'to'
    "labels": {
      "buildId": "build-17",
      "owner": "JohnDoe",
      "testNo": "47-11"
    }
}
```

* Trigger a quality gate evaluation with a POST request:

```console
curl -X POST "${KEPTN_ENDPOINT}/v1/project/easyBooking/stage/quality_assurance/service/booking/evaluation" \
-H "accept: application/json; charset=utf-8" \
-H "x-token: ${KEPTN_API_TOKEN}" \
-H "Content-Type: application/json; charset=utf-8" \
-d "{ \"start\": \"2020-09-28T07:00:00\", \"timeframe\": \"5m\", \"labels\":{\"buildId\":\"build-17\",\"owner\":\"JohnDoe\",\"testNo\":\"47-11\"}}"
```

* The endpoint returns a unique ID (`keptn-context`) that is required to retrieve the evaluation result. (**Note:** The response also contains a *token* that is required to open a WebSocket communication. This token is not needed now.)


</p>
</details>

<details><summary>**Trigger via: `/v1/event`**</summary>
<p>

* Specify a valid Keptn CloudEvent of type [sh.keptn.event.[stage].evaluation.triggered](https://github.com/keptn/spec/blob/0.2.2/cloudevents.md#evaluation.triggered) and store it as JSON file, e.g., `trigger_quality_gate.json`. Choose one of the following three options to specify the event: 

    * *Option 1 - Define start and end time to evaluate:*
      ```json
      {
          "source": "keptn-cli",
          "specversion": "1.0",
          "type": "sh.keptn.event.quality_assurance.evaluation.triggered",
          "contenttype": "application/json",
          "data": {
            "evaluation": {
              "start": "2020-09-01T08:31:06Z",
              "end": "2020-09-01T08:36:06Z"
            },
            "labels": {
              "buildId": "build-17",
              "owner": "JohnDoe",
              "testNo": "47-11"
            },
            "project": "easyBooking",
            "service": "booking",
            "stage": "quality_assurance"
          }
      }
      ```

    * *Option 2 - Define time frame to evaluate*
      ```json
      {
          "source": "keptn-cli",
          "specversion": "1.0",
          "type": "sh.keptn.event.quality_assurance.evaluation.triggered",
          "contenttype": "application/json",
          "data": {
            "evaluation": {
              "timeframe": "5m"
            },
            "labels": {
              "buildId": "build-17",
              "owner": "JohnDoe",
              "testNo": "47-11"
            },
            "project": "easyBooking",
            "service": "booking",
            "stage": "quality_assurance"
          }
      }
      ```

    * *Option 3 - Define start and end time of previous test*
      ```json
      {
          "source": "keptn-cli",
          "specversion": "1.0",
          "type": "sh.keptn.event.quality_assurance.evaluation.triggered",
          "contenttype": "application/json",
          "data": {
            "test": {
              "start": "2020-09-01T08:31:06Z",
              "end": "2020-09-01T08:36:06Z"
            },
            "labels": {
              "buildId": "build-17",
              "owner": "JohnDoe",
              "testNo": "47-11"
            },
            "project": "easyBooking",
            "service": "booking",
            "stage": "quality_assurance"
          }
      }
      ```

* Trigger a quality gate evaluation with a POST request on `/event`:

```console
curl -X POST "${KEPTN_ENDPOINT}/v1/event" \
-H "accept: application/json; charset=utf-8" \
-H "x-token: ${KEPTN_API_TOKEN}" \
-H "Content-Type: application/json; charset=utf-8" \
-d @./trigger_quality_gate.json
```

* The endpoint returns a unique ID (`keptn-context`) that is required to retrieve the evaluation result. (**Note:** The response also contains a *token* that is required to open a WebSocket communication. This token is not needed now.)

</p>
</details>

#### Fetch the evaluation result of a quality gate 

* To fetch a quality gate evaluation result, the Keptn CLI provides the `/event` endpoint. This endpoint requires the query parameters `keptn-context` and `type`; latter is always `sh.keptn.event.evaluation.finished`. 

```console
curl -X GET "${KEPTN_ENDPOINT}/api/mongodb-datastore/event?keptnContext={keptnContext}&type=sh.keptn.event.evaluation.finished" \
-H "accept: application/json; charset=utf-8" \
-H "x-token: ${KEPTN_API_TOKEN}"
```

**Note:** The evaluation of the quality gate may take some time, especially because the metrics first have to be available in your monitoring solution and need to be queried by the SLI-provider. Consequently, the result is not immediately available.

## Integrate into an existing pipeline

To integrate quality gates into an existing pipeline, use the API-based approach outlined above.
As stated there, the evaluation result is not immediately available. Hence, build your integration using a polling mechanism that polls the evaluation result every 10 seconds and terminates after, e.g., 10 retries. 

