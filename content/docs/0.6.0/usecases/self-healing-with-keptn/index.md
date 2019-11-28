---
title: Self-healing with Keptn
description: Demonstrates how to use the self-healing mechanisms of Keptn to self-heal a demo service, which runs into issues, by providing automated upscaling.
weight: 30
keywords: [self-healing]
aliases:
---
Demonstrates how to use the self-healing mechanisms of Keptn to self-heal a demo service, which runs into issues, by providing automated upscaling.

## About this tutorial

In this tutorial you will learn how to use the capabilities of Keptn to provide self-healing for an application without modifying any of the applications code. The tutorial presented in the following will scale up the pods of an application if the application undergoes heavy CPU saturation. 

## Prerequisites

- Finish the [Onboarding a Service](../onboard-carts-service/) tutorial.

- Clone the example repository, which contains specification files:

    ```console
    git clone --branch 0.6.0.beta https://github.com/keptn/examples.git --single-branch
    ```

## Configure monitoring

To inform Keptn about any issues in a production environment, monitoring has to be set up. The Keptn CLI helps with automated setup and configuration of Prometheus as the monitoring solution running in the Kubernetes cluster. 

For the configuration, Keptn relies on different specification files that define *service level indicators* (SLI), *service level objectives* (SLO), and *remediation actions* for self-healing if service level objectives are not achieved. To learn more about the *service-indicator*, *service-objective*, and *remediation* file, click here [Specifications for Site Reliability Engineering with Keptn](https://github.com/keptn/spec/blob/0.1.0.beta/sre.md).

In order to add these files to Keptn and to automatically configure Prometheus, execute the following commands:

1. Make sure you are in the correct folder of your examples directory:
    ```
    cd examples/onboarding-carts
    ```

1. Configure Prometheus with the Keptn CLI:

    ```console
    kubectl apply -f prometheus-sli-config.yaml
    ```

    ```console
    keptn add-resource --project=sockshop --service=carts --stage=production --resource=slo_self-healing_prometheus.yaml --resourceUri=slo.yaml
    ```

    ```console
    keptn add-resource --project=sockshop --service=carts --stage=production --resource=remediation.yaml --resourceUri=remediation.yaml
    ```

    ```console
    keptn configure monitoring prometheus --project=sockshop --service=carts
    ```

Executing this command will perform the following tasks:

  - Adds the files `slo.yaml` and `remediation.yaml` to the `production` branch of your Keptn configuration repository
  - Configures Prometheus with scrape jobs and alerting rules for the service
  - Sets up the [Alert Manager](https://prometheus.io/docs/alerting/configuration/) to manage alerts


<details><summary>*Click here to inspect the files that have been added.*</summary>

- `slo.yaml`

  ```yaml
  ---
  spec_version: '0.1.0'
  filter:
  comparison:
    compare_with: "single_result"
    include_result_with_score: "pass"
    aggregate_function: avg
  objectives:
    - sli: cpu_usage
      pass:
        - criteria:
            - "<0.2"
  total_score:  # maximum score = sum of weights
    pass: "90%" # by default this is interpreted as ">="
    warning: 75%
  ```

- `remediation.yaml`

  ```yaml
  remediations:
  - name: cpu_usage
  actions:
  - action: scaling
      value: +1
  ```

</details>

## Run the tutorial

### Deploy an unhealthy service version

In order to test the self-healing capabilities, deploy an unhealthy version of the carts microservice. This version has some issues that are not detected by the automated quality gates since the tests generate artificial traffic while in production real user traffic might reveal untested parts of the microservice that have issues.

Therefore, please make sure that you have completed the [Onboarding a Service](../onboard-carts-service/) or the [Deployment with Quality Gates](../deployments-with-quality-gates/) tutorial (i.e., all shown versions contain issues that are not detected by the quality gates).

You can check if the service is already running in your production stage by executing the following command and reviewing the output. It should show two pods in total.

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
    
    - Access Prometheus from your browser on http://localhost:8080.

    - In the **Graph** tab, add the expression 

    ```console
    avg(rate(container_cpu_usage_seconds_total{namespace="sockshop-production",pod_name=~"carts-primary-.*"}[5m]))
    ```
    
    - Select the **Graph** tab to see your CPU metrics of the `carts-primary` pods in the `sockshop-production` environment.

    - You should see a graph which locks similar to this:

    {{< popup_image
        link="./assets/prometheus-load.png"
        caption="Prometheus load"
        width="700px">}}

### Self-healing in action

After approximately 15 minutes, the *Prometheus Alert Manager* will send out an alert since the service level objective is not met anymore. 

1. To verify that an alert was fired, select the *Alerts* view where you should see that the alert `cpu_usage_sockshop_carts` is in the `firing` state:

    {{< popup_image
        link="./assets/alert-manager.png"
        caption="Alert manager"
        width="700px">}}

The alert will be received by the Prometheus service that will translate it into a Keptn CloudEvent. This event will eventually be received by the remediation service that will look for a remediation action specified for this type of problem and, if found, executes it.

In this tutorial, the number of pods will be increased to remediate the issue of the CPU saturation. 

1. Check the executed remediation actions by executing:

    ```console
    kubectl get deployments -n sockshop-production
    ```

    You can see that the `carts-primary` deployment is now served by two pods:

    ```console
    NAME             DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
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

    In this example, the bridge shows that the remediation service triggered an update of the configuration of the carts service by increasing the number of replicas to 2. When the additional replica was available, the wait-service waited for three minutes for the remediation action to take effect. Afterwards, an evaluation by the pitometer-service was triggered to check if the remediation action resolved the problem. In this case, increasing the number of replicas achieved the desired effect, since the evaluation of the service level objectives has been successful.
    
    {{< popup_image
    link="./assets/bridge_remediation.png"
    caption="Keptn's bridge">}}

