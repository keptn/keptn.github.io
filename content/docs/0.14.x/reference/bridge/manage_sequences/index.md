---
title: Manage Sequences
description: Manage sequences from the Bridge
weight: 40
keywords: [0.14.x-bridge]
---

## Trigger new sequences

To trigger new sequences, head to the environment view. There you can find the button "Trigger a new sequence". This button can also be found on the sequences view and redirects you to the the environment view.

{{< popup_image
link="./assets/trigger-01-environment-screen.png"
caption="Sequences">}}

{{< popup_image
link="./assets/trigger-02-sequence-screen.png"
caption="Sequences">}}

For sequences you have the possibility to choose from 3 sequence types:
* Delivery - This will trigger the `delivery` sequence as defined in the [shipyard](../../../manage/shipyard/).
* Evaluation - This will trigger the Keptn default evaluation sequence.
* Custom - Trigger any other sequence defined in the shipyard, except the delivery and evaluation sequences.

{{< popup_image
link="./assets/trigger-03-select-sequence.png"
caption="Sequences">}}

After you have selected the desired sequence type, service, and stage click on "Next" to define the details of your sequence.

### Trigger a delivery

Mandatory fields:
* Image - The image name that is going to be deployed.
* Tag - The version tag of the image.

Optional fields:
* Labels - Additional labels that will be used in Bridge for displaying additional info.
* Values - Values in JSON format, for the new artifact to be delivered. They can be used for the configuation of helm-service.

{{< popup_image
link="./assets/trigger-04-trigger-delivery.png"
caption="Sequences">}}

### Trigger an evaluation

For triggering an evaluation, you can choose beween two variants to select the evaluation timeframe:
* Timeframe
* Start / end date and time

#### **Timeframe**
For the timeframe, there are no mandatory fields. If nothing is given as timeframe it defaults to 5 minutes. If nothing is given for the start date, it defaults to the current time.

Fields:
* Timeframe - Takes hours, minutes, seconds, milliseconds and microseconds. Defines the timeframe from the given start date and time (or current date-time if not given) where an evaluation is performed. Defaults to 5 minutes and has a minimum duration of 1 minute.
* Start at - Defines the start date and time from when the evaluation is performed.
* Labels - Additional labels that will be used in Bridge for displaying additional info.

{{< popup_image
link="./assets/trigger-05-trigger-evaluation-timeframe"
caption="Sequences">}}

#### **Start / end date**
Please mind, that an evaluation is performed in the past. That means that the start date has to be **after** the end date.

Mandatory fields:
* Start at - Defines the start date and time from when the evaluation is performed. Has to be **after** the end date.
* End at - Defines the end date and time until when the evaluation is performed. Has to be **before** the start date.

Optional fields:
* Labels - Additional labels that will be used in Bridge for displaying additional info.

{{< popup_image
link="./assets/trigger-06-trigger-evaluation-start-end.png"
caption="Sequences">}}

### Trigger a custom sequence
Custom sequences are automatically fetched from the [shipyard](../../../manage/shipyard/). All sequences that are defined in this file, except delivery and evaluation, are then selectable as sequences in the sequence dropdown.

Mandatory fields:
* Sequence - The custom sequence to be triggered.

Optional fields:
* Labels - Additional labels that will be used in Bridge for displaying additional info.

{{< popup_image
link="./assets/trigger-07-trigger-custom.png"
caption="Sequences">}}

## Sequence view

The sequence view shows all executed sequences for the selected project.

The list on the left side gives a brief overview of all sequences and can be filtered. By clicking one of the sequences, the detail for it opens.
This detailed view shows every executed task for the selected sequence in a specific stage. It includes information like the related events, the result, and the payload.

For evaluation sequences, the Bridge will also provide a link to the evaluation board.<br/>
For delivery sequences, the Bridge will provide a link to the deployed artifact.

When opening the detail, the default selection is the last executed stage. Select a different one by clicking on the stage name in the timeline.

{{< popup_image
link="./assets/running-sequence.png"
caption="Sequences">}}

### Filtering

Filtering provides a way of getting a better overview of the sequences. Filter by using the search bar or by selecting the items from the filter list.

Filters can apply to:

* Service - all services created for the project
* Stage - all stages defined in the shipyard file of the project
* Sequence - all sequences defined in the shipyard file of the project
* Status - sequences can have the status active, succeeded, or failed. Active state includes all sequences that have not been completed with a finished event yet.

### Pausing and resuming sequences
Running sequences have the option to be paused. The buttons' location to trigger pausing is on the top right of a list entry or the detail view. Clicking the button will halt the running sequence until it is resumed.
Please note: Any running task is going to finish before the service pauses the sequence. That means that the Bridge may show a paused state, but the task list is still running.

{{< popup_image
link="./assets/paused-sequence.png"
caption="Paused sequence">}}

### Aborting sequences
Running and paused sequences have the option to be aborted. The buttons' location to trigger abortion is on the top right of a list entry or the detail view. Clicking the button will stop the running sequence entirely. After cancelation, it is not possible to restart it in any way. Please be certain before aborting it.
Please note: Any running task is going to finish before the service aborts the sequence. That means that the sequence may be still in progress directly after aborting. It may take some minutes until the sequence has a completed state. An example can be seen below. In this case the sequence is marked as succeeded, but some tasks are still in progress.

{{< popup_image
link="./assets/abort-dialog.png"
caption="Popup before sequence abortion">}}

{{< popup_image
link="./assets/aborted-running-sequence.png"
caption="Aborted sequence with running tasks">}}
