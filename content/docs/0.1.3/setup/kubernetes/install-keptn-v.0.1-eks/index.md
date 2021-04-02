---
title: Install keptn v.0.1 on AWS EKS
description: Demonstrates how to install keptn in a Kubernetes cluster on Amazon EKS. 
weight: 37
keywords: [kubernetes, install]
---

To install and configure keptn in a Kubernetes cluster, follow these instructions:

## Step 1: Prerequisites

The next steps expect that you have a working Kubernetes cluster on AWS EKS. In case you do not have an EKS cluster available there are a couple of ways to setup your own cluster
1. Follow the [Getting Started Guides](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html). 
2. Leverage Terraform Templates such as [Terraform AWS EKS Cluster by Cloudposse](https://github.com/cloudposse/terraform-aws-eks-cluster)

When creating your own cluster we recommend the following minimum sizing definitions:

- AutoScalingGroupMinSize: 2
- AutoScalingGroupDesiredCapacity: 2
- AutoScalingGroupMaxSize: 3
- NodeInstanceType: t3.2xlarge (8vCPUs, 32GB Memory)
- NodeImageId: pick the correct AMI based on the table in the getting started guide

If you end up using the Terraform scripts from Cloudposse I suggest you create a terraform.tvars file with the following settings
```
namespace = "<yourprojectname>"
stage = "workshop"
name = "keptn01"

instance_type = "t3.2xlarge"

max_size = 3
min_size = 2
apply_config_map_aws_auth = "true"
```

Once your EKS cluster and all nodes are up & running we can go on with deploying keptn.

The scripts provided by keptn v.0.1 run in a BASH and require following tools locally installed: 

- [jq](https://stedolan.github.io/jq/) which is a lightweight and flexible command-line JSON processor.
- [git](https://git-scm.com/) and [hub](https://hub.github.com/) that helps you do everyday GitHub tasks without ever leaving the terminal.
- [aws](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) which allows you to interact with AWS. Make sure you have it properly configure to interact with your AWS Account: [AWS CLI Quick Configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) that is logged in to your AWS EKS cluster. For more information on how to configure kubectl to connect to your EKS cluster check out [EKS Configure kubectl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html#eks-configure-kubectl)

    **Tip:** View all the kubectl commands, including their options and descriptions in the [kubectl CLI reference](https://kubernetes.io/docs/user-guide/kubectl-overview/).

Additionally, the scripts need:

- `GitHub organization` to store the repositories of the sockshop application
- `GitHub personal access token` to push changes to the sockshop repositories
- Dynatrace SaaS Tenant including the Dynatrace `Tenant ID`, a Dynatrace `API Token`, and Dynatrace `PaaS Token`. If you don't have a Dynatrace tenant yet, sign up for a [free trial](https://www.dynatrace.com/trial/) or a [developer account](https://www.dynatrace.com/developer/).

    **Note:** The `API Token` must have the permissions as shown in the screenshot below:

    ![dt_api_token](./assets/dt_api_token.png)

## Step 2: Download and prepare for the installation

1. Go to the [keptn release](https://github.com/keptn/keptn/releases/tag/0.1.3) page to download the installation file using, e.g., `wget`:
    ```console
    $ cd ~
    $ wget ...
    ```

1. Extract the package and move to the keptn directory:

    ```console
    $ tar -xvzf keptn-v.0.1.3.tar.gz 
    $ cd keptn
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

![](./assets/jenkins-env-vars.png)

## Step 4: (optional) Create process group naming rule in Dynatrace

1. Create a naming rule for process groups
    1. Go to **Settings**, **Process and containers**, and click on **Process group naming**.
    1. Create a new process group naming rule with **Add new rule**. 
    1. Edit that rule:
        * Rule name: `Container.Namespace`
        * Process group name format: `{ProcessGroup:KubernetesContainerName}.{ProcessGroup:KubernetesNamespace}`
        * Condition: `Kubernetes namespace`> `exists`
    1. Click on **Preview** and **Save**.

    Screenshot shows this rule definition.
    ![naming-rule](./assets/pg_naming.png)

 
## Step 5: Use case walk through <a id="step-three"></a>

To explore the capabilities of keptn, follow the provided use cases that are dedicated to a special topic. All use cases can be found in the keptn online doc

## Step 6: Cleanup

1. To clean up your Kubernetes cluster, execute the `cleanupCluster.sh` script in the `scripts` directory.

    ```console
    $ ./scripts/cleanupCluster.sh
    ```
2. Delete GitHub Organization

If you want to remove Sockshop from your GitHub feel free to delete your GitHub Organization
