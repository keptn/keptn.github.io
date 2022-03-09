---
title: Manage Sequences
description: Manage sequences from the Bridge
weight: 40
keywords: [0.14.x-bridge]
---

The sequence view shows all executed sequences for the selected project.

The list on the left side gives a brief overview of all sequences and can be filtered. By clicking one of the sequences, the detail for it opens.
This detailed view shows every executed task for the selected sequence in a specific stage. It includes information like the related events, the result, and the payload.

For evaluation sequences, the Bridge will also provide a link to the evaluation board.<br/>
For delivery sequences, the Bridge will provide a link to the deployed artifact.

When opening the detail, the default selection is the last executed stage. Select a different one by clicking on the stage name in the timeline.

{{< popup_image
link="./assets/running-sequence.png"
caption="Sequences">}}

## Filtering

Filtering provides a way of getting a better overview of the sequences. Filter by using the search bar or by selecting the items from the filter list.

Filters can apply to:

* Service - all services created for the project
* Stage - all stages defined in the shipyard file of the project
* Sequence - all sequences defined in the shipyard file of the project
* Status - sequences can have the status active, succeeded, or failed. Active state includes all sequences that have not been completed with a finished event yet.

## Pausing and resuming sequences
Running sequences have the option to be paused. The buttons' location to trigger pausing is on the top right of a list entry or the detail view. Clicking the button will halt the running sequence until it is resumed.
Please note: Any running task is going to finish before the service pauses the sequence. That means that the Bridge may show a paused state, but the task list is still running.

{{< popup_image
link="./assets/paused-sequence.png"
caption="Paused sequence">}}

## Aborting sequences
Running and paused sequences have the option to be aborted. The buttons' location to trigger abortion is on the top right of a list entry or the detail view. Clicking the button will stop the running sequence entirely. After cancelation, it is not possible to restart it in any way. Please be certain before aborting it.
Please note: Any running task is going to finish before the service aborts the sequence. That means that the sequence may be still in progress directly after aborting. It may take some minutes until the sequence has a completed state. An example can be seen below. In this case the sequence is marked as succeeded, but some tasks are still in progress.

{{< popup_image
link="./assets/abort-dialog.png"
caption="Popup before sequence abortion">}}

{{< popup_image
link="./assets/aborted-running-sequence.png"
caption="Aborted sequence with running tasks">}}
