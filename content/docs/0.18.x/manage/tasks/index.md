---
title: Manage tasks and sequences
description: Tips for managing tasks and sequences
weight: 35
keywords: [0.18.x-manage]
aliases:
---

A Keptn project's [shipyard](../../reference/files/shipyard)
defines `sequences` that `execute` `tasks`.
When the task receives the `action.finished` event,
the task is finished and subsequent tasks can execute.

## Stop a task

Keptn does not provide a facility to actually abort a task.
The [keptn abort](../../reference/cli/commands/keptn_abort) command
causes the shipyard controller to stop processing,
meaning it does not continue processing
and so prevents the next task from being triggered,
but it does not actually abort the task.

An executing task is stopped only when it receives an `action.finished`
event, usually with a `data.result` value
so that the shipyard controller knows what to do next..
So, if you need to stop a task, you can send a "fake" `action.finished` event
using the [Keptn API](../../reference/api).
You can do this from the [Keptn Bridge](../../bridge):

* Click the PC icon in the action task that is currently spinning and copy the event content.
* Navigate to the API page and click on the user icon on the top-right
* Click on the Keptn API link.
  * Open the POST /event api and click on "try it out".
  * Paste the event body that you copied before. Here,
  * Set (or add if missing) the value of `data.status` to `errored`
  and the value of `data.result` to `fail`.
  * Change the value of `type` to have the `finished` suffix instead of `started`.
* Authenticate the API via the API token
as discussed in [Access the API](../../reference/api/#access-the-keptn-api) and you can fire it.

This sends a `finished` event for your action, marking the task as failed.
