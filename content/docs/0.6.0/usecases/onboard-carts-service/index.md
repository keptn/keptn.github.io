---
title: Onboarding a Service
description: Shows you how to onboard the carts service including its database to a Keptn-managed project. Besides, this tutorial shows how to deploy  a new version of carts via Keptn.
weight: 20
keywords: [onboarding]
aliases:
---

Shows you how to onboard the carts service including its database to a Keptn-managed project. Besides, this tutorial shows how to deploy  a new version of carts via Keptn.

## About this tutorial

The goal of this tutorial is to automatically deploy a service into a multi-stage environment using Keptn. The stages of the environment are described in a *shipyard* file that defines the name, deployment strategy, and test strategy of each stage. After creating the project, the service that is going to be managed by Keptn needs to be onboarded. Finally, an artifact of the carts service will be deployed by Keptn.  

<details><summary>*Click here to learn more about Keptn internal services for this tutorial.*</summary>
<p>
To illustrate the scenario this tutorial addresses, Keptn relies on following internal services: *shipyard-service*, *helm-service*, *jmeter-service*, and *gatekeeper-service*. These services have the following responsibilities: 

**shipyard-service:** 
  
  * Creates a project entity and stage entities as declared in the shipyard. 

 **helm-service**:
  
  * Creates a new service entity, duplicates the provided Helm chart, and uploads the Helm chart to the configuration store.

  * Updates the service configuration when a new artifact is available.

  * Deploys a service when the configuration of a service has changed.

**jmeter-service**:

  * Runs a test when a new deployment of the service is available. 

**gatekeeper-service**:

  * Evaluates the test result to decide whether the deployment can be promoted to the next stage or not.

 </p>
</details>

## Prerequisites

* The endpoint and API token provided by the Keptn installation.

* Clone example files used for this tutorial:

    ```console
    git clone --branch 0.6.1 https://github.com/keptn/examples.git --single-branch
    ```

    ```console
    cd examples/onboarding-carts
    ```

## Authenticate Keptn CLI

If you have not yet authenticated the Keptn CLI, please follow these instructions. If you have already done this [during the installation](../../installation/setup-keptn/#install-keptn), please skip this part and continue with [creating a project](#create-project-sockshop).

* The Keptn CLI needs to be authenticated against the Keptn server by executing the [auth](../../reference/cli/#keptn-auth) command:

    ```console
    keptn auth --endpoint=https://api.keptn.$(kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain}) --api-token=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
    ```

## Create project sockshop

For creating a project, this tutorial relies on the `shipyard.yaml` file shown below:

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
    remediation_strategy: "automated"
```

<details>
<summary>*Click here for a short explanation of this shipyard file.*</summary>
<p>
This shipyard contains three stages: dev, staging, and production. This results in the three Kubernetes namespaces: sockshop-dev, sockshop-staging, and sockshop-production.

* **dev** will have a direct (big bang) deployment strategy and functional tests are executed
* **staging** will have a blue/green deployment strategy and performance tests are executed
* **production** will have a blue/green deployment strategy without any further testing. The configured remediation strategy is used for the [Self-healing with Keptn](../self-healing-with-keptn/) tutorial.

</p>
</details>

**Note:**  To learn more about a *shipyard* file, please take a look at the [Shipyard specification](https://github.com/keptn/spec/blob/0.1.3/shipyard.md).

Create a new project for your services using the [keptn create project](../../reference/cli/#keptn-create-project) command. In this example, the project is called *sockshop*. Before executing the following command, make sure you are in the `examples/onboarding-carts` folder.

Create a new project without Git upstream:
```console
keptn create project sockshop --shipyard=./shipyard.yaml
```

<details><summary>**Optional:** Create a new project with Git upstream</summary>
<p>

To configure a Git upstream for this tutorial, the Git user (`--git-user`), an access token (`--git-token`), and the remote URL (`--git-remote-url`) are required. If a requirement is not met, go to [select Git-based upstream](../../manage/project/#select-git-based-upstream) where instructions for GitHub, GitLab, and Bitbucket are provided.

```console
keptn create project sockshop --shipyard=./shipyard.yaml --git-user=GIT_USER --git-token=GIT_TOKEN --git-remote-url=GIT_REMOTE_URL
```
</p>
</details>

## Onboard carts service and carts database
After creating the project, services can be onboard to this project.

* Onboard the **carts** service using the [keptn onboard service](../../reference/cli/#keptn-onboard-service) command:

```console
keptn onboard service carts --project=sockshop --chart=./carts
```

* After onboarding the service, tests (i.e., functional- and performance tests) need to be added as basis for quality gates in the different stages:

  * Functional tests for *dev* stage:

    ```console
    keptn add-resource --project=sockshop --stage=dev --service=carts --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    ```

  * Performance tests for *staging* stage:

    ```console
    keptn add-resource --project=sockshop --stage=staging --service=carts --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx
    ```

  **Note:** You can adapt the tests in `basiccheck.jmx` as well as `load.jmx` for your service. However you must not rename the files, as there is a hardcoded dependency on these file names in the current implementation of Keptn's jmeter-service. 

Since the carts service requires a mongodb database, a second service needs to be onboarded.

* Onboard the **carts-db** service using the [keptn onboard service](../../reference/cli/#keptn-onboard-service) command. The `--deployment-strategy` flag specifies that for this service a *direct* deployment strategy in all stages should be used regardless of the deployment strategy specified in the shipyard. Thus, the database is not blue/green deployed.

```console
keptn onboard service carts-db --project=sockshop --chart=./carts-db --deployment-strategy=direct
```

During the onboarding of the services, Keptn creates a namespace for each stage based on the pattern: `projectname-stagename`.

* To verify the new namespaces, execute the following command:

```console
kubectl get namespaces
```

```console
NAME                  STATUS   AGE
...
sockshop-dev          Active   2m16s
sockshop-production   Active   2m16s
sockshop-staging      Active   2m16s
```

## Send new artifacts and watch Keptn doing the deployment 

After onboarding the services, a built artifact of each service can be deployed.

* Deploy the carts-db service by executing the [keptn send event new-artifact](../../reference/cli/#keptn-send-event-new-artifact) command:

```console
keptn send event new-artifact --project=sockshop --service=carts-db --image=mongo --tag=4.2.2
```

* Deploy the carts service by specifying the built artifact, which is stored on DockerHub and tagged with version 0.10.1:

```console
keptn send event new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.10.1
```

* Go to Keptn's Bridge and check which events have already been generated. You can access it by a port-forward from your local machine to the Kubernetes cluster:

```console 
kubectl port-forward svc/bridge -n keptn 9000:8080
```

* The Keptn's Bridge is then available on: http://localhost:9000. 

    It shows all deployments that have been triggered. On the left-hand side, you can see the deployment start events (i.e., so-called `Configuration change` events). During a deployment, Keptn generates events for controlling the deployment process. These events will also show up in Keptn's Bridge. Please note that if events are sent at the same time, their order in the Keptn's Bridge might be arbitrary since they are sorted on the granularity of one second. 

    {{< popup_image
      link="./assets/bridge.png"
      caption="Keptn's Bridge">}}

* **Optional:** Verify the pods that should have been created for services carts and carts-db:

```console
kubectl get pods --all-namespaces | grep carts
```

```console
sockshop-dev          carts-77dfdc664b-25b74                            1/1     Running     0          10m
sockshop-dev          carts-db-54d9b6775-lmhf6                          1/1     Running     0          13m
sockshop-production   carts-db-54d9b6775-4hlwn                          2/2     Running     0          12m
sockshop-production   carts-primary-79bcc7c99f-bwdhg                    2/2     Running     0          2m15s
sockshop-staging      carts-db-54d9b6775-rm8rw                          2/2     Running     0          12m
sockshop-staging      carts-primary-79bcc7c99f-mbbgq                    2/2     Running     0          7m24s
```

## View carts service

- Get the URL for your carts service with the following commands in the respective namespaces:

```console
echo http://carts.sockshop-dev.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
```
```console
echo http://carts.sockshop-staging.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
```
```console
echo http://carts.sockshop-production.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
```

- Navigate to the URLs to inspect the carts service. In the production namespace, you should receive an output similar to this:

    {{< popup_image
    link="./assets/carts-production.png"
    caption="carts service in production"
    width="50%">}}
