---
title: Triggers
description: Using triggers to kick off a sequence
weight: 160
keywords: [0.19.x-manage]
aliases:
---

By default, a sequence runs as a standalone section that runs and finishes.
You can manually trigger a sequence in any of the following ways,
usually for testing and demonstration purposes:

* From the Bridge UI
* Using the Keptn API
* Using the Keptn CLI

You can also use the `triggeredOn` property
in the the [shipyard](../../reference/files/shipyard)
to specify an event that triggers this sequence,
implicitly linking two sequences.

Each of these mechanismsis discussed below.

## Use triggeredOn in a sequence

Use the `triggeredOn` property in a project's [shipyard](../../reference/files/shipyard) file
to kick off a sequence in response to specific events.
Essentially, this links sequences together to form chains of sequences.
Specify a list of events to `triggeredOn`,
using event types that refer to the status of a sequence execution.
Their name follows the pattern:

* `[stage_name].[sequence_name].finished` 

**Note:** It is not necessary to specify the full qualified event name
which, in this case, would be `sh.keptn.event.[stage_name].[sequence_name].finished`.

A *match selector* can be added to an event to work as a filter on the `result` property of the event.
This enables you to filter based on sequence executions that *failed* or *passed*
as shown in the next example that filters on `failed`: 

```
sequences:
  - name: "rollback"
    triggeredOn:
      - event: "production.delivery.finished"
        selector:
          match:
            result: failed
```

*Initial shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"
```

**Use-case:** Add a process (additional sequence)
that covers a failed delivery in the production stage with a notification and rollback task. 

*Updated shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"

        - name: "rollback"
          triggeredOn:
            - event: "production.delivery.finished"
                selector:
                  match:
                    result: failed
          tasks:
            - name: "notification"
            - name: "rollback"
```

**Result:** If the *delivery* sequence fails because of a failed test task,
the event `sh.keptn.event.production.delivery.finished` with `result=failed` is sent out.
This triggers the *rollback* sequence, based on the configuration of the `triggeredOn` and selector.

## Trigger a sequence from the Keptn Bridge

The [Trigger a Keptn sequence](https://www.youtube.com/watch?v=S0eumPKuAJY) video
illustrates how to trigger a sequence using the Keptn Bridge
and discusses using `triggeredOn` in a `sequence` in your [shipyard](../../../0.19.x/reference/files/shipyard).

## Trigger a sequence with the CLI

Use the appropriate CLI command to trigger a sequence:

* `keptn trigger delivery` -- Trigger the delivery of a new artifact for a service in a project
* `keptn trigger evaluation` -- Trigger an evaluation of a test for a service in a project and stage
* `keptn trigger sequence` -- Trigger the execution of any sequence in a project

## Trigger a sequence with the POST / event API

A [shipyard.yaml](../../reference/files/shipyard) file can contain multiple sequences in multiple stages.
Use `POST /event` [Keptn API](../../reference/api/) to run a specific `sequence` with the following template:

```
{
    "data": {
      "project": "[project]",
      "service": "[service]",
      "stage": "[stage]"
    },
    "source": "[my-source]",
    "specversion": "1.0",
    "type": "sh.keptn.event.[stage].[sequence-name].triggered",
    "shkeptnspecversion": "0.2.3"
}
```

Replace the values between square brackets (`[]`) based on your configuration:

* `project`: your project name
* `service`: your service name
* `stage`: the stage in which your sequence is defined
* `sequence-name`: the sequence to trigger
* `my-source`: your source. More information is available
   in the [CloudEvents spec](https://github.com/cloudevents/spec/blob/v1.0/spec.md#source).

### Examples

In the following example, we define the `podtato-example` project that has the `helloservice` service.
The [shipyard.yaml](../../reference/files/shipyard) file for the project defines three sequences:

* `delivery` in the *hardening* stage;
* `evaluation-only` in the *hardening* stage;
* `delivery` in the *production* stage.

```yaml
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "podtato-example"
spec:
  stages:
    - name: "hardening"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "performance"
            - name: "evaluation"
            - name: "release"
        - name: "evaluation-only"
          tasks:
            - name: "evaluation"
              properties:
                teststrategy: "performance"
    - name: "production"
      sequences:
        - name: "delivery"
          triggeredOn:
            - event: "hardening.delivery.finished"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "release"
```

Post the following payload to the `POST /event` endpoint
to trigger the `delivery` sequence in the *hardening* stage: the following payload should be posted

```json
{
  "data": {
    "project": "podtato-example",
    "service": "helloservice",
    "stage": "hardening"
  },
  "source": "https://github.com/keptn/keptn/cli#configuration-change",
  "specversion": "1.0",
  "time": "2022-02-01T12:50:04.720Z",
  "type": "sh.keptn.event.hardening.delivery.triggered",
  "shkeptnspecversion": "0.2.3"
}
```

Post the following payload to the `POST /event` endpoint
to trigger the `delivery` sequence in the *production* stage:

```json
{
  "data": {
    "project": "podtato-example",
    "service": "helloservice",
    "stage": "production"
  },
  "source": "https://github.com/keptn/keptn/cli#configuration-change",
  "specversion": "1.0",
  "time": "2022-02-01T12:50:04.720Z",
  "type": "sh.keptn.event.production.delivery.triggered",
  "shkeptnspecversion": "0.2.3"
}
```

Post the following payload to the `POST /event` endpoint
to trigger the `evaluation-only` sequence in the *hardening* stage.
Since we want to trigger an evaluation, we need to provide addition properties that define the evaluation timeframe.
More information is provided in the [Quality Gates](../quality-gates) page.

```json
{
  "data": {
    "evaluation": {
      "end": "2022-02-01T09:36:11.311Z",
      "start": "2022-02-01T09:31:11.311Z",
      "timeframe": ""
    },
    "project": "podtato-example",
    "service": "helloservice",
    "stage": "hardening"
  },
  "source": "https://github.com/keptn/keptn/cli#configuration-change",
  "specversion": "1.0",
  "time": "2022-02-01T12:11:50.120Z",
  "type": "sh.keptn.event.hardening.evaluation-only.triggered",
  "shkeptnspecversion": "0.2.3"
}
```
