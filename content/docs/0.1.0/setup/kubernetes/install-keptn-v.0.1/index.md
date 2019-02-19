---
title: Install keptn v.0.1 on GKE
description: Demonstrates how to install keptn in a Kubernetes cluster on Google Container Engine (GKE). 
weight: 37
keywords: [kubernetes, install]
---

To install and configure keptn in a Kubernetes cluster, follow these instructions:

## Step 1: Prerequisites

The next steps expect that you have a working Kubernetes cluster in Google Container Engine (GKE). See the [Getting Started Guides](https://kubernetes.io/docs/setup/) for details about creating a cluster with the folllowing configuration: 
    
- Master version 1.11.6 (minimum tested master version 1.10.11)
- Node pool with 2 nodes:
    - each 8vCPUs and 30 GB memory (`n1-standard-8` in GKE)
    - image type: Ubuntu (**preferred**) or *Container-Optimized OS (cos)*
    
        **Note 1:** To select Ubuntu, click on the "Advanced Edit" button in GKE and select "Ubuntu" as the Image Type in the Nodes section.
        
        **Note 2:** If *Container-Optimized OS (cos)* is selected, make sure to [follow the instructions](https://www.dynatrace.com/support/help/cloud-platforms/google-cloud-platform/google-kubernetes-engine/deploy-oneagent-on-google-kubernetes-engine-clusters/#expand-134parameter-for-container-optimized-os-early-access) for setting up the Dynatrace OneAgent Operator. This means that after the initial setup with `setupInfrastructure.sh`, which is a step below, the `cr.yml` has to be edited and applied again. In addition, all pods have to be restarted.

The scripts provided by keptn v.0.1 run in a BASH and require following tools locally installed: 

- [jq](https://stedolan.github.io/jq/) which is a lightweight and flexible command-line JSON processor.
- [git](https://git-scm.com/) and [hub](https://hub.github.com/) that helps you do everyday GitHub tasks without ever leaving the terminal.
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) that is logged in to your cluster.

    **Tip:** View all the kubectl commands, including their options and descriptions in the [kubectl CLI reference](https://kubernetes.io/docs/user-guide/kubectl-overview/).

Additionally, the scripts need:

- `GitHub organization` to store the repositories of the sockshop application
- `GitHub personal access token` to push changes to the sockshop repositories
- Dynatrace Tenant including the Dynatrace `Tenant ID`, a Dynatrace `API Token`, and Dynatrace `PaaS Token`. If you don't have a Dynatrace tenant yet, sign up for a [free trial](https://www.dynatrace.com/trial/) or a [developer account](https://www.dynatrace.com/developer/).

    **Note:** The `API Token` must have the permissions as shown in the screenshot below:

    {{< popup_image
    link="./assets/dt_api_token.png"
    caption="Dynatrace API token">}}

## Step 2: Download and prepare for the installation

1. Go to the [keptn release](https://github.com/keptn/keptn/archive/0.1.0.tar.gz) page to download the installation file using, e.g., `wget`:
    ```console
    $ cd ~
    $ wget https://github.com/keptn/keptn/archive/0.1.0.tar.gz
    ```

1. Extract the package and move to the keptn directory:

    ```console
    $ tar -xvzf 0.1.0.tar.gz 
    $ cd keptn-0.1.0
    ```

## Step 3: Provision cluster on Kubernetes

Keptn contains all scripts and instructions needed to deploy the demo application *Sockshop* on a Kubernetes cluster.

1. Execute the `forkGitHubRepositories.sh` script in the `scripts` directory. This script takes the name of the GitHub organization you have created earlier. This script clones all needed repositories and uses `hub` to fork those repositories to the passed GitHub organization. Afterwards, the script deletes all repositories and clones them again from the GitHub organization.

    ```console
    $ cd ~/keptn/scripts/
    $ ./forkGitHubRepositories.sh <GitHubOrg>
    ```
    
1. Insert information in *./scripts/creds.json* by executing `defineCredentials.sh` in the `scripts` directory. This script will prompt you for all information needed to complete the setup and populate the file *scripts/creds.json* with them. 

    **Attention:** This file will hold your personal access-token and credentials needed for the automatic setup of keptn. Take care of not leaking this file! (As a first precaution we have added this file to the `.gitignore` file to prevent committing it to GitHub.)

    ```console
    $ ./defineCredentials.sh
    ```
    
1. Execute `setupInfrastructure.sh` in the `scripts` directory. This script deploys a container registry and Jenkins service within your cluster, as well as an initial deployment of the sockshop application in the *dev*, *staging*, and *production* namespaces. Please note that this is an initial step to provide you with running services in all three environments. In the course of the different use cases provided by keptn, the microservices will be built and deployed by the Jenkins pipelines set up by keptn. 

    **Attention:** The script will create several new resources for you and will also update the files shipped with keptn. Take care of not leaking any files that will hold personal information. Including:
        
    - `manifests/dynatrace/cr.yml`
    - `manifests/istio/service_entries.yml`
    - `manifests/jenkins/k8s-jenkins-deployment.yml`

    **Note:** The script will run for some time (~10-15 min), since it will wait for Jenkins to boot before setting credentials via the Jenkins REST API.

    ```console
    $ ./setupInfrastructure.sh
    ```

1. To verify the deployment of the sockshop service, retrieve the URLs of your front-end in the dev, staging, and production environments with the `kubectl get svc` *`service`* `-n` *`namespace`* command:

    ```console
    $ kubectl get svc front-end -n dev
    NAME         TYPE            CLUSTER-IP      EXTERNAL-IP       PORT(S)           AGE
    front-end    LoadBalancer    10.23.252.***   **.225.203.***    8080:30438/TCP    5m
    ```

    ```console
    $ kubectl get svc front-end -n staging
    NAME         TYPE            CLUSTER-IP       EXTERNAL-IP      PORT(S)           AGE
    front-end    LoadBalancer    10.23.246.***    **.184.97.***    8080:32501/TCP    6m
    ```

    ```console
    $ kubectl get svc front-end -n production
    NAME         TYPE            CLUSTER-IP       EXTERNAL-IP      PORT(S)           AGE
    front-end    LoadBalancer    10.23.248.***    **.226.62.***    8080:32232/TCP    7m
    ```

1. Run the `kubectl get svc` command to get the **EXTERNAL-IP** and **PORT** of Jenkins. Then user a browser to open Jenkins and login using the default Jenkins credentials: `admin` / `AiTx4u8VyUV8tCKk`. 
    
    **Note:** It is highly recommended to change these credentials right after the first login.

    ```console
    $ kubectl get svc jenkins -n cicd
    NAME       TYPE            CLUSTER-IP      EXTERNAL-IP       PORT(S)                            AGE
    jenkins    LoadBalancer    10.23.245.***   ***.198.26.***    24***:32478/TCP,50***:31867/TCP    10m
    ``` 

1. To verify the correct installation of Jenkins, go to the Jenkins dashboard where you see the following pipelines:
    * k8s-deploy-production
    * k8s-deploy-production-canary
    * k8s-deploy-production-update
    * k8s-deploy-staging
    * Folder called sockshop

1. Finally, navigate to **Jenkins** > **Manage Jenkins** > **Configure System** and  scroll to the environment variables to verify whether the variables are set correctly. **Note:** The value for the parameter *DT_TENANT_URL* must start with *https://*

    {{< popup_image
    link="./assets/jenkins-env-vars.png"
    caption="Jenkins environment variables">}}

### Troubleshooting

- In case any value is missing in Jenkins, this can be fixed by adding the corresponding value in the `manifests/jenkins/k8s-jenkins-deployment.yml` file and re-applying this file with `kubectl`. 
E.g., if the the value for `DOCKER_REGISTRY_IP` is unset, retrieve the value with `kubectl get svc -n cicd` and insert as value.

    ```
    ...
    env:
      - name: GITHUB_USER_EMAIL
        value: youremail@organization.com
      - name: GITHUB_ORGANIZATION
        value: your-github-org
      - name: DOCKER_REGISTRY_IP
        value: 10.20.30.40
      - name: DT_TENANT_URL
        value: yourID.live.dynatrace.com
      - name: DT_API_TOKEN
        value: 123apitoken
    ...
    ```

    Save the file and apply with: `kubectl apply -f k8s-jenkins-deployment.yml`. This will redeploy the Jenkins with the updated configuration.

## Step 4: (optional) Create process group naming rule in Dynatrace

1. Create a naming rule for process groups
    1. Go to **Settings**, **Process and containers**, and click on **Process group naming**.
    1. Create a new process group naming rule with **Add new rule**. 
    1. Edit that rule:
        * Rule name: `Container.Namespace`
        * Process group name format: `{ProcessGroup:KubernetesContainerName}.{ProcessGroup:KubernetesNamespace}`
        * Condition: `Kubernetes namespace`> `exits`
    1. Click on **Preview** and **Save**.

    Screenshot shows this rule definition.
    {{< popup_image
    link="./assets/pg_naming.png"
    caption="Dynatrace naming rule">}}

<!-- 
## Step 3: Use case walk through <a id="step-three"></a>

To explore the capabilities of keptn, follow the provided use cases that are dedicated to a special topic.

* [Performance as a Service](./usecases/performance-as-a-service): This use case aims on moving from manual sporadic execution and analysis of performance tests to a fully automated on-demand self-service testing model for developers.

* [Production Deployments](./usecases/production-deployments): This use case gives an overview of production deployments, deployment strategies, and showcases those using Istio on Kubernetes to canary-deploy a new front-end version.

* [Runbook Automation and Self-Healing](./usecases/runbook-automation-and-self-healing): This use case gives an overview of how to leverage the power of runbook automation to build self-healing applications. 

* [Unbreakable Delivery Pipeline](./usecases/unbreakable-delivery-pipeline): The overall goal of the *Unbreakable Delivery Pipeline* is to implement a pipeline that prevents bad code changes from impacting real end users.
-->

## Step 5: Cleanup

1. To clean up your Kubernetes cluster, execute the `cleanupCluster.sh` script in the `scripts` directory.

    ```console
    $ ./scripts/cleanupCluster.sh
    ```


## Troubleshooting

Please note that in case of any errors, the install script might leave some files in a inconsistent state, therefore the `setupInfrastructure.sh` file can not be run a second time without a cleanup. To prevent any issues with subsequent setup runs, we recommend to fully delete the GitHub organization, the keptn installation folder and checkout the keptn release again. (Some files may have been edited already that are not reverted in case of aborting the setup script.)