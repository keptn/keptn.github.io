---
title: Self-healing with Keptn
description: Demonstrates how to use the self-healing mechanisms of Keptn with Dynatrace
weight: 30
keywords: [self-healing]
aliases:
---
Demonstrates how to use the self-healing mechanisms of Keptn to self-heal a demo service, which runs into issues, by providing automated upscaling.

## About this tutorial

In this tutorial, you will learn how to use the capabilities of Keptn to provide self-healing for an application without modifying any of the applications code. The tutorial presented in the following will scale up the pods of an application if the application undergoes heavy CPU saturation. 

## Prerequisites

- Finish the [Onboarding a Service](../onboard-carts-service/) tutorial.

- Clone the example repository, which contains specification files:

    ```console
    git clone --branch 0.6.0 https://github.com/keptn/examples.git --single-branch
    ```

## Configure monitoring

To inform Keptn about any issues in a production environment, monitoring has to be set up. The Keptn CLI helps with the automated setup and configuration of Prometheus as the monitoring solution running in the Kubernetes cluster. 

For the configuration, Keptn relies on different specification files that define *service level indicators* (SLI), *service level objectives* (SLO), and *remediation actions* for self-healing if service level objectives are not achieved. To learn more about the *service-indicator*, *service-objective*, and *remediation* file, click here [Specifications for Site Reliability Engineering with Keptn](https://github.com/keptn/spec/blob/0.1.1/sre.md).

To add these files to Keptn and to automatically configure Prometheus, execute the following commands:

1. Make sure you are in the correct folder of your examples directory:
    ```
    cd examples/onboarding-carts
    ```

1. Configure your SLOs and remediation actions with the Keptn CLI:

    ```console
    keptn add-resource --project=sockshop --stage=production --service=carts --resource=slo-self-healing.yaml --resourceUri=slo.yaml
    ```

    ```console
    keptn add-resource --project=sockshop --stage=production --service=carts --resource=remediation.yaml --resourceUri=remediation.yaml
    ```

    ```console
    keptn configure monitoring dynatrace --project=sockshop
    ```

Executing this command will perform the following tasks:

  - Adds the files `slo.yaml` and `remediation.yaml` to the `production` branch of your Keptn configuration repository


<details><summary>*Click here to inspect the files that have been added.*</summary>

- `slo.yaml`

  ```yaml
  ---
  spec_version: '0.1.1'
  comparison:
    compare_with: "single_result"
    include_result_with_score: "pass"
    aggregate_function: avg
  objectives:
    - sli: response_time_p90
      pass:        # pass if (relative change <= 10% AND absolute value is < 500)
        - criteria:
            - "<=+10%" # relative values require a prefixed sign (plus or minus)
            - "<1000"   # absolute values only require a logical operator
      warning:     # if the response time is below 800ms, the result should be a warning
        - criteria:
            - "<=1200"
  total_score:
    pass: "90%"
    warning: 40%
  ```

- `remediation.yaml`

  ```yaml
  remediations:
  - name: Response time degradation
  actions:
  - action: scaling
      value: +1
  ```

</details>
</p>


## Run the tutorial

### Deploy an unhealthy service version

To test the self-healing capabilities, deploy an unhealthy version of the carts microservice. This version has some issues that are not detected by the automated quality gates since the tests generate artificial traffic while in production real user traffic might reveal untested parts of the microservice that have issues.

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

To simulate user traffic that is causing an unhealthy behavior in the carts service, please execute the following script. This will add special items into the shopping cart that cause some extensive calculation.

1. Move to the correct folder:

    ```console
    cd ../load-generation/bin
    ```

1. Start the load generation script depending on your OS (replace \_OS\_ with linux, mac, or win):

    ```console
    ./loadgenerator-_OS_ "http://carts.sockshop-production.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')" cpu 3
    ```

1. (optional:) Verify the load in Dynatrace.


### Self-healing in action

After approximately 10-15 minutes, Dynatrace will send out a problem notification because of the response time degradation. 

1. To verify that an alert was fired, select the *Alerts* view where you should see that the alert `response_time_p90` is in the `firing` state:

    {{< popup_image
        link="./assets/alert-manager.png"
        caption="Alert manager"
        width="700px">}}

After receiving the problem notification, the `dynatrace-service` will translate it into a Keptn CloudEvent. This event will eventually be received by the remediation service that will look for a 
remediation action specified for this type of problem and, if found, execute it.

In this tutorial, the number of pods will be increased to remediate the issue of the response time increase. 

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
    carts-primary-7c96d87df9-78fh2    2/2     Running   0          5m
    ```

1. To get an overview of the actions that got triggered by the response time SLO violation, you can use the bridge. You can access it by a port-forward from your local machine to the Kubernetes cluster:

    ```console 
    kubectl port-forward svc/bridge -n keptn 9000:8080
    ```

    Now access the bridge from your browser on http://localhost:9000. 

    In this example, the bridge shows that the remediation service triggered an update of the configuration of the carts service by increasing the number of replicas to 2. When the additional replica was available, the wait-service waited for ten minutes for the remediation action to take effect. Afterwards, an evaluation by the lighthouse-service was triggered to check if the remediation action resolved the problem. In this case, increasing the number of replicas achieved the desired effect, since the evaluation of the service level objectives has been successful.
    
    {{< popup_image
    link="./assets/bridge_remediation.png"
    caption="Keptn's bridge">}}
    
1. Furthermore, you can see how the response time of the service decreased by viewing the time series chart in Dynatrace:




