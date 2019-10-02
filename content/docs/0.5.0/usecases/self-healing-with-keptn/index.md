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

To inform Keptn about any issues in a production environment, monitoring has to be set up. The Keptn CLI helps with automated setup and configuration of Prometheus as the monitoring solution running in the Kubernetes cluster. 

For the configuration, Keptn relies on different specification files that define *service level indicators* (SLI), *service level objectives* (SLO), and *remediation actions* for self-healing if service level objectives are not achieved. To learn more about the *service-indicator*, *service-objective*, and *remediation* file, click here [Specifications for Site Reliability Engineering with Keptn](https://github.com/keptn/keptn/blob/master/specification/sre.md).

In order to add these files to Keptn and to automatically configure Prometheus, execute the following commands:

1. Make sure you are in the correct folder of your examples directory:
    ```
    cd examples/onboarding-carts
    ```

1. Configure Prometheus with the Keptn CLI:
    ```console
    keptn add-resource --project=sockshop --service=carts --stage=production --resource=service-indicators.yaml --resourceUri=service-indicators.yaml
    keptn add-resource --project=sockshop --service=carts --stage=production --resource=service-objectives-prometheus-only.yaml --resourceUri=service-objectives.yaml
    keptn add-resource --project=sockshop --service=carts --stage=production --resource=remediation.yaml --resourceUri=remediation.yaml
    keptn configure monitoring prometheus --project=sockshop --service=carts
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
carts-db-57cd95557b-r6cg8         1/1     Running   0          18m
carts-primary-7c96d87df9-75pg7    1/1     Running   0          13m
```

### Generate load for the service

In order to simulate user traffic that is causing an unhealthy behavior in the carts service, please execute the following script. This will add special items into the shopping cart that cause some extensive calculation.

1. Move to the correct folder:
    ```console
    cd ../load-generation/bin
    ```

1. Start the load generation script depending on your OS (replace \_OS\_ with linux, mac, or win):
    ```console
    ./loadgenerator-_OS_ "http://carts.sockshop-production.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')" cpu
    ```

1. (optional:) Verify the load in Prometheus.
    - Make a port forward to access Prometheus:

    ```console
    kubectl port-forward svc/prometheus-service -n monitoring 8080:8080
    ```
    
    - Access the Prometheus from your browser on http://localhost:8080.

    - In the graph tab,add the expression 

    ```console
    avg(rate(container_cpu_usage_seconds_total{namespace="sockshop-production",pod_name=~"carts-primary-.*"}[5m]))
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
    carts            0         0         0            0           34m
    carts-db         1         1         1            1           37m
    carts-primary    2         2         2            2           32m
    ```

1. Also you should see an additional pod running when you execute:
    ```console
    kubectl get pods -n sockshop-production
    ```

    ```console
    NAME                              READY   STATUS    RESTARTS   AGE
    carts-db-57cd95557b-r6cg8         1/1     Running   0          38m
    carts-primary-7c96d87df9-75pg7    2/2     Running   0          33m
    ```

1. Furthermore, you can use Prometheus to double-check the CPU usage:

    {{< popup_image
        link="./assets/prometheus-load-reduced.png"
        caption="Prometheus load"
        width="700px">}}

1. Finally, to get an overview of the actions that got triggered by the Prometheus alert, you can use the bridge. You can access it by a port-forward from your local machine to the Kubernetes cluster:

  ```console 
  kubectl port-forward svc/bridge -n keptn 9000:8080
  ```

Now access the bridge from your browser on http://localhost:9000. 

The Keptn's bridge shows all deployments that have been triggered. On the left-hand side you can see the deployment start events, such as the one that is selected. Over time, more and more events will show up in Keptn's bridge to allow you to check what is going on in your Keptn installation. Please note that if events happen at the same time, their order in the Keptn's bridge might be arbitrary since they are only sorted on the granularity of one second. 

{{< popup_image
  link="./assets/bridge_remediation.png"
  caption="Keptn's bridge">}}

In this example, the bridge tells us that the remediation service triggered an update of the configuration of the carts service by increasing the number of replicas to 2. When the additional replica was available, the wait-service waited for some time (three minutes) for the remediation action to take effect. Afterwards, an evaluation by the pitometer-service was triggered to check if the remediation action resolved the problem. In this case, increasing the number of replicas achieved the desired effect, since the evaluation of the service level objectives has been successful.
