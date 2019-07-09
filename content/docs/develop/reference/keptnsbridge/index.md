---
title: keptn's bridge
description: The following description explains how to access the keptn's log using Kibana.
weight: 21
keywords: [bridge]
---

*DISCLAIMER: This feature is currently not available if you run keptn on OpenShift. We will add logging capabilities for OpenShift in subsequent releases.*

The keptn's bridge lets you browse the keptn's log. It is automatically installed with your keptn installation.

## Usage

The keptn's bridge is not publicly accessible, but can be retrieved by enabling port-forwarding from your local machine to the keptn's bridge:
```console
kubectl port-forward svc/$(kubectl get ksvc bridge -n keptn -ojsonpath={.status.latestReadyRevisionName})-service -n keptn 9000:80
```
Now you can access the bridge from your browser on http://localhost:9000.

The keptn's bridge provides an easy way to browse all events that are sent within keptn and to filter on a specific keptn context. 
When you access the keptn's bridge, all keptn entry points will be listed in the left column. Please note that this list only represents the start of a deployment of a new artifact and, thus, more information on the executed steps can be revealed when you click on one event.

  {{< popup_image
  link="./assets/bridge-empty.png"
  caption="keptn's bridge"
  width="70%">}}

When selecting an event, the keptn's bridge displays all other events that are in the same keptn context and, thus, belong to the selected entry point. As can be seen in the screenshot below, the entry point around 4:22pm has been selected and all events belonging to this entry point are shown. The detail section lists the _timestamp_ as well as _payload_ of the event. Additionally, the _service_ that sent this event is also shown.

  {{< popup_image
  link="./assets/bridge-detail.png"
  caption="keptn's bridge"
  width="70%">}}

