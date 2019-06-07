---
title: keptn's bridge
description: The following description explains how to access the keptn's log using Kibana.
weight: 21
keywords: [bridge]
---

The keptn's bridge lets you browse the keptn's log. It is automatically installed with your keptn installation.

## Usage

The keptn's bridge is not publicly accessible, but can be retrieved by enable port-forwarding from your local machine to the keptn's bridge:
```console
kubectl port-forward svc/$(kubectl get ksvc bridge -n keptn -ojsonpath={.status.latestReadyRevisionName})-service -n keptn 9000:80
```

The keptn's bridge provides an easy way to browse all events that are sent within keptn and to filter on a specific keptn context. 
When you access the keptn's bridge, all keptn entry points will be listed in the left column for you to browse. Pleaes note that this list only represents the start of a keptn pipeline run, thus, more information on pipeline run can be revealed when you click on one event.

  {{< popup_image
  link="./assets/bridge-empty.png"
  caption="keptn's bridge"
  width="70%">}}

When selecting an event, the keptn's bridge displays all other events that are in the same keptn context and, thus, belong to the selected entry point. As can be seen in the screenshot below, the entry point around 4:22pm has been selected and all events belonging to this entry point are shown. The detail section lists the _timestamp_ as well as _payload_ of the event. Additionally, the _service_ that sent this event is also shown.

  {{< popup_image
  link="./assets/bridge-detail.png"
  caption="keptn's bridge"
  width="70%">}}

