---
title: Self-healing with Keptn
description: This usecase presents how to use the self-healing mechanisms Keptn provides to self-heal a demo service that runs into issues by providing automated upscaling.
weight: 30
keywords: [self-healing]
aliases:
---

This usecase presents how to use the self-healing mechanisms Keptn provides to self-heal a demo service that runs into issues by providing automated upscaling.


## About this use case

In this use case you will learn how to use the capabilities of Keptn to provide self-healing for an application without modifying any of the applications code. The use case presented in the following will scale up the pods of an application if the application undergoes heavy CPU saturation. 

## Prerequisites

- Have a local copy of example repo to retrieve specification files, you can clone it with: 

    ```console
    git clone --branch 0.5.0 https://github.com/keptn/examples.git --single-branch
    ```
- Finish [onboarding a service](../onboard-carts-service/) use case

## Configure Monitoring

Monitoring has to be set up to inform Keptn about any issues in a production system. The Keptn CLI helps with automated setup and configuration of Prometheus as the monitoring solution running in the Kubernetes cluster.

For the configuration, Keptn relies on different specification files that define service level indicators (SLI), service level objectives (SLO) as well as remediation actions for self-healing if service level objectives are not met. 

<details>
<summary>
Click here to learn more on the service-indicator, service-objective and remediation files.
</summary>
<p>
**service-indicators.yaml**: This file holds the indicators that can be used to define objectives on. These indicators are metrics gathered from different sources, e.g., Prometheus, and define the query how to obtain the metrics. This indicators can be reused to define service objectives.

```yaml
indicators:
- metric: cpu_usage_sockshop_carts_production
  source: Prometheus
  query: avg(rate(container_cpu_usage_seconds_total{namespace="sockshop-production",pod_name=~"carts-blue-.*|carts-green-.*"}[$DURATION_MINUTES]))
- metric: request_latency_seconds
  source: Prometheus
  query: rate(requests_latency_seconds_sum{job='carts-sockshop-production'}[$DURATION_MINUTESm])/rate(requests_latency_seconds_count{job='carts-sockshop-production'}[$DURATION_MINUTESm])
```

**service-objectives.yaml**: This file defines the service level objectives for one or more services. In this case the CPU saturation metric of the carts service (defined in the service-indicators.yaml file) is reused and augmented with a threshold and a timeframe. The timeframe indicates the duration in which the metrics is evaluated. 

```yaml
pass: 90
warning: 75
objectives:
- metric: request_latency_seconds
  threshold: 0.8
  timeframe: 5m
  score: 50
- metrics: cpu_usage_sockshop_carts_production
  threshold: 0.5
  timeframe: 2m
  score: 50
```

**remediation.yaml**: This file defines remediation actions to execute in response to a problem related to the defined problem pattern / service objective. 

```yaml
remediations:
- name: cpu_usage_sockshop_carts_production
  actions:
  - action: scaling
    value: +1
```
</p>
</details>

In order to add these files to Keptn to automatically configure Prometheus, execute the following commands.

Make sure you are in the correct folder of your examples directory:
```
cd examples/onboarding-carts
```

Configure Prometheus with the Keptn CLI:
```console
keptn configure monitoring prometheus --project=sockshop --service=carts --service-objectives=service-objectives.yaml --service-indicators=service-indicators.yaml --remediation=remediation.yaml
```

Executing this command will execute the following tasks:

- Set up [Prometheus](https://prometheus.io) 
- Configure Prometheus with scrape jobs and alerting rules for the service
- Set up the [Alert Manager](https://prometheus.io/docs/alerting/configuration/) to manage alerts
- Add the `service-indicators.yaml`, `service-objectives.yaml` and `remediation.yaml` to your Keptn config repository



## Run the Use Case

### 1. Deploy an unhealthy service version

In order to test the self-healing capabilities let us deploy an unhealthy version of our carts microservice that has some issues that might not be detected by the automated quality gates since the tests generate artificial traffic, while in production real user traffic might reveal untested parts of the microservice that have issues.

Therefore, please make sure that you have completed the [onboard carts](../onboard-carts-service/) or the [deployment with quality gates](../deployments-with-quality-gates/) use case. 

<!--
Send a new version of the artifact to Keptn:
```console
keptn send event new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.9.0
```
-->

You can check if the service is already running in your production stage by executing the following command and reviewing the output (it should show 4 pods in total).

```console
kubectl get pods -n sockshop-production
```

```console
NAME                              READY   STATUS    RESTARTS   AGE
carts-blue-856559f565-jnrsc       1/1     Running   0          6h
carts-db-blue-554d575dcc-h76s4    1/1     Running   0          6h
carts-db-green-859b98755c-jpq72   1/1     Running   0          6h
carts-green-579fc5cd59-z62gw      1/1     Running   0          6h
```

### 2. Generate load for the service

In order to simulate user traffic that is causing an unhealthy behaviour in the carts servcie, please execute the following script. This will add special items into the shopping cart that cause some extensive calculation.

Move to the correct folder:
```console
cd ../loadgeneration
```

Start the load generation script:
```console
./add-to-cart.sh "carts.sockshop-production.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')"
```

(Optional:) Verify load in Prometheus:

ADD IMAGE OF PROMETHEUS HERE

### 3. Watch self-healing in action

After a couple of minutes the Prometheus Alert Manager will send out an alert since the service level objective is not met anymore. 

INSERT IMAGE OF ALERT MANAGER

The alert will be received by the Prometheus service that will translate it into a Keptn CloudEvent.
This event will eventually be received by the remediation service that will look for a remediation action specified for this type of problem and, if found, execute it.

In this use case, the number of pods will be increased to remediate the issue of the CPU saturation.
Check the executed remediation actions by executing:

```console
kubectl get deployments -n sockshop-production
```

```console
NAME             DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
carts-blue       2         2         2            2           6h
carts-db-blue    1         1         1            1           6h
carts-db-green   1         1         1            1           6h
carts-green      1         1         1            1           6h
```

Also you should see an additional pod running when you execute:
```console
kubectl get pods -n sockshop-production
```

```console
NAME                              READY   STATUS    RESTARTS   AGE
carts-blue-856559f565-jnrsc       1/1     Running   0          6h
carts-blue-424559f425-ldoev       1/1     Running   0          1m
carts-db-blue-554d575dcc-h76s4    1/1     Running   0          6h
carts-db-green-859b98755c-jpq72   1/1     Running   0          6h
carts-green-579fc5cd59-z62gw      1/1     Running   0          6h
```

## Summary
