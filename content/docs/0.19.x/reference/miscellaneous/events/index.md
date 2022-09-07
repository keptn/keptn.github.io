---
title: Keptn CloudEvents
description: Event types supported by Keptn core
weight: 135
---

The Keptn CloudEvents specification defines the event types and formats
supported by Keptn core
as well as the payload structure associated with each event.
Keptn generates CloudEvents based on sequence and task names
as defined in the [shipyard](../../files/shipyard).

Integrations and services that are configured in your Keptn cluster
to integrate other tools may support additional event types
and users can add their own  event types.

Keptn is driven by CloudEvents because they are an industry standard
(see [CloudEvents standard](https://cloudevents.io/))
and are vendor neutral.

## Specification

[Keptn CloudEvents specification](https://github.com/keptn/spec/blob/master/cloudevents.md)

## Usage notes

By default, the Keptn project defines some activities
(such as `deployment`, `evaluation`, and `test`)
that are commonly used by DevOps practitioners and Site Reliability Engineers (SREs).
Users can choose other task names;
these create CloudEvents with names such as

````
sh.keptn.event.<taskname>.triggered
sh.keptn.event.<taskname>.finished
````

Use the `triggeredOn` property in a shipyard sequence
to execute that sequence when the specified event is received.
Use the `match` selector to define a filter on the `result` property of the event.
For example, you can specify that an action should execute
only if the event property is `failed` or only when it is `success`.

See [Using triggeredOn in a sequence](../../../define/triggers/#use-triggeredon-in-a-sequence)
for more details.

## Differences between versions

Current versions of the Keptn CloudEvents specification conform to v.1.0.2
of the CloudEvents standard.

## See also

* [CloudEvents standard](https://cloudevents.io/),
a vendor-neutral specification for defining the format of event data.
* [Keptn CloudEvents specification](https://github.com/keptn/spec/blob/master/cloudevents.md)
that defines the format of the event types recognized by Keptn core.

* [shipyard](../../files/shipyard) reference
* [distributor](../distributor) reference

