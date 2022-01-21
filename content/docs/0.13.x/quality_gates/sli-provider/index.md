---
title: SLI-Provider
description: Add an SLI-Provider to Keptn for querying provider-specific SLIs.
weight: 20
keywords: [0.13.x-quality_gates]
---

Depending on the monitoring solution you have in place and the SLIs you have configured for your services, you need to deploy the corresponding SLI-provider. In Keptn 0.13.x, this can be either *Dynatrace* or *Prometheus*. 

## Dynatrace SLI-Provider

* Complete steps from section [Install Dynatrace Keptn integration](../../monitoring/dynatrace/install/#install-dynatrace-keptn-integration).

* To configure Keptn to use Dynatrace SLIs for your project (e.g. **musicshop**), execute the following command:

    ```console
    keptn configure monitoring dynatrace --project=musicshop
    ```

* Configure custom Dynatrace SLIs as explained [here](../../monitoring/dynatrace/configure_slis).

## Prometheus SLI-Provider

* Complete steps from section [Setup Prometheus SLI-provider](../../monitoring/prometheus/install/#setup-prometheus-sli-provider).

* To configure Keptn to use the Prometheus SLI-provider for your project (e.g. **musicshop**), execute the following command:

    ```console
    keptn configure monitoring prometheus --project=musicshop --service=catalogue
    ```

* Configure custom SLIs for the Prometheus SLI-provider as explained [here](../../monitoring/prometheus/install/#configure-custom-prometheus-slis).

## Add custom SLI-Provider

* To create and add your custom SLI-provider to Keptn, please follow the instructions [here](../../integrations/sli_provider).

