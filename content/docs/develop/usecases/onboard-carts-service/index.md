---
title: Onboarding a Service
description: Shows you how to onboard the carts service including its database to a keptn managed project. Besides, this use case builds a new artifact that will be automatically deployed via keptn.
weight: 20
keywords: [onboarding]
aliases:
---

This use case shows how to onboard the carts service including its database. Besides this, a new artifact will be automatically deployed by keptn.

## About this use case

The goal of this use case is to automatically deploy a service into a multi-stage environment using keptn. The stages of the environment are described in a *shipyard* file that defines the name, deployment strategy, and test strategy of each stage. In case an additional stage is needed, the shipyard file can be easily extended by a stage definition before creating the project. After creating the project, the service that is going to be managed by keptn needs to be onboarded. Therefore, keptn provides the functionality to create the deployment and service definition of the onboarded service for each stage. Finally, an artifact of the carts service will be deployed by keptn.  

To illustrate the scenario this use case addresses, keptn relies on the following services: *shipyard-service*, *helm-service*, *jmeter-service*, and *gatekeeper-service*. These services have the following responsibilities: 

**shipyard-service:** 
  
  * Creates a project entity and stage entities as declared in the shipyard. 

 **helm-service**:
  
  * Creates a new service entity, manipulates the Helm chart, and uploades the Helm chart to the configuration store.

  * Updates the service configuration when a new artifact is available.

  * Deploys a service when the configuration of a service has changed.

**jmeter-service**:

  * Runs a test when a new deployment of the service is available. 

**gatekeeper-service**:

  * Evaluates the test result to decide whether the deployment can be promoted to the next stage or not.

## Prerequisites
<!--
1. A GitHub organization, user, and personal access token, which are used by keptn.
-->
* The endpoint and API token provided by the keptn installation.

* Clone example files used for this use case:

    ```console
    git clone --branch 0.5.0 https://github.com/keptn/examples.git --single-branch
    cd examples/onboarding-carts
    ```

## Authenticate and configure keptn

If you have not yet authenticated and configured the keptn CLI, please follow these instructions. If you have already done this [during the installation](../../installation/setup-keptn-gke/#authenticate-keptn-cli-and-configure-keptn), please skip this part and continue with [creating a project](#create-project-sockshop).

The keptn CLI needs to be authenticated against the keptn server. Therefore, please follow the [keptn auth](../../reference/cli/#keptn-auth) instructions.

```console
keptn auth --endpoint=https://api.keptn.$(kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain}) --api-token=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
```

## Create project sockshop

For creating a project, this use case relies on the `shipyard.yaml` file shown below:

```yaml
stages:
  - name: "dev"
    deployment_strategy: "direct"
    test_strategy: "functional"
  - name: "staging"
    deployment_strategy: "blue_green_service"
    test_strategy: "performance"
  - name: "production"
    deployment_strategy: "blue_green_service"
```

Create a new project for your carts service using the [keptn create project](../../reference/cli/#keptn-create-project) command. In this example, the project is called *sockshop*. Before executing the following command, 
make sure you are in the folder `examples/onboarding-carts`.

```console
keptn create project sockshop shipyard.yaml
```

## Onboard carts service and carts database
After creating the project, you are ready to onboard the first services.

* Onboard the `carts` service using the [keptn onboard service](../../reference/cli/#keptn-onboard-service) command:

  ```console
  keptn onboard service carts --project=sockshop --chart=carts-0.1.0.tgz
  ```

* After onboarding the service, a couple of tests need to be added to its configuration for testig it in the different stages:

  ```console
  keptn add-resource --project=sockshop --service=carts --stage=dev --resource=jmeter/basiccheck.jmx
  ```

  ```console
  keptn add-resource --project=sockshop --service=carts --stage=dev --resource=jmeter/load.jmx
  ```

  ```console
  keptn add-resource --project=sockshop --service=carts --stage=staging --resource=jmeter/basiccheck.jmx
  ```

  ```console
  keptn add-resource --project=sockshop --service=carts --stage=staging --resource=jmeter/load.jmx
  ```

Since the carts service requires a mongodb database, a second service needs to be onboarded.

* Onboard the `carts-db` service using the [keptn onboard service](../../reference/cli/#keptn-onboard-service) command:

  ```console
  keptn onboard service carts-db --project=sockshop --chart=carts-db-0.1.0.tgz
  ```

<!--
Note, by onboarding a service without specifying a deployment file, we automatically include a [readiness and liveness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/). Therefore, we assume that the onboarded service has an endpoint `/health` on the internal port 8080. This is true for the `carts` service used in this use case. In case you would like to onboard your own service, please ensure that your service has an endpoint `health`, which can be used or define your own [readiness and liveness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/)
in the deployment.
-->

## Send a new artifact and watch keptn doing the deployment 

* Send a new artifact event for the carts service using the [keptn send event new-artifact](../../reference/cli/#keptn-send-event-new-artifact) command.
The used artifact is stored on Docker Hub. 
  ```console
  keptn send event new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.8.1
  ```

* Go to the keptn's bridge and check which events have already been generated. You can access it by a port-forward from your local machine to the Kubernetes cluster:
  ```console 
  kubectl port-forward svc/bridge -n keptn 9000:8080
  ```

* Now access the bridge from your browser on http://localhost:9000. 
  
  > **_NOTE:_**  Keptn's bridge is available via GCP cloud shell. Click the "Web Preview" button, change the port to `9000` and view.
  
  The keptn's bridge shows all deployments that have been triggered. On the left-hand side you can see the deployment start events, such as the one that is selected. Over time, more and more events will show up in keptn's bridge to allow you to check what is going on in your keptn installation. Please note that if events happen at the same time, their order in the keptn's bridge might be arbitrary since they are only sorted on the granularity of one second. 

    {{< popup_image
      link="./assets/bridge.png"
      caption="keptn's bridge">}}

## View carts service

- Get the URL for your carts service with the following commands in the respective namespaces:

  ```console
  echo http://carts.sockshop-dev.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
  echo http://carts.sockshop-staging.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
  echo http://carts.sockshop-production.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
  ```

Navigate to the URLs to inspect your carts service. In the production namespace, you should receive an output similar to this:

  {{< popup_image
    link="./assets/carts-production.png"
    caption="carts service in production"
    width="50%">}}
