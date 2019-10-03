---
title: Keptn's bridge
description: The following description explains how to access the Keptn's log using Kibana.
weight: 21
keywords: [bridge]
---

The Keptn's bridge lets you browse the Keptn's log. It is automatically installed with your Keptn installation.

## Usage

The Keptn's bridge is not publicly accessible, but can be retrieved by enabling port-forwarding from your local machine to the Keptn's bridge:

```console
kubectl port-forward svc/bridge -n keptn 9000:8080
```

It is then available on: http://localhost:9000.

The Keptn's bridge provides an easy way to browse all events that are sent within Keptn and to filter on a specific Keptn context. When you access the Keptn's bridge, all Keptn entry points will be listed in the left column. Please note that this list only represents the start of a deployment of a new artifact and, thus, more information on the executed steps can be revealed when you click on one event.

  {{< popup_image
  link="./assets/bridge_empty.png"
  caption="Keptn's bridge start page">}}

When selecting an event, the Keptn's bridge displays all other events that are in the same Keptn context and, thus, belong to the selected entry point. As can be seen in the screenshot below, the entry point around 4:22pm has been selected and all events belonging to this entry point are shown. The detail section lists the _timestamp_ as well as _payload_ of the event. Additionally, the _service_ that sent this event is also shown.

  {{< popup_image
  link="./assets/bridge_details.png"
  caption="Keptn's bridge detailed view">}}

