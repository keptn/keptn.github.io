---
title: Onboarding a Service
description: Shows you how to onboard the carts service including its database to a keptn managed project. Besides, this use case builds a new artifact that will be automatically deployed via keptn.
weight: 20
keywords: [onboarding]
aliases:
---

Shows you how to onboard the carts service including its database. Besides, this use case builds a new artifact that will be automatically deployed via keptn.

## About this use case

The goal of this use case is to automatically deploy a service - and new artifacts of this service - into a multi-stage environment using keptn. The stages of the environment are described in a *shipyard* file that defines the name, deployment strategy and test strategy of each stage. In case an additional stage is needed, the shipyard file can be easily extended by a stage definition before creating the project. After creating the project, the service that is going to be managed by keptn needs to be onboarded. Therefore, keptn provides the functionality to create the deployment and service definition of the onboarded service for each stage. 

To illustrate the scenario this use case addresses, keptn relies on two services: github-service and jenkins-service. These services have the following responsibilities: 

**github-service**: 
  
  * Creating a project: When a new project is created, the github service will create a new repository within your configured GitHub organization. This repository will contain the complete configuration of your application, where the configuration for each stage (e.g., the image tags to be used for each service within your application) is located in a separate branch. For the configuration of a keptn-managed app we use [Helm Charts](https://helm.sh/).
  * Onboarding a service: When a new service is onboarded to a project by providing the github service with a manifest file containing the specification for that service, it will be added as a new entry in the `values.yaml` file of your application's helm chart. Further, depending on the deployment strategy of each stage, the github service will also generate a set of Istio configurations (i.e., a Gateway, DestinationRules and VirtualServices) to facilitate blue/green deployments. You can read more about this concept at the [Istio documentation](https://istio.io/docs/concepts/traffic-management/#rule-configuration).
  * Listening to a new artefact event to update the reference to the new artifact in the service configuration. This means, that when a new artefact is pushed to the registry with a new tag, the github service will update the configuration of the application such that this new tag is being used by the respective service.

**jenkins-service**:
  
  * Listening to configuration changed event to deploy a service based on the new configuration.
  * Listening to a deployment finished event to test a freshly deployed service.
  * Listening to evaluation done event to decide whether the deployment can be promoted to the next stage.

## Prerequisites

1. A GitHub organization, user, and personal access token, which are used by keptn.

1. The endpoint and API token provided by the keptn installation.

1. Git clone artifacts for this use case.

    ```console
    $ cd ~
    $ git clone https://github.com/keptn/examples.git
    $ cd ~/examples/onboarding-carts
    ```

## Authenticate and configure keptn

1. The CLI needs to be authenticated against the keptn server. Therefore, please follow the [keptn auth](https://keptn.sh/docs/0.2.0/reference/cli/#keptn-auth) instructions.

1. Configure the used GitHub organization, user, and personal access token using the `keptn configure` command:
  
    ```console
    $ keptn configure --org=<YOUR_GITHUB_ORG> --user=<YOUR_GITHUB_USER> --token=<YOUR_GITHUB_TOKEN>
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

1. Create a new project for your carts service using the `keptn create project` command. In this example, the project is called *sockshop*.

    ```console
    $ ls
    deployment_carts_db.yaml  service_carts_db.yaml  shipyard.yaml  values_carts.yaml  values_carts_db.yaml
    $ keptn create project sockshop shipyard.yaml
    ```

## Onboard carts service and carts database
After creating the project, you are ready to onboard the first service.

1. Onboard the `carts` service using the `keptn onboard service` command. In this onboarding scenario, a default deployment and service template will be provided by the github-service.

    ```console
    $ keptn onboard service --project=sockshop --values=values_carts.yaml
    ```

Since the carts service needs a mongo database, a second app needs to be onboarded.

1. Onboard the `carts-db` service using the `keptn onboard service` command. In this onboarding scenario, the  deployment and service files are handed over to the github-service.

    ```console
    $ keptn onboard service --project=sockshop --values=values_carts_db.yaml --deployment=deployment_carts_db.yaml --service=service_carts_db.yaml
    ```

## Fork carts example into your GitHub organization

1. Go to https://github.com/keptn-sockshop/carts and click on the **Fork** button on the top right corner.

1. Select the Github organization you use for keptn.

## Add CI pipeline to Jenkins

1. Run the `kubectl get svc` command to get the **EXTERNAL-IP** of the Istio ingress gateway.  
    
    ```console
    $ kubectl get svc istio-ingressgateway -n istio-system
    NAME                    TYPE            CLUSTER-IP      EXTERNAL-IP       PORT(S)                            AGE
    istio-ingressgateway    LoadBalancer    10.23.245.***   ***.198.26.***    80:32399/TCP,443:31203/TCP,...     10m
    ``` 

1. Then use a browser to open Jenkins with the url `jenkins.keptn.EXTERNAL-IP.xip.io` and login using the default Jenkins credentials: `admin` / `AiTx4u8VyUV8tCKk`
    
    **Note:** It is highly recommended to change these credentials right after the first login.


1. Afterwards, click on the **New Item** button and enter `carts` as name.

1. Select **Multibranch Pipeline** and click on **OK**.
    1. At *Branch Source* select *Git* and specify at *Project Repository* the github repository of your forked carts service.
    1. At *Build Configurtion* add the extension `.ci` to the Jenkinsfile.

        {{< popup_image
        link="./assets/carts_ci.png"
        caption="CI pipeline configuration for carts">}}

    1. Click Save

## Build new artifact and watch keptn doing the deployment 

1. Saving the Pipeline automatically starts the checkout from your Github repository and triggers the build. In case the build is not triggered, go to **carts** > **master** > **Build Now**.

1. Go back to the Jenkins dashboard to see how the other pipelines get triggered automatically. In detail, after the build of the artifact (`carts` pipeline), the `deploy` pipeline is triggered for the `dev` namespace, `run_tests` is executed, before `evaluation_done` is executed. If everything goes well, the same pipelines get triggered for the `staging` and `production` namespace. In total, the pipelines will run for about 15&nbsp;minutes before you have your `carts` service deployed in your `dev`, `staging` and `production` namespace.

    {{< popup_image
      link="./assets/carts-pipeline.png"
      caption="Successful pipeline run of the carts service">}}

1. Finally, once the carts service is built, this should trigger all other pipelines that have been set up automatically. Please verify the finished pipelines:

    {{< popup_image
      link="./assets/keptn-pipelines.png"
      caption="Successful pipeline runs">}}

1. Verifying the `deploy` pipeline, we can see that the `carts` service has been deployed directly first, while for the subsequent stages, a blue/green deployment has been triggered by keptn.

    {{< popup_image
      link="./assets/deploy-pipeline.png"
      caption="Successful deploy pipeline run">}}

## Troubleshooting

- In rare cases the host is not available at the time when the project is created or a service is onboarded and the resulting response message will look similar to this:

    ```console
    keptn onboard service --project=sockshop --values=values_carts.yaml
    Starting to onboard service
    Onboard service was unsuccessful
    Error: Post https://control.keptn.1xx.xxx.xx.xx.xip.io/service: dial tcp: lookup control.keptn.1xx.xxx.xx.xx.xip.io: no such host
    ``` 

    In this case, please wait a couple of minutes for the server to be ready and try again.
