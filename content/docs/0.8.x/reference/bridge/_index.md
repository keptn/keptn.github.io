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
      link="./assets/bridge_empty.png"
      caption="Keptn Bridge empty project view">}}

* If you have created projects, you will see the project listed including their stages.

    {{< popup_image
      link="./assets/bridge_projectoverview.png"
      caption="Keptn Bridge project view">}}  

### Services view

* When you select a project, you see the services that are onboarded to this project.

* The event stream that belongs to a service is shown when you expand the service. The event stream on the left side (i.e., root events like new deployment, or problem event) is only the entry point. By clicking on an event, you will see more information on the executed steps in the same Keptn context on the right side.

* As shown in the screenshot below, the entry point around 16:53 has been selected and all events belonging to this entry point are displayed on the right side.

    {{< popup_image
    link="./assets/bridge_services.png"
    caption="Keptn Bridge services view with event stream">}}

* The event stream on the right side shows information for certain steps. A key step in continous delivery and remediations is the evaluation of the deployment based on SLO/SLIs. The result of this evaluation step is displayed in a *Chart* and *HeatMap*:

    {{< popup_image
    link="./assets/chart_heatmap.png"
    caption="Evaluation result">}}

* If the `sh.keptn.events.evaluation-done` event has the label `buildId` attached, the Keptn Bridge reads the value of this label and uses it as label for the x-axis in the *Chart*. If the value of the label is an URL, the label will be displayed as a link, so you can easily link back to the Dynatrace Dashboard for example. 

    {{< popup_image
        link="./assets/buildId.png"
        caption="Use `buildId` as label"
        width="50%">}}

### Environment view

* Next to the services view, the Bridge also provides an environment view. 

* This view allows to easily see the current deployed services on each stage and if there are any errors or pending approvals for one stage.
By clicking on a stage you can see more information about the deployed services on the specific stage on the right side.

    {{< popup_image
    link="./assets/bridge_environment.png"
    caption="Keptn Bridge environment view">}}
  
### Evaluation board

* Next to the evaluation comparison as a heatmap or chart in the *Services* view, we provide a link to the *Evaluation Board*, which displays only the evaluation comparison on this stage. 
  
    {{< popup_image
    link="./assets/bridge_evaluationboard.png"
    caption="Keptn Bridge Evaluation Board">}}

## Early Access Version of Keptn Bridge

Right now there is no early access version of Keptn Bridge available. 

<!-- You can upgrade to the latest version (0.7.3) by executing the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:0.7.3 --record
``

There is an early access version of Keptn Bridge available (compatible with Keptn 0.7.3):

  {{< popup_image
  link="./assets/bridge_eap.png"
  caption="Keptn Bridge EAP">}}

* To install it, you have to update the Docker images of *Keptn Bridge*, *configuration-service* and the *mongodb-datastore* deployment by executing the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:20200402.1046 --record
```

* To restore the old version of bridge, configuration-service and mongodb-datastore (as delivered with Keptn 0.7.3), you can use the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:0.7.3 --record
```
-->

If you have any questions or feedback regarding Keptn Bridge, please contact us through our [Keptn Community Channels](https://github.com/keptn/community).
