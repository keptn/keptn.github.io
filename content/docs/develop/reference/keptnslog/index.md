---
title: keptn's log
description: The following description explains how to access the keptn's log using Kibana.
weight: 20
keywords: [log]
---

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

## Analyzing pipeline runs

Keptn summarizes logs for a specific pipeline run by adding a property called `keptnContext` to the log messages of the services that participate during a pipeline run for a new artefact. To retrieve the `keptnContext` for a pipeline run, do the following:

  1. Navigate to the <a href="http://localhost:8001/api/v1/namespaces/knative-monitoring/services/kibana-logging/proxy/app/kibana#/discover?_g=()&_a=(columns:!(keptnService,message,logLevel,keptnContext),index:AWmaEz7MZe0TiwRXPS-e,interval:auto,query:(query_string:(analyze_wildcard:!t,query:'keptnEntry:%20true')),sort:!('@timestamp',desc))">Discover</a> view in Kibana (Please use that specific link, as that one already contains the ideal formatting configuration).
    
  1. Ensure that you have selected the correct time frame on the top right corner of the Discover view.

  1. Entrypoints for new pipeline runs are marked with `keptnEntry: true`. To retrieve all events of this type within the selected timeframe, enter "keptnEntry: true" in the search bar at the top. Afterwards, you should see something like this:

    {{< popup_image link="./assets/entry.png" caption="Keptn Entry Points">}}

  1. As you can see in the example in the screenshot, we see that during that timeframe, a new pipeline run for the *carts* service of our *sockshop* project has been initiated as a result of a new image being pushed to the docker registry. To see all log messages relevant to this run, copy the value of the *keptnContext* at the right side of the table. Afterwards, enter the following query into the search bar at the top: `keptnContext: <KEPTN_CONTEXT>`. As a result, you will be presented with a view resembling the example below:

    {{< popup_image link="./assets/pipeline-log.png" caption="Keptn Entry Log Entries">}}

At this point you will be able to inspect the log messages of all services participating during a pipeline run.

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

These logs can then be shared and used for debugging purposes, in case you encounter any problems during the execution of your build pipelines.

## Troubleshooting

In some cases, when you want to navigate to Kibana in your browser, you might encounter an access-denied error. In that case, please restart the `kubectl proxy` and you should be able to use Kibana again.
