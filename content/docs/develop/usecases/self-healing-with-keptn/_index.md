---
title: Self-healing
weight: 30
description: Provides details about self-healing using upscaling and feature toggle.
---

## About this tutorial

In this tutorial, you will learn how to use the capabilities of Keptn to provide self-healing for an application. 

The tutorial presented in the following will provide information about the self-healing actions *scale up*  and *feature toggle*.

For the configuration, Keptn relies on several specification files that define *service level indicators* (SLI), *service level objectives* (SLO), and *remediation actions* for self-healing if service level objectives are not achieved. To learn more about the *service-indicator*, *service-objective*, and *remediation* file, click here [Specifications for Site Reliability Engineering with Keptn](https://github.com/keptn/spec/blob/0.1.3/sre.md).

## Prerequisites

- Finish the [Onboarding a Service](../onboard-carts-service/) tutorial

- Setup monitoring with Prometheus or Dynatrace (e.g., by following the [Deployment with Quality Gates](../deployments-with-quality-gates/) tutorial).

- Clone the example repository, which contains specification files:

```console
git clone --branch 0.6.1 https://github.com/keptn/examples.git --single-branch
```

### Difference to Deployment with Quality Gates

Within this tutorial we will use a version of the carts microservice that has already passed the quality gate for *staging*. However, the deployed carts service has some issues that only arise in production with real user traffic - this indicates that there might be untested parts of the microservice that have issues.

<details><summary>Click here for details on how to check if you are running the correct version</summary>
<p>You can check if the service is already running in your production stage by executing the following command and reviewing the output. It should show two pods in total.

```console
kubectl get pods -n sockshop-production
```

```console
NAME                              READY   STATUS    RESTARTS   AGE
carts-db-57cd95557b-r6cg8         1/1     Running   0          18m
carts-primary-7c96d87df9-75pg7    1/1     Running   0          13m
```

You should also verify that the image used for the deployments of `carts` and `carts-primary` is either the one with `0.11.1` or `0.11.3` within the tag by executing

```console
kubectl get deployments -n sockshop-production -o wide
```

```console
NAME            READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                 SELECTOR
carts           0/0     0            0           28h   carts        docker.io/keptnexamples/carts:0.11.3   app=carts
carts-db        1/1     1            1           44h   carts-db     mongo:latest                           app=carts-db
carts-primary   1/1     1            1           22h   carts        docker.io/keptnexamples/carts:0.11.3   app=carts-primary
```

In case you do not have `0.11.1` or `0.11.3` deployed, please run
```console
keptn send event new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.11.1
```
</p>
</details>

## Initial steps

1. Make sure you are in the correct folder of your examples directory:
    ```
    cd examples/onboarding-carts
    ```

1. Add an SLO file for the *production* stage using the Keptn CLIs [add-resource](../../reference/cli/#keptn-add-resource) command:

    ```console
    keptn add-resource --project=sockshop --stage=production --service=carts --resource=slo-self-healing.yaml --resourceUri=slo.yaml
    ```

    **Note:** The SLO file contains an objective for `response_time_p90`.


## Follow the specific tutorial

Please follow the steps detailed in the following tutorials.

* Self-healing using upscaling with:
  * [Dynatrace](dynatrace-scaling/)
  * [Prometheus](prometheus-scaling/)
* Self-healing using feature toggle based on [Unleash](https://unleash.github.io/) with:
  * [Dynatrace](dynatrace-unleash/)
