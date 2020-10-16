---
title: Working and Integrating with Quality Gates
description: Integrate a Quality Gate into an existing pipeline.
weight: 7
keywords: [0.7.x-quality_gates]
---

In order to work with and integrate quality gates, two actions are needed:

1. Triggering a quality gate evaluation for a service in a specific project/stage and for a certain timeframe
1. Fetching the evaluation result of a quality gate 

This section explains how to use the Keptn CLI and the Keptn API for those two actions.

## Using the Keptn CLI to work with quality gates

* To work with the Keptn CLI, make sure your Keptn CLI is [authenticated](../../operate/install/#authenticate-keptn-cli) against your Keptn installation.

* To verify the CLI connection to your Keptn, execute [keptn status](../../reference/cli/commands/keptn_status/).

### Trigger a quality gate evaluation

To trigger a quality gate evaluation for a service in the stage of a specific project, the Keptn CLI provides two commands: 

<details><summary>`keptn send event start-evaluation` (*recommended*)</summary>
<p>

* The [keptn send event start-evaluation](../../reference/cli/commands/keptn_send_event_start-evaluation/) command allows specifying the timeframe of the evaluation using the `--start`, `--end`, or `timeframe` flags. 

* To trigger a quality gate evaluation with a timeframe of `5` minutes starting at `2020-12-31T10:00:00`, use the following example:

```console
keptn send event start-evaluation --project=easyBooking --stage=quality_assurance --service=booking --start=2020-12-31T11:59:59 --timeframe=5m
```

* This command returns a unique ID (`keptn-context`) that is required to retrieve the evaluation result. 

</p>
</details>

<details><summary>`keptn send event`</summary>
<p>

* First, specify a valid Keptn CloudEvent of type [sh.keptn.event.start-evaluation](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md#start-evaluation) and store it as JSON file, e.g., `trigger_quality_gate.json`

```json
{
  "source": "keptn-cli",
  "specversion": "0.2",
  "type": "sh.keptn.event.start-evaluation",
  "contenttype": "application/json",
  "data": {
    "deploymentstrategy": "direct",
    "image": "docker.io/keptnexamples/booking",
    "tag": "0.11.2",
    "start": "2020-09-01T08:31:06Z",
    "end": "2020-09-01T08:36:06Z",
    "labels": {
      "buildId": "build-17",
      "owner": "JohnDoe",
      "testNo": "47-11"
    },
    "project": "easyBooking",
    "service": "booking",
    "stage": "quality_assurance",
    "teststrategy": "manual"
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

### Fetch the evaluation result of a quality gate

* To fetch a quality gate evaluation result, the Keptn CLI provides the [keptn get event evaluation-done](../../reference/cli/commands/keptn_get_event_evaluation-done/) command. This command requires the ID (`--keptn-context`) returned by the `send event start-evaluation` or `send event` command.

```console
keptn get event evaluation-done --keptn-context=1234-5678-90ab-cdef
```

**Note:** The evaluation of the quality gate may take some time, especially because the metrics first have to be available in your monitoring solution and need to be queried by the SLI-provider. Consequently, the result is not immediately available.


## Using the Keptn API to work with quality gates

<!--TODO: Provide link to bridge-->
* To work with the Keptn API, get the API token from the [Keptn Bridge]() and follow the Keptn API link to the Swagger-UI. 

* If you want to interact with the Keptn API via cURL, you also need the Keptn API URL and API token

### Trigger a quality gate evaluation 

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

* The endpoint returns a unique ID (`keptn-context`) that is required to retrieve the evaluation result. (*Note:* The response also contains a *token* that is required to open a WebSocket communication. This token is not needed now.)


</p>
</details>

<details><summary>**Trigger via: `/v1/event`**</summary>
<p>

* Specify a valid Keptn CloudEvent of type [sh.keptn.event.start-evaluation](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md#start-evaluation) and store it as JSON file, e.g., `trigger_quality_gate.json`

```json
{
  "source": "keptn-cli",
  "specversion": "0.2",
  "type": "sh.keptn.event.start-evaluation",
  "contenttype": "application/json",
  "data": {
    "deploymentstrategy": "direct",
    "image": "docker.io/keptnexamples/booking",
    "tag": "0.11.2",
    "start": "2020-09-01T08:31:06Z",
    "end": "2020-09-01T08:36:06Z",
    "labels": {
      "buildId": "build-17",
      "owner": "JohnDoe",
      "number": "1234"
    },
    "project": "easyBooking",
    "service": "booking",
    "stage": "quality_assurance",
    "teststrategy": "manual"
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

* The endpoint returns a unique ID (`keptn-context`) that is required to retrieve the evaluation result. (*Note:* The response also contains a *token* that is required to open a WebSocket communication. This token is not needed now.)

</p>
</details>

### Fetch the evaluation result of a quality gate 

* To fetch a quality gate evaluation result, the Keptn CLI provides the `/event` endpoint. This endpoint requires the query parameters `keptn-context` and `type`; latter is always `sh.keptn.events.evaluation-done`. 

```console

curl -X GET "${KEPTN_ENDPOINT}/api/mongodb-datastore/event?keptnContext={keptnContext}&type=sh.keptn.events.evaluation-done" \
-H "accept: application/json; charset=utf-8" \
-H "x-token: ${KEPTN_API_TOKEN}"
```

**Note:** The evaluation of the quality gate may take some time, especially because the metrics first have to be available in your monitoring solution and need to be queried by the SLI-provider. Consequently, the result is not immediately available.

## Integrate into an existing pipeline

To integrate quality gates into an existing pipeline, it is recommended to use the API-based approach outlined [above](./#using-the-keptn-api-to-work-with-quality-gates). As stated there, the evaluation result is not immediately available. Hence, build your integration using a polling mechanism that polls the evaluation result every 10 seconds and terminates after, e.g., 10 retries. 

<!-- 
### Custom integrations

Find here custom integrations built by the Keptn community:

* [Azure DevOps Keptn Integration](https://github.com/keptn-sandbox/keptn-azure-devops-extension): *Integration of Keptn within your TFS/VSTS/AZDO build*  
-->
