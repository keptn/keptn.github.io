---
title: Keptn Bridge
description: The user interface of Keptn that presents all projects and services managed by Keptn. It is automatically installed with your Keptn deployment.
weight: 21
---

## Views in Keptn Bridge

The Keptn Bridge provides an easy way to browse all events that are sent within Keptn. When you access the Keptn Bridge, all projects will be shown on the start screen. When clicking on a project, the stages of this project, and all onboarded services are shown on the next view. An overview of those views is given below.

### Project view

* When you enter the Keptn Bridge and have not created a project yet, you will be guided to the instructions on how to setup a project and onboard a sample app.

    {{< popup_image
      link="./assets/bridge-empty.png"
      caption="Keptn Bridge empty project view">}}

* If you have created projects, you will see the project listed including their stages.

    {{< popup_image
      link="./assets/project-view.png"
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
* Deployment version of the service
* The cluster or host where it is running
* The Kubernetes namespace
* The location within Keptn
* The Cloud Events the services are subscribed to


{{< popup_image
link="./assets/uniform-view.png"
caption="Keptn Bridge Uniform View">}}

By selecting one integration, logs on error level as well as sequence failures can be viewed. When a sequence in this particular scope failed, then there is
a link provided that takes you directly to the failed task in the sequence. 'n/a' in this regard means that the error is not related to any sequence execution. 

{{< popup_image
link="./assets/uniform-view-logs.png"
caption="Integrated Service Error Logs">}}

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
and additional data is gathered from the client. For more information about this see https://keptn.sh/docs/0.8.x/reference/load_information/.

### Settings

In the settings view the project settings can be edited.

{{< popup_image
link="./assets/settings.png"
caption="Keptn Bridge Settings View">}}

### Git upstream url

The git upstream url can be set by entering the Git repository url, Git username and the Git token. This also can be achieved by
using the [keptn update project](https://keptn.sh/docs/0.8.x/reference/cli/commands/keptn_update_project/) command.
More information about how to set up your git provider can be found in the [Git-based upstream documentation](https://keptn.sh/docs/0.8.x/manage/git_upstream/).

## Keptn Bridge features

### Approvals

If you have a [manual approval strategy](https://keptn.sh/docs/0.8.x/continuous_delivery/multi_stage/#approval) defined in your shipyard.yaml file, approvals can be handled with the Keptn Bridge.
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

## Early access version of Keptn Bridge

Right now there is no early access version of Keptn Bridge available.

<!-- You can upgrade to the latest version (0.8.6) by executing the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:0.8.6 --record
``

There is an early access version of Keptn Bridge available (compatible with Keptn 0.8.6):

  {{< popup_image
  link="./assets/bridge_eap.png"
  caption="Keptn Bridge EAP">}}

* To install it, you have to update the Docker images of *Keptn Bridge*, *configuration-service* and the *mongodb-datastore* deployment by executing the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:20200402.1046 --record
```

* To restore the old version of bridge, configuration-service and mongodb-datastore (as delivered with Keptn 0.8.6), you can use the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:0.8.6 --record
```
-->

If you have any questions or feedback regarding Keptn Bridge, please contact us through our [Keptn Community Channels](https://github.com/keptn/community).
