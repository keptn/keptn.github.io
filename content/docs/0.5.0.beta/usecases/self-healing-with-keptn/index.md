---
title: Self-healing with Keptn
description: This use case presents how to use the self-healing mechanisms Keptn provides to self-heal a demo service, which runs into issues, by providing automated upscaling.
weight: 30
keywords: [self-healing]
aliases:
---
This use case presents how to use the self-healing mechanisms Keptn provides to self-heal a demo service, which runs into issues, by providing automated upscaling.

## About this use case

In this use case you will learn how to use the capabilities of Keptn to provide self-healing for an application without modifying any of the applications code. The use case presented in the following will scale up the pods of an application if the application undergoes heavy CPU saturation. 

## Prerequisites

- Clone the example repository, which contains specification files:

    ```console
    git clone --branch 0.5.0.beta https://github.com/keptn/examples.git --single-branch
    ```

- Finish the [onboarding a service](../onboard-carts-service/) use case.

## Configure monitoring

Monitoring has to be set up to inform Keptn about any issues in a production system. The Keptn CLI helps with automated setup and configuration of Prometheus as the monitoring solution running in the Kubernetes cluster.

For the configuration, Keptn relies on different specification files that define service level indicators (SLI), service level objectives (SLO), as well as remediation actions for self-healing if service level objectives are not met. 

<details>
<summary>
Click here to learn more on the *service-indicator*, *service-objective*, and *remediation* files.
</summary>
<p>

**SLI: service-indicators.yaml**: This file holds the indicators that can be used to define objectives on. These indicators are metrics gathered from different sources, e.g., Prometheus, and define the query how to obtain the metrics. This indicators can be reused to define service objectives.

```yaml
indicators:
- metric: cpu_usage_sockshop_carts
  source: Prometheus
  query: avg(rate(container_cpu_usage_seconds_total{namespace="sockshop-$ENVIRONMENT",pod_name=~"carts-primary-.*"}[$DURATION_MINUTES]))
- metric: request_latency_seconds
  source: Prometheus
  query: rate(requests_latency_seconds_sum{job='carts-sockshop-$ENVIRONMENT'}[$DURATION_MINUTESm])/rate(requests_latency_seconds_count{job='carts-sockshop-$ENVIRONMENT'}[$DURATION_MINUTESm])
```

**SLO: service-objectives.yaml**: This file defines the service level objectives for one or more services. In this case, the CPU saturation metric of the carts service (defined in the service-indicators.yaml file) is reused and augmented with a threshold and a timeframe. The timeframe indicates the duration in which the metrics is evaluated. 

```yaml
pass: 90
warning: 75
objectives:
- metric: request_latency_seconds
  threshold: 0.8
  timeframe: 5m
  score: 50
- metric: cpu_usage_sockshop_carts
  threshold: 0.02
  timeframe: 15m
  score: 50
```

**remediation.yaml**: This file defines remediation actions to execute in response to a problem related to the defined problem pattern / service objective. 

```yaml
remediations:
- name: cpu_usage_sockshop_carts
  actions:
  - action: scaling
    value: +1
```
</p>
</details>

In order to add these files to Keptn and to automatically configure Prometheus, execute the following commands:

1. Make sure you are in the correct folder of your examples directory:
    ```
    cd examples/onboarding-carts
    ```

1. Configure Prometheus with the Keptn CLI:
    ```console
    keptn configure monitoring prometheus --project=sockshop --service=carts --service-objectives=service-objectives.yaml --service-indicators=service-indicators.yaml --remediation=remediation.yaml
    ```

Executing this command will perform the following tasks:

- Set up [Prometheus](https://prometheus.io) 
- Configure Prometheus with scrape jobs and alerting rules for the service
- Set up the [Alert Manager](https://prometheus.io/docs/alerting/configuration/) to manage alerts
- Add the `service-indicators.yaml`, `service-objectives.yaml` and `remediation.yaml` to your Keptn configuration repository

## Run the use case

### Deploy an unhealthy service version

In order to test the self-healing capabilities, deploy an unhealthy version of our carts microservice. This version has some issues that are not detected by the automated quality gates since the tests generate artificial traffic while in production real user traffic might reveal untested parts of the microservice that have issues.

Therefore, please make sure that you have completed the [onboard carts](../onboard-carts-service/) or the [deployment with quality gates](../deployments-with-quality-gates/) use case. 

<!--
Send a new version of the artifact to Keptn:
```console
keptn send event new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.9.0
```
-->

You can check if the service is already running in your production stage by executing the following command and reviewing the output (it should show 2 pods in total).

```console
kubectl get pods -n sockshop-production
```

```console
NAME                              READY   STATUS    RESTARTS   AGE
carts-db-57cd95557b-r6cg8        1/1     Running   0          18m
carts-primary-7c96d87df9-75pg7   1/1     Running   0          13m
```

### Generate load for the service

In order to simulate user traffic that is causing an unhealthy behavior in the carts service, please execute the following script. This will add special items into the shopping cart that cause some extensive calculation.

1. Move to the correct folder:
    ```console
    cd ../load-generation/bin
    ```

1. Start the load generation script depending on your OS (replace \_OS\_ with linux, mac, or win):
    ```console
    ./loadgenerator-_OS_ "http://carts.sockshop-production.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')"
    ```

1. (optional:) Verify the load in Prometheus.
    - Make a port forward to access Prometheus:

    ```console
    kubectl port-forward svc/prometheus-service -n monitoring 8080:8080
    ```
    
    - Access the Prometheus from your browser on http://localhost:8080.

    - In the graph tab,add the expression 

    ```console
    avg(rate(container_cpu_usage_seconds_total{namespace="sockshop-production",pod_name=~"carts-primary-.*"}[15m]))
    ```
    
    - Select the graph tab to see your CPU metrics of the `carts-primary` pods in the `sockshop-production` environment.

    - You should see a graph which locks similar to this:

    {{< popup_image
        link="./assets/prometheus-load.png"
        caption="Prometheus load"
        width="700px">}}

### Watch self-healing in action

After approximately 15 minutes the *Prometheus Alert Manager* will send out an alert since the service level objective is not met anymore. 

1. To verify that an alert was fired, select the "Alerts" view where you should see that the alert `cpu_usage_sockshop_carts` is in the `firing` state:

    {{< popup_image
        link="./assets/alert-manager.png"
        caption="Alert manager"
        width="700px">}}

The alert will be received by the Prometheus service that will translate it into a Keptn CloudEvent. This event will eventually be received by the remediation service that will look for a remediation action specified for this type of problem and, if found, executes it.

In this use case, the number of pods will be increased to remediate the issue of the CPU saturation. 

1. Check the executed remediation actions by executing:

    ```console
    kubectl get deployments -n sockshop-production
    ```

    You can see that the `carts-primary` deployment is now served by two pods:

    ```console
    NAME             DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    carts           0         0         0            0           34m
    carts-db        1         1         1            1           37m
    carts-primary   2         2         2            2           32m
    ```

1. Also you should see an additional pod running when you execute:
    ```console
    kubectl get pods -n sockshop-production
    ```

    ```console
    NAME                              READY   STATUS    RESTARTS   AGE
    carts-db-57cd95557b-r6cg8        1/1     Running   0          38m
    carts-primary-7c96d87df9-75pg7   2/2     Running   0          33m
    ```

1. Furthermore, you can use Prometheus to double-check the CPU usage:

    {{< popup_image
        link="./assets/prometheus-load-reduced.png"
        caption="Prometheus load"
        width="700px">}}
