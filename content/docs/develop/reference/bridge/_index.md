---
title: Keptn Bridge
description: Explains how the access the Keptn Bridge.
weight: 21
keywords: [bridge]
---

The Keptn Bridge is the user interface of Keptn and presents all projects and services managed by Keptn. It is automatically installed with your Keptn deployment.

## Views in Keptn Bridge

The Keptn Bridge provides an easy way to browse all events that are sent within Keptn. When you access the Keptn Bridge, all projects will be shown on the start screen. When clicking on a project, the stages of this project and all onboarded services are shown on the next view.

### Project view

When you enter the Keptn Bridge, at first you see an overview of all projects that are created and their stages. If no projects exist yet, you will be guided to the instructions how to setup a project and onboard a sample app.

{{< popup_image
  link="./assets/bridge_empty.png"
  caption="Keptn Bridge empty project view">}}

{{< popup_image
  link="./assets/bridge_projectoverview.png"
  caption="Keptn Bridge project view">}}  

### Services

When you select a project, you see the deployed services and the event stream that belongs to this service is listed when you expand the service.

The event stream on the left side is only the entry point (e.g. new deployment, problem). By clicking on an event, you will see more information on the executed steps in the same Keptn context on the right side.
As can be seen in the screenshot below, the entry point around 4:53 pm has been selected and all events belonging to this entry point are displayed on the right side.

  {{< popup_image
  link="./assets/bridge_services.png"
  caption="Keptn Bridge services view with event stream">}}

### Environment

Next to the services screen, the Bridge also provides an environment screen. This view allows to easily see the current deployed services on each stage and if there are any errors or pending approvals for one stage.
By clicking on a stage you can see more information about the deployed services on the specific stage on the right side.

  {{< popup_image
  link="./assets/bridge_environment.png"
  caption="Keptn Bridge environment view">}}
  
### Evaluation Board

Next to the evaluation comparison as a heatmap or chart in the "Services" view, we provide a link to the Evaluation Board, which shows only the evaluation comparison on this stage. 
  
  {{< popup_image
  link="./assets/bridge_evaluationboard.png"
  caption="Keptn Bridge Evaluation Board">}}

## Early Access Version of Keptn Bridge

Right now there is no early access version of Keptn Bridge available. You can upgrade to the latest version (0.6.2) by executing the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:0.6.2 --record
kubectl -n keptn set image deployment/configuration-service bridge=keptn/configuration-service:0.6.2 --record
kubectl -n keptn-datastore set image deployment/mongodb-datastore mongodb-datastore=keptn/mongodb-datastore:0.6.2 --record
```

<!--
There is an early access version of Keptn Bridge available (compatible with Keptn 0.6.2):

  {{< popup_image
  link="./assets/bridge_eap.png"
  caption="Keptn Bridge EAP">}}

* To install it, you have to update the Docker images of *Keptn Bridge*, *configuration-service* and the *mongodb-datastore* deployment by executing the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:20200402.1046 --record
```


* To restore the old version of bridge, configuration-service and mongodb-datastore (as delivered with Keptn 0.6.2), you can use the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:0.6.2 --record
```

-->

If you have any questions or feedback regarding Keptn Bridge, please contact us through our [Keptn Community Channels](https://github.com/keptn/community)!
