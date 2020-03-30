---
title: Keptn's Bridge
description: Explains how the access the Keptn's Bridge.
weight: 21
keywords: [bridge]
---

The Keptn's Bridge lets you browse the Keptn's log. It is automatically installed with your Keptn installation.

## Usage

The Keptn's Bridge is not publicly accessible, but can be retrieved by enabling port-forwarding from your local machine to the Keptn's Bridge:

```console
kubectl port-forward svc/bridge -n keptn 9000:8080
```

It is then available on: http://localhost:9000

**Important Note**: The Keptn's Bridge exposes sensitive information. We do not recommend exposing it publicly via LoadBalancer, NodePort, VirtualServices or alike.

## Project view

The Keptn's Bridge provides an easy way to browse all events that are sent within Keptn. When you access the Keptn's Bridge, all projects will be shown on the start screen. When clicking on a project, the stages of this project and all onboarded services are shown on the next view.

  {{< popup_image
  link="./assets/bridge_empty.png"
  caption="Keptn's Bridge project view">}}

When selecting one service, all events that belong to this service are listed on the right side. Please note that this list only represents the start of a deployment (or problem) of a new artifact. More information on the executed steps can be revealed when you click on one event.

## Event stream

When selecting an event, the Keptn's Bridge displays all other events that are in the same Keptn context and belong to the selected entry point. As can be seen in the screenshot below, the entry point around 4:03 pm has been selected and all events belonging to this entry point are displayed on the right side.

  {{< popup_image
  link="./assets/bridge_details.png"
  caption="Keptn's Bridge event stream">}}


## Early Access Version of Keptn's Bridge

<!--
Right now there is no early access version of Keptn's Bridge available. You can upgrade to the latest version (0.6.1) by executing the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge:0.6.1 --record
kubectl -n keptn set image deployment/configuration-service bridge=keptn/configuration-service:0.6.1 --record
kubectl -n keptn-datastore set image deployment/mongodb-datastore mongodb-datastore=keptn/mongodb-datastore:0.6.1 --record
```
-->


There is an early access version of Keptn's Bridge available (compatible with Keptn 0.6.1):

  {{< popup_image
  link="./assets/bridge_eap.png"
  caption="Keptn's Bridge EAP">}}

To install it, you have to update the Docker images of *Keptn's Bridge*, *configuration-service* and the *mongodb-datastore* deployment by executing the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:20200326.0744 --record
```

If you want to access the new Keptn's Bridge you have to use `port-forward` again:

```console
kubectl port-forward svc/bridge -n keptn 9000:8080
```

If you want to restore the old version of bridge, configuration-service and mongodb-datastore (as delivered with Keptn 0.6.1), you can use the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:0.6.1 --record
```


If you have any questions or feedback regarding Keptn's Bridge, please contact us through our [Keptn Community Channels](https://github.com/keptn/community)!
