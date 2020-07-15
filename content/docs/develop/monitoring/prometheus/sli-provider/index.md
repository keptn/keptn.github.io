---
title: SLI-Provider
description: Install SLI-Provider
weight: 1
icon: setup
keywords: setup
---

## Setup Prometheus SLI-provider 

During the evaluation of a quality gate, the Prometheus SLI-provider is required that is implemented by an internal Keptn service, the *prometheus-sli-service*. This service will fetch the values for the SLIs that are referenced in a SLO configuration.

1. To install the *prometheus-sli-service*, execute:

    ```console
    kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/prometheus-sli-service/0.2.2/deploy/service.yaml
    ```

1. The *prometheus-sli-service* needs access to a Prometheues instance. If you have completed the steps from [Setup Prometheus](./#setup-prometheus), the *prometheus-sli-service* uses the Prometheus instance running in the cluster. Otherwise,
create a *secret* containing the **user**, **password**, and **url**. The secret must have the following format (please note the double-space indentation):

    ```yaml
      user: username
      password: ***
      url: http://prometheus-service.monitoring.svc.cluster.local:8080
    ```

    If this information is stored in a file, e.g. `prometheus-creds.yaml`, the secret can be created with the following command. Please note that there is a naming convention for the secret because this can be configured per **project**. Thus, the secret has to have the name `prometheus-credentials-<project>`. Do not forget to replace the `<project>` placeholder with the name of your project:

    ```console
    kubectl create secret -n keptn generic prometheus-credentials-<project> --from-file=prometheus-credentials=./prometheus-creds.yaml
    ```

## Configure custom Prometheus SLIs

To tell the *prometheus-sli-service* how to acquire the values of an SLI, the correct query needs to be configured. This is done by adding an SLI configuration to a project, stage, or service using the [add-resource](../../../reference/cli/commands/keptn_add-resource) command. The resource identifier must be `prometheus/sli.yaml`.

* In the below example, the SLI configuration as specified in the `sli-config-prometheus.yaml` file is added to the service `carts` in stage `hardening` from project `sockshop`. 

```console
keptn add-resource --project=sockshop --stage=hardening --service=carts --resource=sli-config-prometheus.yaml --resourceUri=prometheus/sli.yaml
```

**Note:** The add-resource command can be used to store a configuration on project-, stage-, or service-level. If you store SLI configurations on different levels, click [here](../../../quality_gate/sli/#add-sli-configuration-to-service-stage-or-project) to learn which configuration overrides the others based on an example.

**Example for custom SLI:** 

Please take a look at this snippet, which implements a concrete SLI configuration to learn more about the structure of a SLI file. It is possible to use placeholders such as `$PROJECT`, `$SERVICE`, `$STAGE` and `$DURATION_SECONDS` in the queries.

```yaml
---
spec_version: '1.0'
indicators:
  response_time_p50: histogram_quantile(0.5, sum by(le) (rate(http_response_time_milliseconds_bucket{job="$SERVICE-$PROJECT-$STAGE"}[$DURATION_SECONDS])))
  response_time_p90: histogram_quantile(0.9, sum by(le) (rate(http_response_time_milliseconds_bucket{job="$SERVICE-$PROJECT-$STAGE"}[$DURATION_SECONDS])))
  response_time_p95: histogram_quantile(0.95, sum by(le) (rate(http_response_time_milliseconds_bucket{job="$SERVICE-$PROJECT-$STAGE"}[$DURATION_SECONDS])))
```

