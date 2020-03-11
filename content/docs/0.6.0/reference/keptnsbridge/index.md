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

It is then available on: http://localhost:9000.

The Keptn's Bridge provides an easy way to browse all events that are sent within Keptn and to filter on a specific Keptn context. When you access the Keptn's Bridge, all Keptn entry points will be listed in the left column. Please note that this list only represents the start of a deployment of a new artifact and, thus, more information on the executed steps can be revealed when you click on one event.

  {{< popup_image
  link="./assets/bridge_empty.png"
  caption="Keptn's Bridge start page">}}

When selecting an event, the Keptn's Bridge displays all other events that are in the same Keptn context and, thus, belong to the selected entry point. As can be seen in the screenshot below, the entry point around 4:22 pm has been selected and all events belonging to this entry point are shown. The detail section lists the _timestamp_ as well as _payload_ of the event. Additionally, the _service_ that sent this event is also shown.

  {{< popup_image
  link="./assets/bridge_details.png"
  caption="Keptn's Bridge detailed view">}}

**Please note**: Keptn's Bridge exposes sensitive information. We do not recommend exposing it publicly via LoadBalancer, NodePort, VirtualServices or alike.


## Early Access Version of Keptn's Bridge

There is an early access version of Keptn's Bridge available (compatible with Keptn 0.6.0):

  {{< popup_image
  link="./assets/bridge_eap.png"
  caption="Keptn's Bridge EAP">}}

To install it, you have to update the Docker images of *Keptn's Bridge*, *configuration-service* and the *mongodb-datastore* deployment by executing the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:20200308.0859 --record
kubectl -n keptn set image deployment/configuration-service configuration-service=keptn/configuration-service:20200308.0859 --record
kubectl -n keptn-datastore set image deployment/mongodb-datastore mongodb-datastore=keptn/mongodb-datastore:20200308.0859 --record
```

If you want to access the new Keptn's Bridge you have to use `port-forward` again:

```console
kubectl port-forward svc/bridge -n keptn 9000:8080
```

If you want to restore the old version of bridge, configuration-service and mongodb-datastore (as delivered with Keptn 0.6.0), you can use the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge:0.6.0 --record
kubectl -n keptn set image deployment/configuration-service bridge=keptn/configuration-service:0.6.0 --record
kubectl -n keptn-datastore set image deployment/mongodb-datastore mongodb-datastore=keptn/mongodb-datastore:0.6.0 --record
```

If you have any questions or feedback regarding the EAP of Keptn's Bridge, please contact us through our [Keptn Community Channels](https://github.com/keptn/community)!
