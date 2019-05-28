---
title: Onboarding a Service
description: Shows you how to onboard the carts service including its database to a keptn managed project. Besides, this use case builds a new artifact that will be automatically deployed via keptn.
weight: 20
keywords: [onboarding]
aliases:
---

Shows you how to onboard the carts service including its database. Besides, this a new artifact will be automatically deployed via keptn.

## About this use case

The goal of this use case is to automatically deploy a service - and new artifacts of this service - into a multi-stage environment using keptn. The stages of the environment are described in a *shipyard* file that defines the name, deployment strategy and test strategy of each stage. In case an additional stage is needed, the shipyard file can be easily extended by a stage definition before creating the project. After creating the project, the service that is going to be managed by keptn needs to be onboarded. Therefore, keptn provides the functionality to create the deployment and service definition of the onboarded service for each stage. 

To illustrate the scenario this use case addresses, keptn relies on two services: github-service and jenkins-service. These services have the following responsibilities: 

**github-service**: 
  
  * Creating a project: When a new project is created, the github service will create a new repository within your configured GitHub organization. This repository will contain the complete configuration (e.g., the image tags to be used for each service within your application) of your application, where the configuration for each stage is located in a separate branch. For the configuration of a keptn-managed app we use [Helm Charts](https://helm.sh/).
  * Onboarding a service: When a new service is onboarded to a project by providing a manifest file containing the specification for that service, the github service will add the service as a new entry in the `values.yaml` file of your application's helm chart. Further, depending on the deployment strategy of each stage, the github service will also generate a set of Istio configurations (i.e., a Gateway, DestinationRules, and VirtualServices) to facilitate blue/green deployments. You can read more about this concept at the [Istio documentation](https://istio.io/docs/concepts/traffic-management/#rule-configuration).
  * Listening to a new artifact event: When the github service receives a new artifact event, it updates the reference to the new artifact in the service configuration. By this, the new image is used by the respective service.

**jenkins-service**:
  
  * Listening to configuration changed events to deploy a service based on the new configuration.
  * Listening to deployment finished events to test a freshly deployed service.
  * Listening to evaluation done events to decide whether the deployment can be promoted to the next stage.

## Prerequisites

1. A GitHub organization, user, and personal access token, which are used by keptn.

1. The endpoint and API token provided by the keptn installation.

1. Git clone artifacts for this use case.

    ```console
    git clone https://github.com/keptn/examples.git
    cd examples/onboarding-carts
    ```

## Authenticate and configure keptn

If you have not yet authenticated and configured the keptn CLI, please follow these instructions. If you have already done this [during the installation](../../installation/setup-keptn-gke/#authenticate-keptn-cli-and-configure-keptn), please skip this part and continue with [creating a project](#create-project-sockshop).

1. The CLI needs to be authenticated against the keptn server. Therefore, please follow the [keptn auth](../../reference/cli/#keptn-auth) instructions.

    ```console
    keptn auth --endpoint=https://$(kubectl get ksvc -n keptn control -o=yaml | yq r - status.domain) --api-token=$(kubectl get secret keptn-api-token -n keptn -o=yaml | yq - r data.keptn-api-token | base64 --decode)
    ```

1. Configure the used GitHub organization, user, and personal access token using the [keptn configure](../../reference/cli/#keptn-configure) command:
  
    ```console
    keptn configure --org=<YOUR_GITHUB_ORG> --user=<YOUR_GITHUB_USER> --token=<YOUR_GITHUB_TOKEN>
    ```

## Create project sockshop

For creating a project, this use case relies on the `shipyard.yaml` file shown below:

```yaml
registry: sockshop
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

1. Create a new project for your carts service using the [keptn create project](../../reference/cli/#keptn-create-project) command. In this example, the project is called *sockshop*. Before executing the following command, 
make sure you are in the folder `examples/onboarding-carts`.

    ```console
    keptn create project sockshop shipyard.yaml
    ```

## Onboard carts service and carts database
After creating the project, you are ready to onboard the first service.

1. Onboard the `carts` service using the [keptn onboard service](../../reference/cli/#keptn-onboard-service) command. In this onboarding scenario, a default deployment and service template will be provided by the github-service.

    ```console
    keptn onboard service --project=sockshop --values=values_carts.yaml
    ```

Since the carts service needs a mongo database, a second app needs to be onboarded.

1. Onboard the `carts-db` service using the [keptn onboard service](../../reference/cli/#keptn-onboard-service) command. In this onboarding scenario, the  deployment and service files are handed over to the github-service.

    ```console
    keptn onboard service --project=sockshop --values=values_carts_db.yaml --deployment=deployment_carts_db.yaml --service=service_carts_db.yaml
    ```

Note, by onboarding a service without specifying a deployment file, we automatically include a [readiness and liveness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/). Therefore, we assume that the 
onboarded service has an endpoint `/health` on the internal port 8080. This is true for the `carts` service used in this use case.
In case you would like to onboard your own service, please ensure that your service has an endpoint `health` which can be used or
define your own [readiness and liveness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/)
in the deployment.

## Send a new artifact and watch keptn doing the deployment 

1. Send a new artifact for the carts service using the [keptn send event new-artifact](../../reference/cli/#keptn-send-event-new-artifact) command.
The used artifact is stored on Docker Hub. 
  ```console
  keptn send event new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.8.0
  ```
  
1. Go back to the Jenkins dashboard to see how the pipelines get triggered automatically. More precisely, first, the `deploy` pipeline is triggered for the `dev` namespace, second, the `run_tests` is executed, and finally, `evaluation_done` is executed. If all pipelines succeed, the same pipelines get triggered for the `staging` and `production` namespace. In total, the pipelines will run for about 15&nbsp;minutes before you have your `carts` service deployed in your `dev`, `staging`, and `production` namespaces.

    {{< popup_image
      link="./assets/keptn-pipelines.png"
      caption="Successful pipeline runs">}}

1. For example, for verifying the `deploy` pipeline, we can see that the `carts` service has been deployed directly first, while for the subsequent stages, a blue/green deployment has been triggered by keptn.

    {{< popup_image
      link="./assets/deploy-pipeline.png"
      caption="Successful deploy pipeline run">}}

## View Carts Service
 Navigate to `http://carts.sockshop-production.<EXTERNAL IP>.xip.io` to view the carts service.