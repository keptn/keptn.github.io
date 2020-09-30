---
title: SLI-Provider
description: Add an SLI-Provider to Keptn for querying provider-specific SLIs.
weight: 20
keywords: [0.7.x-quality_gates]
---

Depending on the monitoring solution you have in place and the SLIs you have configured for your services, you need to deploy the corresponding SLI-provider. In Keptn 0.7, this can be either *Dynatrace* or *Prometheus*. 

## Dynatrace SLI-Provider

* Complete steps from section [Setup Dynatrace SLI-provider](../../monitoring/dynatrace/sli_provider/#setup-dynatrace-sli-provider).

* To configure Keptn to use the Dynatrace SLI-provider for your project (e.g. **musicshop**), execute the following command:

    ```console
    keptn configure monitoring dynatrace --project=musicshop
    ```

* Configure custom SLIs for the Dynatrace SLI-provider as explained [here](../../monitoring/dynatrace/sli_provider/#configure-custom-dynatrace-slis).

## Prometheus SLI-Provider

* Complete steps from section [Setup Prometheus SLI-provider](../../monitoring/prometheus/sli-provider/#setup-prometheus-sli-provider).

* To configure Keptn to use the Prometheus SLI-provider for your project (e.g. **musicshop**), execute the following command:

    ```console
    keptn configure monitoring prometheus --project=musicshop --service=catalogue
    ```

* Configure custom SLIs for the Prometheus SLI-provider as explained [here](../../monitoring/prometheus/sli-provider/#configure-custom-prometheus-slis).

## Add custom SLI-Provider

* To create and add your custom SLI-provider to Keptn, please follow the instructions [here](../../integrations/sli_provider).

