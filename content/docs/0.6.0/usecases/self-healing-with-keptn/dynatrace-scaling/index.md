---
title: Up-scale with Dynatrace
description: Demonstrates how to use the self-healing mechanisms of Keptn with Dynatrace
weight: 5
keywords: [self-healing-dynatrace]
aliases:
---
Demonstrates how to use the self-healing mechanisms of Keptn to self-heal a demo service, which runs into issues, by providing automated upscaling.

## About this tutorial

In this tutorial, you will learn how to use the capabilities of Keptn to provide self-healing for an application without modifying code. The following tutorial will scale up the pods of an application if the application undergoes heavy CPU saturation. 

## Prerequisites

- See [Self-healing](../#prerequisites).
- Double-check that you have [Disabled Frequent Issue Detection](../../../reference/monitoring/dynatrace/#disable-frequent-issue-detection) within Dynatrace.

## Configure monitoring

To inform Keptn about any issues in a production environment, monitoring has to be set up. The Keptn CLI helps with the automated setup and configuration of Dynatrace as the monitoring solution running in the Kubernetes cluster. 

To add these files to Keptn and to automatically configure Dynatrace, execute the following commands:

1. Make sure you are in the correct folder of your examples directory:
    ```
    cd examples/onboarding-carts
    ```

1. Configure remediation actions for up-scaling based on Dynatrace alerts:

    ```console
    keptn add-resource --project=sockshop --stage=production --service=carts --resource=remediation.yaml --resourceUri=remediation.yaml
    ```

1. Configure Dynatrace with the Keptn CLI:

    ```console
    keptn configure monitoring dynatrace --project=sockshop
    ```

<details><summary>*Click here to inspect the file that has been added.*</summary>

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

**Configure Dynatrace problem detection with a fixed threshold:** For the sake of this demo, we will configure Dynatrace to detect problems based on fixed thresholds rather than automatically. 

* Log in to your Dynatrace tenant and go to **Settings > Anomaly Detection > Services**.

* Within this menu, select the option **Detect response time degradations using fixed thresholds**, set the limit to **1000ms**, and select **Medium** for the sensitivity as shown below.

{{< popup_image
    link="./assets/anomaly_detection.png"
    caption="Anomaly detection settings"
    width="700px">}}

**Note:** You can configure those fixed thresholds per service instead of globally.

## Run the tutorial


### Generate load for the service

To simulate user traffic that is causing an unhealthy behavior in the carts service, please execute the following script. This will add special items into the shopping cart that cause some extensive calculation.

1. Move to the correct folder:

    ```console
    cd ../load-generation/bin
    ```

1. Start the load generation script depending on your OS (replace \_OS\_ with linux, mac, or win):

    ```console
    ./loadgenerator-_OS_ "http://carts.sockshop-production.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')" cpu
    ```

1. (optional:) Verify the load in Dynatrace

    In your Dynatrace Tenant, inspect the *Response Time* chart of the correlating service entity of the carts microservice. *Hint:* You can find the service 
    in Dynatrace easier by selecting the management tone **Keptn: sockshop production**:

    {{< popup_image
        link="./assets/dt-services.png"
        caption="Select the ItemsController service in the management zone 'Keptn: sockshop production'"
        width="700px">}}
        
    {{< popup_image
        link="./assets/dt_response_time.png"
        caption="Response Time Series"
        width="700px">}}

As you can see in the time series chart, the load generation script causes a significant increase in the response time.

### Watch self-healing in action

After approximately 10-15 minutes, Dynatrace will send out a problem notification because of the response time degradation. 

After receiving the problem notification, the *dynatrace-service* will translate it into a Keptn CloudEvent. This event will eventually be received by the *remediation-service* that will look for a remediation action specified for this type of problem and, if found, execute it.

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

1. Besides, you should see an additional pod running when you execute:

    ```console
    kubectl get pods -n sockshop-production
    ```

    ```console
    NAME                              READY   STATUS    RESTARTS   AGE
    carts-db-57cd95557b-r6cg8         1/1     Running   0          38m
    carts-primary-7c96d87df9-75pg7    2/2     Running   0          33m
    carts-primary-7c96d87df9-78fh2    2/2     Running   0          5m
    ```

1. To get an overview of the actions that got triggered by the response time SLO violation, you can use the Keptn's bridge. You can access it by a port-forward from your local machine to the Kubernetes cluster:

    ```console 
    kubectl port-forward svc/bridge -n keptn 9000:8080
    ```

    Now access the bridge from your browser on http://localhost:9000. 

    In this example, the bridge shows that the remediation service triggered an update of the configuration of the carts service by increasing the number of replicas to 2. When the additional replica was available, the wait-service waited for 10 minutes for the remediation action to take effect. Afterwards, an evaluation by the lighthouse-service was triggered to check if the remediation action resolved the problem. In this case, increasing the number of replicas achieved the desired effect since the evaluation of the service level objectives has been successful.
    
    {{< popup_image
    link="./assets/bridge_remediation.png"
    caption="Keptn's bridge">}}
    
1. Furthermore, you can see how the response time of the service decreased by viewing the time series chart in Dynatrace:

    As previously, go to the response time chart of the *ItemsController* service. Here you will see that the additional instance has helped to bring down the response time.
    Eventually, the problem that has been detected earlier will be closed automatically.

    {{< popup_image
    link="./assets/dt-problem-closed.png"
    caption="Keptn's bridge">}}
