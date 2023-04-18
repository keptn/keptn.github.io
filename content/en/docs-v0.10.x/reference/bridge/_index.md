---
title: Keptn Bridge
description: The user interface of Keptn that presents all projects and services managed by Keptn. It is automatically installed with your Keptn deployment.
weight: 21
---

## Views in Keptn Bridge

The Keptn Bridge provides an easy way to browse all events that are sent within Keptn. When you access the Keptn Bridge, all projects will be shown on the start screen. When clicking on a project, the stages of this project, and all services are shown on the next view. An overview of those views is given below.

### Project view

* When you enter the Keptn Bridge and have not created a project yet, you will be guided to the instructions on how to setup a project and create a sample app.

    {{< popup_image
      link="./assets/project-dashboard-empty.png"
      caption="Keptn Bridge empty project view">}}

* If you have created projects, you will see the project listed including their stages.

    {{< popup_image
      link="./assets/project-dashboard.png"
      caption="Keptn Bridge project view">}}

### Environment view

* When you select a project, you see the environment overview of the entire Keptn context.
* This view allows to easily see the current deployed services on each stage and if there are any errors or pending approvals for one stage.
  By clicking on a stage you can see more information about the deployed services on the specific stage on the right side.

  {{< popup_image
  link="./assets/environment-view.png"
  caption="Keptn Bridge environment view">}}

### Services view

* One of the key steps for continuous delivery and remediation is the evaluation result based on SLO/SLIs. The services view gives you a clear overview
  over the result of this evaluation step.
* For each service the deployed artifacts are listed. Accordingly, for each artifact and executed stage, the evaluation result is displayed
  as *HeatMap* and *Chart*:

    {{< popup_image
        link="./assets/services-view-heatmap.png"
        caption="Evaluation Heatmap"
        width="50%">}}

    {{< popup_image
        link="./assets/services-view-chart.png"
        caption="Evaluation Chart"
        width="50%">}}

* To customize the chart, labels can be used. If the `sh.keptn.event.evaluation.triggered` event has the label `buildId` attached, the Keptn Bridge reads the value
  of this label and uses it as label for the x-axis in the *Chart*. If the value of the label is an URL, the label will be displayed as a link, 
  so you can easily link back to the Dynatrace Dashboard for example. 

    {{< popup_image
        link="./assets/buildId.png"
        caption="Use `buildId` as label"
        width="50%">}}
  
* If you are using relative SLO values that are based on past evaluations *Ignore for comparison* could come in handy. With this you can exclude an evaluation when 
  determining the relative values. To do so click on the desired evaluation in the heatmap and click the button *Ignore for comparison*. The evaluation is then
  removed from the heatmap and the evaluation calculation.

    {{< popup_image
        link="./assets/services-view-invalidate-evaluation.png"
        caption="Ignore evaluation for comparison"
        width="50%">}}
  
* For your convenience the SLOs that the evaluation was executed against, as well as the event payload, can be viewed.

    {{< popup_image
        link="./assets/services-view-slo.png"
        caption="Evaluation SLOs"
        width="50%">}}

    {{< popup_image
        link="./assets/services-view-payload.png"
        caption="Event Payload"
        width="50%">}}
        
* If you configured some remediations and one of them is currently running, the affected service, deployment and stage is indicated. You can also see, which type of remediation is
  being executed and view its configuration and sequence execution.

    {{< popup_image
        link="./assets/services-view-remediations.png"
        caption="Open remediations"
        width="50%">}}

    {{< popup_image
        link="./assets/services-view-remediation-config.png"
        caption="Remediation configuration"
        width="50%">}}

### Evaluation board

* Next to the evaluation comparison as a heatmap or chart in the *Services* view, we provide a link to the *Evaluation Board*, which displays only 
  the evaluation comparison on this stage. 
  
    {{< popup_image
    link="./assets/bridge_evaluationboard.png"
    caption="Keptn Bridge Evaluation Board">}}
  
### Sequences view

* The sequences for the selected project are shown on this screen. It has a lot of filter possibilities, that can either be selected
  in the left pane or be applied by using the search bar.
* When you select a sequence, the related tasks are shown for each stage. The stages can be selected by clicking onto the stage name in
  the timeline, or the badge of the sequence list item.
* You can also expand each task to show the related events.

  {{< popup_image
  link="./assets/sequences-screen-filter.png"
  caption="Keptn Bridge Sequences View">}}
  
### Uniform view

The uniform view gives you an overview over all integrations installed within your Keptn installation. 
The data is fetched from your Kubernetes cluster and shows useful information like
* Unread/New error events
* Deployment version of the service
* The cluster or host where it is running
* The Kubernetes namespace
* The location within Keptn
* The Cloud Events the services are subscribed to


{{< popup_image
link="./assets/uniform-view.png"
caption="Keptn Bridge Uniform View">}}

You can view the related subscriptions, events on error level, and sequence failures by selecting an integration. It is also possible to directly configure the subscriptions to listen to specific events.
If there are new error events since the last time the integration was viewed, a red indicator shows up for this integration. When a sequence in this particular scope failed, then there is
a link provided that takes you directly to the failed task in the sequence. 'n/a' in this regard means that the error is not related to any sequence execution. 

{{< popup_image
link="./assets/uniform-view-logs.png"
caption="Integrated Service Error Events">}}

#### Create/Edit subscriptions view
By clicking on the edit icon next to the subscription detail or the "*Add sequence*"-button, you are redirected to the subscription view. In this view, you can configure the task, stage and service for the subscription. The values used for the configuration are defined in the shipyard file. It is also possible to define whether the subscription is active for all projects or just the currently selected one.

{{< popup_image
link="./assets/uniform-view-create-subscription.png"
caption="Create/Edit Subscriptions">}}

Once you have selected an event and configured your filters, you may inspect an example event payload by clicking on the "Show example payload"-Button. This will show you the payload of latest event in your environment, depending on your configuration.

{{< popup_image
link="./assets/uniform-view-show-payload.png"
caption="Show example payload">}}


#### Secrets view

Secrets are used to store sensitive data like credentials or URIs for integrations. This view
gives you an overview of all secrets that have been created by the *secret-service*.

{{< popup_image
link="./assets/secrets-view.png"
caption="List Secrets View">}}

By clicking on the delete button, you can delete secrets after a confirmation.

If you want to add a secret, just click on the "*Add secret*"-Button. It will show you a form
where you can set the secret name and provide key-value-pairs that should be stored with that secret
name.

{{< popup_image
link="./assets/secrets-view-create-secret.png"
caption="Create Secret View">}}
  
### Integrations
You can find links to for different integration possibilities here. This makes it easier to start using Keptn. Integrate either with Keptn CLI / API or use our custom 
integrations for different CI providers.

Please note that the page contains dynamic content that is loaded from https://get.keptn.sh/integrations.html. By clicking the button the data is requested,
and additional data is gathered from the client. For more information about this see https://keptn.sh/docs/0.10.x/reference/load_information/.

### Settings

#### Project settings
In the settings view the project settings can be edited. 
To get more information about how to manage your projects with the settings, visit [Manage Projects](https://keptn.sh/docs/0.10.x/reference/bridge/manage_projects).

{{< popup_image
link="./assets/project-settings.png"
caption="Keptn Bridge Project Settings View">}}


#### Service settings
In this view, services can be created, updated and deleted.
To get more information about how services can be managed in your settings, visit [Manage Services](https://keptn.sh/docs/0.10.x/reference/bridge/manage_services).

{{< popup_image
link="./assets/service-settings.png"
caption="Keptn Bridge Service Settings View">}}


## Keptn Bridge features

### Approvals

If you have a [manual approval strategy](https://keptn.sh/docs/0.10.x/continuous_delivery/multi_stage/#approval) defined in your shipyard.yaml file, approvals can be handled with the Keptn Bridge.
At sequence execution, if the approval task is reached, a panel is shown in all relevant screens:

In the environment view a pending approval can be recognized by the blue service out-of-sync icon at the according stage.
Examining the stage allows to directly approve or decline the sequence in the stage overview.

{{< popup_image
link="./assets/approval-environment.png"
caption="Approval in Environments">}}

In the services view, a pending approval can be recognized by the blue border of the stage. By examining the stage, approval can also be directly triggered there. 

{{< popup_image
link="./assets/approval-service.png"
caption="Approval in Services">}}

In sequences the approval is listed within the tasks in the sequence. Approve or decline the approval by opening the expand pane.

{{< popup_image
link="./assets/approval-sequence.png"
caption="Approval in Sequences">}}

### Manage projects

See the documentation for [managing projects](https://keptn.sh/docs/0.10.x/reference/bridge/manage_projects) to see which features for creating and updating projects the Bridge provides.

## Early access version of Keptn Bridge

Right now there is no early access version of Keptn Bridge available.

<!-- You can upgrade to the latest version (0.10.0) by executing the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:0.10.0 --record
``

There is an early access version of Keptn Bridge available (compatible with Keptn 0.10.0):

  {{< popup_image
  link="./assets/bridge_eap.png"
  caption="Keptn Bridge EAP">}}

* To install it, you have to update the Docker images of *Keptn Bridge*, *configuration-service* and the *mongodb-datastore* deployment by executing the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:20200402.1046 --record
```

* To restore the old version of bridge, configuration-service and mongodb-datastore (as delivered with Keptn 0.10.0), you can use the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:0.10.0 --record
```
-->

If you have any questions or feedback regarding Keptn Bridge, please contact us through our [Keptn Community Channels](https://github.com/keptn/community).

## Supported Browsers

You can access Keptn Bridge using the following browsers.

| Browser         | Versions                 |
|-----------------|--------------------------|
| Microsoft Edge  | Latest version (desktop) |
| Mozilla Firefox | Latest version (desktop) |
| Google Chrome   | Latest version (desktop) |
| Safari          | 11+ (OS X)               |

Keptn Bridge is not designed to work on mobile devices. 
