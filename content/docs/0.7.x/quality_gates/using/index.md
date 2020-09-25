---
title: Working with Quality Gates
description: Working with Quality Gates using Keptn CLI/API
weight: 7
keywords: [0.7.x-quality_gates]
---

## Quality Gates managed by Keptn CLI

### Trigger a quality gate

To trigger a quality gate for a service in the stage of a specific project, the Keptn CLI provides two commands: 

1. [keptn send event start-evaluation](../../reference/cli/commands/keptn_send_event_start-evaluation/)
1. [keptn send event](../../reference/cli/commands/keptn_send_event/)

Both commands return an ID (`keptn-context`) that is required to retrieve the evaluation result. 

**Trigger via: `keptn send event start-evaluation`**

* This commands allows specifying the timeframe of the evaluation using the `--start`, `--end`, or `timeframe` flags. 

* To trigger, for example, a quality gate evaluation of `5` minutes starting at `2020-12-31T11:59:59`, use the command as follows:

```console
keptn send event start-evaluation --project=sockshop --stage=hardening --service=carts --start=2020-12-31T11:59:59 --timeframe=5m
```

**Trigger via: `keptn send event`**

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

* Trigger a quality gate by sending the CloudEvent to Keptn:

```console
keptn send event --file=trigger_quality_gate.json 
```

### Fetch the evaluation result of a quality gate

* To fetch a quality gate evaluation, the Keptn CLI provides the [keptn get event evaluation-done](../../reference/cli/commands/keptn_get_event_evaluation-done/) command. This command requires the ID (`--keptn-context`) returned by the `send event start-evaluation` or `send event` command.

```console
keptn get event evaluation-done --keptn-context=1234-5678-90ab-cdef
```

## Quality Gates managed by Keptn API

To work with the Keptn API, first get the API token from the [Keptn Bridge]() and follow the Keptn API link to the Swagger-UI. 

### Trigger a quality gate

To trigger a quality gate for a service in the stage of a specific project, the Keptn API provides two endpoints: 

* `/evaluation`
* `/event`

For the sake of convenience, store the Keptn API and API token in an enviornment variable explained [here](../../operate/install/#authenticate-keptn-cli).

**Trigger via: `/evaluation`**

--> Add 

**Trigger via: `/event`**

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
curl -X POST  ${KEPTN_ENDPOINT}/v1/event \
-H "accept: application/json; charset=utf-8" \
-H "Authorization: Api-Token ${KEPTN_API_TOKEN}" \
-H "Content-Type: application/json; charset=utf-8" \
-d @./trigger_quality_gate.json
```

### Fetch the evaluation result of a quality gate 


## Integrate into an existing pipeline



