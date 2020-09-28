---
title: Working with Quality Gates
description: Working with Quality Gates using Keptn CLI/API
weight: 7
keywords: [0.7.x-quality_gates]
---




## Quality Gates managed by Keptn CLI

* To work with the Keptn CLI, make sure your Keptn CLI is authenticated against the right Keptn; find the instructions [here](../../operate/install/#authenticate-keptn-cli) or use [Keptn Bridge]() to get the credentials for the [keptn auth](../../reference/cli/commands/keptn_auth/) command.

* To verify the CLI connection to your Keptn, execute [keptn status](../../reference/cli/commands/keptn_status/).

### Trigger a quality gate

To trigger a quality gate for a service in the stage of a specific project, the Keptn CLI provides two commands: 

1. [keptn send event start-evaluation](../../reference/cli/commands/keptn_send_event_start-evaluation/)
1. [keptn send event](../../reference/cli/commands/keptn_send_event/)

Both commands return an ID (`keptn-context`) that is required to retrieve the evaluation result. 

<details><summary>**Trigger via: `keptn send event start-evaluation`**</summary>
<p>

* This command allows specifying the timeframe of the evaluation using the `--start`, `--end`, or `timeframe` flags. 

* To trigger, for example, a quality gate evaluation of `5` minutes starting at `2020-12-31T11:59:59`, use the command as follows:

```console
keptn send event start-evaluation --project=sockshop --stage=hardening --service=carts --start=2020-12-31T11:59:59 --timeframe=5m
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
    "image": "docker.io/keptnexamples/carts",
    "tag": "0.11.2",
    "start": "2020-09-01T08:31:06Z",
    "end": "2020-09-01T08:36:06Z",
    "labels": {
      "buildId": "build-17",
      "owner": "JohnDoe",
      "testNo": "47-11"
    },
    "project": "sockshop",
    "service": "carts",
    "stage": "hardening",
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

* To fetch a quality gate evaluation, the Keptn CLI provides the [keptn get event evaluation-done](../../reference/cli/commands/keptn_get_event_evaluation-done/) command. This command requires the ID (`--keptn-context`) returned by the `send event start-evaluation` or `send event` command.

```console
keptn get event evaluation-done --keptn-context=1234-5678-90ab-cdef
```

## Quality Gates managed by Keptn API

* To work with the Keptn API, get the API token from the [Keptn Bridge]() and follow the Keptn API link to the Swagger-UI. 

* If you want to interact with the Keptn APV via cURL, store the Keptn API and API token in an environment variable explained [here](../../operate/install/#authenticate-keptn-cli).

### Trigger a quality gate

To trigger a quality gate for a service in the stage of a specific project, the Keptn API provides two endpoints: 

* `/evaluation`
* `/event`

Both endpoints return an ID (`keptn-context`) that is required to retrieve the evaluation result. (*Note:* The response also contains a `token` required for opening a WebSocket communication.)

<details><summary>**Trigger via: `/evaluation`**</summary>
<p>

* This endpoint requires as path parameter the `projectName`, `stageName`, and `serviceName`: `/api/v1/project/{projectName}/stage/{stageName}/service/{serviceName}/evaluation`

* The payload looks as follows (go either with the `to` or `timeframe` parameter):

```json
{
    "from": "2020-09-28T07:00:00",     // required
    "to": "2020-09-28T07:05:00",       // cannot be used in combination with 'timeframe'
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
curl -X POST "${KEPTN_ENDPOINT}/v1/project/{PROJECT}/stage/{STAGE}/service/{SERVICE}/evaluation" \
-H "accept: application/json; charset=utf-8" \
-H "x-token: ${KEPTN_API_TOKEN}" \
-H "Content-Type: application/json; charset=utf-8" \
-d "{ \"from\": \"2020-09-28T07:00:00\", \"timeframe\": \"5m\", \"labels\":{\"buildId\":\"build-17\",\"owner\":\"JohnDoe\",\"testNo\":\"47-11\"}}"
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
    "image": "docker.io/keptnexamples/carts",
    "tag": "0.11.2",
    "start": "2020-09-01T08:31:06Z",
    "end": "2020-09-01T08:36:06Z",
    "labels": {
      "buildId": "build-17",
      "owner": "JohnDoe",
      "number": "1234"
    },
    "project": "sockshop",
    "service": "carts",
    "stage": "hardening",
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

* To fetch a quality gate evaluation, the Keptn CLI provides the `/event`. This command requires the ID (`keptn-context`) and the event type which is `sh.keptn.events.evaluation-done`. 

```console
curl -X GET "${KEPTN_ENDPOINT}/v1/event?type=sh.keptn.events.evaluation-done&keptnContext={keptnContext}" \
-H "accept: application/json; charset=utf-8" \
-H "x-token: ${KEPTN_API_TOKEN}"
```
<!-- 
## Integrate into an existing pipeline
-->
