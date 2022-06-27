---
title: SLI-Provider
description: Add an SLI-Provider to Keptn for querying provider-specific SLIs.
weight: 730
keywords: [0.17.x-quality_gates]
---

Depending on the monitoring solution you have in place and the SLIs you have configured for your services,
you need to deploy the corresponding SLI-provider.
In Keptn 0.17.x, this can be either *Dynatrace*, *Prometheus*, or *Datadog*.

## Dynatrace SLI-Provider

* Complete steps from section [Install Dynatrace Keptn integration](../../../install/monitoring/dynatrace/install/#install-dynatrace-keptn-integration).

* To configure Keptn to use Dynatrace SLIs for your project (e.g. **musicshop**), execute the following command:

    ```console
    keptn configure monitoring dynatrace --project=musicshop
    ```

* Configure custom Dynatrace SLIs as explained [here](../../../install/monitoring/dynatrace/configure_slis).

## Prometheus SLI-Provider

* Complete steps from section [Set Up Prometheus SLI-provider](../../../install/monitoring/prometheus/install/#set-up-prometheus-keptn-integration).

* To configure Keptn to use the Prometheus SLI-provider for your project (e.g. **musicshop**), execute the following command:

    ```console
    keptn configure monitoring prometheus --project=musicshop --service=catalogue
    ```

* Configure custom SLIs for the Prometheus SLI-provider as explained [here](../../../install/monitoring/prometheus/install/#configure-custom-prometheus-slis).

## Datadog SLI-Provider

Please, refer to the documentation of the [SLI-Provider](https://github.com/keptn-sandbox/datadog-service#datadog-service).

## Add custom SLI-Provider

* To create and add your custom SLI-provider to Keptn, please follow the instructions [here](../../integrations/sli_provider).


