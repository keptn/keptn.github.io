---
title: Working and Integrating with Quality Gates
description: Integrate a Quality Gate into an existing pipeline.
weight: 7
keywords: [0.8.x-quality_gates]
---

Working with quality gates means that you can use either the Keptn CLI or API to perform the two actions of: 

1. Triggering a quality gate evaluation for service in a specific project/stage
1. Fetching the evaluation result of a quality gate 

## Quality Gates managed by Keptn CLI

* To work with the Keptn CLI, make sure your Keptn CLI is authenticated against the right Keptn installation; find the instructions [here](../../operate/install/#authenticate-keptn-cli) or use [Keptn Bridge]()**<-!provide link!** to get the credentials for the [keptn auth](../../reference/cli/commands/keptn_auth/) command.

* To verify the CLI connection to your Keptn, execute [keptn status](../../reference/cli/commands/keptn_status/).

### Trigger a quality gate evaluation

To trigger a quality gate for a service in the stage of a specific project, the Keptn CLI provides two commands: 

1. [keptn send event start-evaluation](../../reference/cli/commands/keptn_send_event_start-evaluation/) (*recommended*)
1. [keptn send event](../../reference/cli/commands/keptn_send_event/)

Both commands return a unique ID (`keptn-context`) that is required to retrieve the evaluation result. 

<details><summary>**Trigger via: `keptn send event start-evaluation`**</summary>
<p>

* This command allows specifying the timeframe of the evaluation using the `--start`, `--end`, or `timeframe` flags. 

* To trigger, for example, a quality gate evaluation of `5` minutes starting at `2020-12-31T11:59:59`, use the command as follows:

```console
keptn send event start-evaluation --project=easyBooking --stage=quality_assurance --service=booking --start=2020-12-31T11:59:59 --timeframe=5m
```

</p>
</details>

<details><summary>**Trigger via: `keptn send event`**</summary>
<p>

* Specify a valid Keptn CloudEvent of type [sh.keptn.event.start-evaluation](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md#start-evaluation) and store it as JSON file, e.g.: `trigger_quality_gate.json`

```json
{
  "source": "keptn-cli",
  "specversion": "0.2",
  "type": "sh.keptn.event.start-evaluation",
  "contenttype": "application/json",
  "data": {
    "deploymentstrategy": "",
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

* Trigger a quality gate by sending the CloudEvent to Keptn:

```console
keptn send event --file=trigger_quality_gate.json 
```

</p>
</details>

### Fetch the evaluation result of a quality gate

Be aware that calculating the evaluation result of a quality gate may take some time and is depending on the SLI-provider. Consequently, the result is not immediately available.

* To fetch a quality gate evaluation, the Keptn CLI provides the [keptn get event evaluation-done](../../reference/cli/commands/keptn_get_event_evaluation-done/) command. This command requires the ID (`--keptn-context`) returned by the `send event start-evaluation` or `send event` command.

```console
keptn get event evaluation-done --keptn-context=1234-5678-90ab-cdef
```

## Quality Gates managed by Keptn API

* To work with the Keptn API, get the API token from the [Keptn Bridge]()**<-!provide link!** and follow the Keptn API link to the Swagger-UI. 

* If you want to interact with the Keptn APV via cURL, store the Keptn API and API token in an environment variable explained [here](../../operate/install/#authenticate-keptn-cli).

### Trigger a quality gate evaluation 

To trigger a quality gate for a service in the stage of a specific project, the Keptn API provides two endpoints: 

* `/evaluation`
* `/event`

Both endpoints return a unique ID (`keptn-context`) that is required to retrieve the evaluation result. (*Note:* The response also contains a *token* that required to open a WebSocket communication. This token is not needed now.)

<details><summary>**Trigger via: `/evaluation`**</summary>
<p>

* This endpoint requires as path parameter the `projectName`, `stageName`, and `serviceName`: `/api/v1/project/{projectName}/stage/{stageName}/service/{serviceName}/evaluation`

* The payload looks as follows (go either with the `to` or `timeframe` parameter):

```json
{
    "start": "2020-09-28T07:00:00",     // required
    "end": "2020-09-28T07:05:00",       // cannot be used in combination with 'timeframe'
    "timeframe": "5m",                 // cannot be used in combination with 'to',
    "labels": {
      "buildId": "build-17",
      "owner": "JohnDoe",
      "testNo": "47-11"
    }
}
```

* Trigger a quality gate with a POST request on `/evaluation`:

```console
curl -X POST "${KEPTN_ENDPOINT}/v1/project/easyBooking/stage/quality_assurance/service/booking/evaluation" \
-H "accept: application/json; charset=utf-8" \
-H "x-token: ${KEPTN_API_TOKEN}" \
-H "Content-Type: application/json; charset=utf-8" \
-d "{ \"start\": \"2020-09-28T07:00:00\", \"timeframe\": \"5m\", \"labels\":{\"buildId\":\"build-17\",\"owner\":\"JohnDoe\",\"testNo\":\"47-11\"}}"
```

</p>
</details>

<details><summary>**Trigger via: `/event`**</summary>
<p>

* Specify a valid Keptn CloudEvent of type [sh.keptn.event.start-evaluation](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md#start-evaluation) and store it as JSON file, e.g.: `trigger_quality_gate.json`

```json
{
  "source": "keptn-cli",
  "specversion": "0.2",
  "id": "c5f749e6-cce7-43b8-943b-fd45e0b87e5a",
  "type": "sh.keptn.event.start-evaluation",
  "contenttype": "application/json",
  "data": {
    "deploymentstrategy": "",
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

* Trigger a quality gate with a POST request on `/event`:

```console
curl -X POST "${KEPTN_ENDPOINT}/v1/event" \
-H "accept: application/json; charset=utf-8" \
-H "x-token: ${KEPTN_API_TOKEN}" \
-H "Content-Type: application/json; charset=utf-8" \
-d @./trigger_quality_gate.json
```

</p>
</details>

### Fetch the evaluation result of a quality gate 

Be aware that calculating the evaluation result of a quality gate may take some time and is depending on the SLI-provider. Consequently, the result is not immediately available.

* To fetch a quality gate evaluation, the Keptn CLI provides the `/event`. This command requires the ID (`keptn-context`) and the event type which is `sh.keptn.events.evaluation-done`. 

```console
curl -X GET "${KEPTN_ENDPOINT}/v1/event?type=sh.keptn.events.evaluation-done&keptnContext={keptnContext}" \
-H "accept: application/json; charset=utf-8" \
-H "x-token: ${KEPTN_API_TOKEN}"
```

## Integrate into an existing pipeline

To integrate quality gates into an existing pipeline, it is recommended to use the API-based approach outlined [above](./#quality-gates-managed-by-keptn-api). As stated there the evaluation result is not immediately available. Hence, build your integration using a polling mechanism that polls the evaluation result every 10 seconds and terminates after, e.g., 10 retries. 

### Custom integrations

Find here custom integrations built by the Keptn community:

* [Azure DevOps Keptn Integration](https://github.com/keptn-sandbox/keptn-azure-devops-extension): *Integration of Keptn within your TFS/VSTS/AZDO build*  
