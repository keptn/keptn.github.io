---
title: Self-healing with Feature Flags
description: Demonstrates how to use the self-healing mechanisms of Keptn to automatically set feature flags in an Unleash feature flag server.
weight: 30
keywords: [self-healing]
aliases:
---
Demonstrates how to use the self-healing mechanisms of Keptn to automatically set feature flags in an Unleash feature flag server.

## About this tutorial

In this tutorial you will learn how to use the capabilities of Keptn to provide self-healing for an application with feature flags based on the [Unleash feature toggle framework](https://unleash.github.io/).

## Prerequisites

- Finish the [Onboarding a Service](../onboard-carts-service/) tutorial.

- Clone the example repository, which contains specification files:

    ```console
    git clone --branch 0.6.0.beta https://github.com/keptn/examples.git --single-branch
    ```

## Onboard and deploy the Unleash server

For the sake of this tutorial, the Unleash server is setup in the same Kubernetes cluster as Keptn, but in fact it does not matter where to run the server, the only requirement is that its API must be available for Keptn. 

1. First, we are going to onboard the Unleash server and its database using the [onboard service](../../reference/cli/#keptn-onboard-service) command:

    ```console
    keptn onboard service unleash-db --project=sockshop --chart=./unleash-db --deployment-strategy=direct
    ```

    ```console
    keptn onboard service unleash --project=sockshop --chart=./unleash --deployment-strategy=direct
    ``` 

2. We can deploy both the database and the actual Unleash server by executing the [keptn send event new-artifact](../../reference/cli/#keptn-send-event-new-artifact) command:

    ```console
    keptn send event new-artifact --project=sockshop --service=unleash-db --image=postgres:10.4
    ```

    ```console
    keptn send event new-artifact --project=sockshop --service=unleash --image=docker.io/jetzlstorfer/unleash-server:0.1
    ```

3. To retrieve the frontend of the Unleash server, visit the URL in the respective namespace by copy and pasting the following commands in your terminal:

    ```console
    echo http://unleash.sockshop-dev.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
    ```

    ```console
    echo http://unleash.sockshop-staging.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
    ```

    ```console
    echo http://unleash.sockshop-production.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
    ```

## Configure the Unleash server

In this tutorial, we are going to introduce feature toggles for two scenarios:

1. Feature flag for a very simple caching mechanism that can speed up the delivery of the website, since it skips the calls to the database but instead replies with static content.

1. Feature flag for a promotion campaign that can be enabled whenever you want to run a promotional campaign on top of your shopping cart.

To set up both feature flags, navigate to your Unleash server in your production environment and log in with *keptn / keptn*. 

1. Again you can find the URL by executing the following command:

    ```console
    echo http://unleash.sockshop-production.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
    ```

2. Click on the red **+** to add a new feature toggle.

    {{< popup_image
        link="./assets/unleash-add.png"
        caption="Add new feature toggle"
        width="700px">}}

3. Name the feature toggle **EnableItemsCache** and add **carts** in the description field.

    {{< popup_image
        link="./assets/unleash-cache.png"
        caption="Add new feature toggle"
        width="700px">}}

4. Create another feature toggle by following the same procedure and by naming it the feature toggle **EnablePromotion** and by adding **carts** in the description field.

    {{< popup_image
        link="./assets/unleash-promotion.png"
        caption="Add new feature toggle"
        width="700px">}}

## Configure Keptn

Now everything is set up in the Unleash server. For Keptn to be able to connect to the Unleash server, we have to add a secret with the Unleash API URL as well as the Unleash tokens. #

1. Execute the following command but replace *xxx* with the actual URL of the Unleash server.

    ```console
    kubectl -n keptn create secret generic unleash --from-literal="UNLEASH_SERVER_URL=http://unleash.sockshop-production/api" --from-literal="UNLEASH_USER=keptn" --from-literal="UNLEASH_TOKEN=keptn"
    ```

2. Keptn has to be aware of the new secret and have to load it for it to connect to the Unleash server to set the feature toggles. Therefore, the remediation service must be restarted:

    ```console
    kubectl delete pod -l=run=remediation-service -n keptn
    ```

3. Finally, remediation instructions in case something goes wrong have to be added to Keptn.

    ```console
    keptn add-resource --project=sockshop --service=carts --stage=production --resource=remediation.yaml --resourceUri=remediation.yaml
    ```

**Note:** The file holds the following content, which is a declarative way to define remediation actions in response to problems/alerts that are sent to Keptn.
    
```yaml
remediations:
- name: cpu_usage
actions:
- action: scaling
    value: +1
- name: "Response time degradation"
actions:
- action: featuretoggle
    value: EnableItemCache:on
- name: "Failure rate increase"
actions:
- action: featuretoggle
    value: EnablePromotion:off
```

Now everything is set up, next we are going to hit the application with some load and toggle the feature flags.

## Run the tutorial

In order to simulate user traffic, we are going to execute the following script that will constantly add items to the shopping cart.

1. Move to the folder with the load generation program. 
    ```console
    cd ../load-generation/bin
    ```

2. Start the according load generation program depending on your operating system (replace *_OS_ with either *linux, mac* or *win*).
    ```console
    ./loadgenerator-_OS_ "http://carts.sockshop-production.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')" 
    ```

3. Now go back to your Unleash server in your browser. In this tutorial we are going to turn on the promotional campaign, which purpose is to add promotional gifts to about 30&nbsp;% of the user interactions that put items in their shopping cart. 

4. Click on the toggle next to **EnablePromotion** to enable this feature flag.

    {{< popup_image
        link="./assets/unleash-promotion-toggle-on.png"
        caption="Enable feature toggle"
        width="700px">}}

5. In the output of the load generation program you should see that now errors in terms of exceptions are shown. Taking a closer look will tell you that the promotional campaign has actually never been implemented. After a couple of minutes, the monitoring tool will detect an increase of the failure rate and will send out a problem notification to Keptn.

6. Keptn will receive the problem notification/alert and look for a remediation action that matches this problem. Since we have added the `remediation.yaml` before, Keptn will find a remediation action and will trigger the corresponding action that will disable the feature flag.

## Summary

In this tutorial, you have seen how Keptn can be configured to automatically toggle feature flags in your Unleash server in response to a problem/alert sent by a monitoring solution. 