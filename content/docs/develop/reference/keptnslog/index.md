---
title: keptn's log
description: The following description explains how to access the keptn's log using Kibana.
weight: 20
keywords: [log]
---

**DISCLAIMER: This feature is currently not available if you run keptn on OpenShift. We will add logging capabilities for OpenShift in subsequent releases.**


Keptn uses the logging functionality provided by the underlying knative installation that comes with keptn. This means that you can use [Kibana](https://www.elastic.co/products/kibana) to access and analyze the logging output created by the keptn services.

For security purposes, Kibana is exposed only within the cluster. To access the Kibana UI via your browser, you can start a local proxy by running the following command:

```console
kubectl proxy
```

Afterwards, you can navigate to the Kibana UI http://localhost:8001/api/v1/namespaces/knative-monitoring/services/kibana-logging/proxy/app/kibana (Please be patient, it might take a couple of minutes for the proxy to work)

Setup keptns log within the **Configure an index pattern** page:

- Enter `logstash-*` to `Index pattern` 
- Select `@timestamp` from `Time Filter field name` 
- Click on the `Create` button.

## Analyzing deployments

Keptn summarizes logs for a specific deployment of a new artifact by adding a property called `keptnContext` to the log messages of the services that participate during this deployment. To retrieve the `keptnContext` for a deployment, do the following:

  1. Navigate to the <a href="http://localhost:8001/api/v1/namespaces/knative-monitoring/services/kibana-logging/proxy/app/kibana#/discover?_g=()&_a=(columns:!(keptnService,message,logLevel,keptnContext),index:AWmaEz7MZe0TiwRXPS-e,interval:auto,query:(query_string:(analyze_wildcard:!t,query:'keptnEntry:%20true')),sort:!('@timestamp',desc))">Discover</a> view in Kibana (Please use that specific link, as that one already contains the ideal formatting configuration).
    
  1. Ensure that you have selected the correct time frame on the top right corner of the Discover view.

  1. Entrypoints for deployments are marked with `keptnEntry: true`. To retrieve all events of this type within the selected timeframe, enter "keptnEntry: true" in the search bar at the top. Afterwards, you should see something like this:

    {{< popup_image link="./assets/entry.png" caption="Keptn Entry Points">}}

  1. As you can see in the example in the screenshot, a new deployment for the *carts* service of our *sockshop* project has been initiated as a result of executing the [keptn CLI](../cli/#keptn-send-event-new-artifact) command for sending a new artifact event. To see all log messages relevant to this deployment, copy the value of the *keptnContext* at the right side of the table. Afterwards, enter the following query into the search bar at the top: `keptnContext: <KEPTN_CONTEXT>`. As a result, you will be presented with a view resembling the example below:

    {{< popup_image link="./assets/pipeline-log.png" caption="Keptn Entry Log Entries">}}

At this point you will be able to inspect the log messages of all services participating during a deployment of a new artifact.

## Exporting log traces
In case you want to export the keptn's log for debugging purposes, you can do so in the <a href="http://localhost:8001/api/v1/namespaces/knative-monitoring/services/kibana-logging/proxy/app/kibana#/dev_tools/console?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd))">Dev Tools</a> section in Kibana. In this view, you will see a *Console* section, where you can generate a JSON object containing all log entries for a specific context by entering the following query:
  ```
  GET _search
  {
    "query": {
      "match": {
        "keptnContext": "36ab658a-5933-4ff3-a079-d7205a339b0d"
      }
    },
    "size": 10000
  }
  ```

As a result, you should retrieve something like this:

  {{< popup_image link="./assets/export.png" caption="Keptn Log Entries in JSON format">}}

These logs can then be shared and used for debugging purposes.

## Troubleshooting

In some cases, when you want to navigate to Kibana in your browser, you might encounter an access-denied error. In that case, please restart the `kubectl proxy` and you should be able to use Kibana again.
