---
title: Onboarding a Service
description: Shows you how to onboard the carts service including its database to a keptn managed project. Besides, this use case builds a new artifact that will be automatically deployed via keptn.
weight: 20
keywords: [onboarding]
aliases:
---

This use case shows how to onboard the carts service including its database. Besides this, a new artifact will be automatically deployed via keptn.

## About this use case

The goal of this use case is to automatically deploy a service into a multi-stage environment using keptn. The stages of the environment are described in a *shipyard* file that defines the name, deployment strategy and test strategy of each stage. In case an additional stage is needed, the shipyard file can be easily extended by a stage definition before creating the project. After creating the project, the service that is going to be managed by keptn needs to be onboarded. Therefore, keptn provides the functionality to create the deployment and service definition of the onboarded service for each stage. Finally, an artifact of the carts service will be deployed by keptn.  

To illustrate the scenario this use case addresses, keptn relies on the following services: github-service, helm-service, jmeter-service, and gatekeeper-service. These services have the following responsibilities: 

**github-service**: 
  
  * Creating a project: When a new project is created, the github service will create a new repository within your configured GitHub organization. This repository will contain the complete configuration (e.g., the image tags to be used for each service within your application) of your application, where the configuration for each stage is located in a separate branch. For the configuration of a keptn-managed app we use [Helm Charts](https://helm.sh/).
  * Onboarding a service: When a new service is onboarded to a project (here a manifest file containing the specification for that service is required), the github service will add the service as a new entry in the `values.yaml` file of your application's helm chart. Further, depending on the deployment strategy of each stage, the github service will also generate a set of Istio configurations (i.e., a Gateway, DestinationRules, and VirtualServices) to facilitate blue/green deployments. You can read more about this concept at the [Istio documentation](https://istio.io/docs/concepts/traffic-management/#rule-configuration).
  * Listening to a new artifact event: When the github service receives a new artifact event, it updates the reference to the new artifact in the service configuration. By this, the new image is used for the respective service.

**helm-service**:
  
  * Listening to configuration changed events to deploy a service using the new configuration.

**jmeter-service**:

  * Listening to deployment finished events to test a newly deployed service using jmeter.

**gatekeeper-service**:

  * Listening to evaluation done events to decide whether the deployment can be promoted to the next stage or not.

## Prerequisites

1. A GitHub organization, user, and personal access token, which are used by keptn.

1. The endpoint and API token provided by the keptn installation.

1. Git clone artifacts for this use case.

    ```console
    git clone --branch 0.2.0 https://github.com/keptn/examples.git --single-branch
    cd examples/onboarding-carts
    ```
1. Fork carts example into your GitHub organization
  - Go to https://github.com/keptn-sockshop/carts and click on the **Fork** button on the top right corner.
  - Select the GitHub organization you use for keptn.
  - Clone the forked carts service to your local machine. Please note that you have to use your own GitHub organization.
  
    ```console
      git clone https://github.com/your-github-org/carts.git
    ```

## Authenticate and configure keptn

If you have not yet authenticated and configured the keptn CLI, please follow these instructions. If you have already done this [during the installation](../../installation/setup-keptn-gke/#authenticate-keptn-cli-and-configure-keptn), please skip this part and continue with [creating a project](#create-project-sockshop).

1. The CLI needs to be authenticated against the keptn server. Therefore, please follow the [keptn auth](../../reference/cli/#keptn-auth) instructions.

    ```console
    keptn auth --endpoint=https://api.keptn.$(kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain}) --api-token=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
    ```

1. Configure the used GitHub organization, user, and personal access token using the [keptn configure](../../reference/cli/#keptn-configure) command:
  
    ```console
    keptn configure --org=<YOUR_GITHUB_ORG> --user=<YOUR_GITHUB_USER> --token=<YOUR_GITHUB_TOKEN>
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

- Create a new project for your carts service using the [keptn create project](../../reference/cli/#keptn-create-project) command. In this example, the project is called *sockshop*. Before executing the following command, 
make sure you are in the folder `examples/onboarding-carts`.

  ```console
  keptn create project sockshop shipyard.yaml
  ```

## Onboard carts service and carts database
After creating the project, you are ready to onboard the first services.

- Onboard the `carts` service using the [keptn onboard service](../../reference/cli/#keptn-onboard-service) command. In this onboarding scenario, a default deployment and service template will be provided by the github-service.

  ```console
  keptn onboard service --project=sockshop --values=values_carts.yaml
  ```

Since the carts service needs a mongo database, a second service needs to be onboarded.

- Onboard the `carts-db` service using the [keptn onboard service](../../reference/cli/#keptn-onboard-service) command. In this onboarding scenario, the  deployment and service files are handed over to the github-service.

  ```console
  keptn onboard service --project=sockshop --values=values_carts_db.yaml --deployment=deployment_carts_db.yaml --service=service_carts_db.yaml
  ```

Note, by onboarding a service without specifying a deployment file, we automatically include a [readiness and liveness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/). Therefore, we assume that the 
onboarded service has an endpoint `/health` on the internal port 8080. This is true for the `carts` service used in this use case.
In case you would like to onboard your own service, please ensure that your service has an endpoint `health`, which can be used or
define your own [readiness and liveness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/)
in the deployment.

## Send a new artifact and watch keptn doing the deployment 

1. Send a new artifact event for the carts service using the [keptn send event new-artifact](../../reference/cli/#keptn-send-event-new-artifact) command.
The used artifact is stored on Docker Hub. 
  ```console
  keptn send event new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.8.1
  ```

1. Go to the keptn's bridge and check which events have already been generated. You can access it by a port-forward from your local machine to the Kubernetes cluster:
  ```console 
  kubectl port-forward svc/$(kubectl get ksvc bridge -n keptn -ojsonpath={.status.latestReadyRevisionName})-service -n keptn 9000:80
  ```
  Now access the bridge from your browser on http://localhost:9000. 
  \\
  \\
  The keptn's bridge shows all deployments that have been triggered. On the left-hand side you can see the deployment start events, such as the one that is selected. Over time, more and more events will show up in keptn's bridge to allow you to check what is going on in your keptn installation. Please note that if events happen at the same time, their order in the keptn's bridge might be arbitrary since they are only sorted on the granularity of one second. 

    {{< popup_image
      link="./assets/bridge.png"
      caption="keptn's bridge">}}

<details><summary>Known issue for AKS installations</summary>
<p>
In AKS, the first functional check erroneously fails. Therefore, the artifact is not promoted into staging and production.
We are addressing this bug in the [issue #483](https://github.com/keptn/keptn/issues/483).

In order to pass this functional check, 
please re-send a new artifact event for the carts service.
  ```console
  keptn send event new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.8.1
  ```
 </p>
</details>

## View carts service

- Run the following command to get the **EXTERNAL-IP** and **PORT** of your cluster's ingress gateway.
    
  ```console    
  kubectl get svc istio-ingressgateway -n istio-system
  ```

  ```console
  NAME                     TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)
  istio-ingressgateway     LoadBalancer   10.11.246.127   <EXTERNAL_IP>   80:32399/TCP 
  ```

- Navigate to `http://carts.sockshop-production.<EXTERNAL IP>.xip.io` for viewing the carts service in your `production` environment. 

## Onboard your own service

When onboarding your own service instead of the provided `carts` service, a values file _has_ to be provided. In addition, a service and a deployment file _can_ be provided.
The following snippet will help to define your own `values.yaml` file:

```yaml
replicaCount: 1
image:
    repository: null
    tag: null
    pullPolicy: IfNotPresent
service:
    name: myservice 
    internalPort: 8080
container:
    name: myservice
```

First, define how many instances of your deployment should be running by providing this number as the `replicaCount`. Next, the `image repository` and `tag` can be set to null since they will be set with the keptn CLI command `keptn send event new-artifact`. For the `service`, simply provide the name of your service as well as the internal port you want your service to be reachable. For the `container name` simply provide a name you want to call your container. Additionally, make sure that your actual service provides a `/health` endpoint at port `8080` since this is needed for the [liveness and readiness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/) for Kubernetes.
If you already have your service.yaml and deployment.yaml file, your can easily reuse them with keptn by attaching them in the onboarding command: 

```console
keptn onboard service --project=sockshop --values=VALUES.yaml --deployment=DEPLOYMENT.yaml --service=SERVICE.yaml
```

Furthermore, keptn needs to have access to the `perfspec.json` file as well as the JMeter files. Therefore, fork the GitHub repo of your service into the GitHub organization that you have created earlier.
Make sure in your repository there are the needed files in the corresponding folders:
```
SERVICENAME
│  README.md
│  ...    
│
└── jmeter
│   │   basiccheck.jmx
│   │   SERVICENAME_load.jmx
│   │   SERVICENAME_perfcheck.jmx
│   
└── perfspec
│   │   perfspec.json
│
└── src
└── ...
```

Please note that all subsequent use cases described on this website do require the onboarded `carts` service to work out-of-the-box. 


## Delete a project

**Please note,** if you want to continue with other use cases, please **do not execute** the following commands.

The keptn CLI does currently not support the deletion of a project. However, by following the next steps, a project can manually be removed:

- Delete the GitHub repository for your project, e.g., sockshop.
- Delete all namespaces that have been created by keptn in your Kubernetes cluster, e.g.,
  - sockshop-dev
  - sockhop-staging
  - sockshop-production
  
    by executing

  ```console
  kubectl delete namespace sockshop-dev sockshop-staging sockshop-production
  ```

- Delete the configuration map `keptn-orgs` that has been created by executing

```console
kubectl delete configmap keptn-orgs -n keptn
```
