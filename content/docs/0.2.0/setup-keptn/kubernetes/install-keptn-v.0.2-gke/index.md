---
title: Install keptn v.0.2 on GKE
description: Demonstrates how to install keptn in a Kubernetes cluster on Google Kubernetes Engine (GKE). 
weight: 36
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

The scripts provided by keptn v.0.2 run in a BASH and require following tools locally installed: 

- [jq](https://stedolan.github.io/jq/) which is a lightweight and flexible command-line JSON processor.
- [yq](https://github.com/mikefarah/yq) for querying and writing YAML objects.
- [git](https://git-scm.com/)
- [gcloud](https://cloud.google.com/sdk/gcloud/) CLI
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - The script will log you into the cluster you will provide as an input parameter.
- [helm 2.12.3](https://helm.sh/) - A package manager for Kubernetes, used for deploying keptn-managed applications

    **Tip:** View all the kubectl commands, including their options and descriptions in the [kubectl CLI reference](https://kubernetes.io/docs/user-guide/kubectl-overview/).

Additionally, the scripts need:

- `GKE cluster name`: The GKE cluster you want to deploy keptn on.
- `GKE cluster zone`: The zone your GKE cluster is located in (e.g. us-centra-1-a).
- `GKE Project`: The GKE project the cluster is managed by.
- `GitHub organization`
- `GitHub personal access token` 
- Dynatrace Tenant including the Dynatrace `Tenant ID`, a Dynatrace `API Token`, and Dynatrace `PaaS Token`. If you don't have a Dynatrace tenant yet, sign up for a [free trial](https://www.dynatrace.com/trial/) or a [developer account](https://www.dynatrace.com/developer/).

    **Note:** The `API Token` must have the following permissions as shown in the screenshot below:
    
    - Access problem and event feed, metrics and topology
    - Access logs
    - Configure maintenance windows
    - Read configuration
    - Write configuration
    - Capture request data
    - Real user monitoring JavaScript tag management

    {{< popup_image
    link="./assets/dt_api_token.png"
    caption="Dynatrace API token">}}

## Step 2: Download and prepare for the installation

1. Go to the [keptn release](https://github.com/keptn/keptn/archive/0.2.0.tar.gz) page to download the installation file using, e.g., `wget`:
    ```console
    $ cd ~
    $ git clone --branch prerelease-0.2.x https://github.com/keptn/keptn.git
    ```

1. Navigate to the keptn directory:

    ```console
    $ cd keptn
    ```

## Step 3: Provision cluster on Kubernetes

Keptn contains all scripts and instructions needed to install the necessary components on your K8S cluster.
    
1. Insert information in *./scripts/creds.json* by executing `defineCredentials.sh` in the `scripts` directory. This script will prompt you for all information needed to complete the setup and populate the file *scripts/creds.json* with them. 

    **Attention:** This file will hold your personal access-token and credentials needed for the automatic setup of keptn. Take care of not leaking this file! (As a first precaution we have added this file to the `.gitignore` file to prevent committing it to GitHub.)

    ```console
    $ ./defineCredentials.sh
    ```
1. If you don't have a running cluster yet, you can create one by executing the script `createCluster.sh` in the `scripts` directory.   

1. Execute `setupInfrastructure.sh` in the `scripts` directory. This script deploys a container registry and Jenkins service within your cluster, as well as the keptn core components. 

    **Attention:** The script will create several new resources for you and will also update the files shipped with keptn. Take care of not leaking any files that will hold personal information. Including:
        
    - `manifests/dynatrace/cr.yml`
    - `manifests/istio/service_entries.yml`
    - `manifests/jenkins/k8s-jenkins-deployment.yml`

    **Note:** The script will run for some time (~10-15 min), since it will wait for Jenkins to boot before setting credentials via the Jenkins REST API.

    ```console
    $ ./setupInfrastructure.sh
    ```

1. Run the `kubectl get svc` command to get the **EXTERNAL-IP** and **PORT** of Jenkins. Then user a browser to open Jenkins and login using the default Jenkins credentials: `admin` / `AiTx4u8VyUV8tCKk`. 
    
    **Note:** It is highly recommended to change these credentials right after the first login.

    ```console
    $ kubectl get svc jenkins -n keptn
    NAME       TYPE            CLUSTER-IP      EXTERNAL-IP       PORT(S)                            AGE
    jenkins    LoadBalancer    10.23.245.***   ***.198.26.***    24***:32478/TCP,50***:31867/TCP    10m
    ``` 

1. Finally, navigate to **Jenkins** > **Manage Jenkins** > **Configure System** and  scroll to the environment variables to verify whether the variables are set correctly. **Note:** The value for the parameter *DT_TENANT_URL* must start with *https://*

    {{< popup_image
    link="./assets/jenkins-env-vars.png"
    caption="Jenkins environment variables">}}

1. **Important**: Due to a [known issue](https://issues.jenkins-ci.org/browse/JENKINS-14880) in Jenkins, it is necessary to click **Save** although nothing is changed in this verification step. If the configuration is not saved at this point, the `$BUILD_URL` variable won't be initialized correctly for the builds and this meta-information will be missing later on in the use cases. 


### Troubleshooting

- In case any value is missing in Jenkins, this can be fixed by adding the corresponding value in the `manifests/jenkins/k8s-jenkins-deployment.yml` file and re-applying this file with `kubectl`. 
E.g., if the the value for `DOCKER_REGISTRY_IP` is unset, retrieve the value with `kubectl get svc -n keptn` and insert as value.

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

## Step 5: Verify Installation

To verify your installation, retrieve the pods runnning in the `keptn` namespace. The output of this command should include the following pods:

    ```console
    $ kubectl get pods -n keptn
    authenticator-85jzg-deployment-6c5b596998-b5lhc       3/3       Running     0          1d
    control-zbpdw-deployment-6b5bdcf9b7-4djv4             3/3       Running     0          2h
    docker-registry-55bd8d967c-lx8z6                      2/2       Running     0          1d
    event-broker-ext-grqwq-deployment-76fc5975fb-9s2ct    3/3       Running     0          1d
    event-broker-vqw2d-deployment-db6bdcf99-jgkfr         3/3       Running     0          1d
    jenkins-deployment-84d5d5d8d7-lt5sw                   2/2       Running     0          20h
    ```
If those pods do not show up after a few minutes, please check if all pods within the `istio-system` pods are in a running state. If that is not the case, there may have been a problem during the Istio installation. In that case we kindly ask you to clean your cluster and restart the installation, as described in the **Troubleshooting** section below

## Step 6: Cleanup

1. To clean up your Kubernetes cluster, execute the `cleanupCluster.sh` script in the `scripts` directory.

    ```console
    $ ./scripts/cleanupCluster.sh
    ```


## Troubleshooting

Please note that in case of any errors, the install script might leave some files in a inconsistent state, therefore the `setupInfrastructure.sh` file can not be run a second time without a cleanup. To prevent any issues with subsequent setup runs, we recommend to fully delete the GitHub organization, the keptn installation folder and checkout the keptn release again. (Some files may have been edited already that are not reverted in case of aborting the setup script.)
