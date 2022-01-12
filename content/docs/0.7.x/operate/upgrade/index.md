---
title: Upgrade Keptn
description: Upgrade your Keptn to 0.7
weight: 5
aliases:
  - /docs/0.7.0/operate/upgrade/
  - /docs/0.7.1/operate/upgrade/
  - /docs/0.7.2/operate/upgrade/
  - /docs/0.7.3/operate/upgrade/
---

## Upgrade from Keptn 0.7.2 to 0.7.3

1. Before starting the update, we strongly advise to create a backup of your Keptn projects. To do so, please follow the instructions in the [backup guide](../../operate/backup_and_restore).

1. To download and install the Keptn CLI for version 0.7.3, you can choose between:
    * **Automatic installation of the Keptn CLI (Linux and Mac)**:

      * The next command will download the 0.7.3 release from [GitHub](https://github.com/keptn/keptn/releases), unpack it, and move it to `/usr/local/bin/keptn`.
```console
curl -sL https://get.keptn.sh | KEPTN_VERSION=0.7.3 bash
```
    
      * Verify that the installation has worked and that the version is correct by running:
```console
keptn version
```

    * **Manual installation of the Keptn CLI:**

      * Download the release for your platform from the [GitHub](https://github.com/keptn/keptn/releases/tag/0.7.3)

      * Unpack the binary and move it to a directory of your choice (e.g., `/usr/local/bin/`)

      * Verify that the installation has worked and that the version is correct by running:
```console
keptn version
```

1. To upgrade your Keptn installation from 0.7.2 to 0.7.3, the Keptn CLI now offers the command: 
```console
keptn upgrade
```
    
    * Please [verify that you are connected to the correct Kubernetes cluster](../../troubleshooting/#verify-kubernetes-context-with-keptn-installation)
before executing this command.
    
    * This CLI command executes a Helm upgrade using the Helm chart from: [keptn-installer/keptn-0.7.3.tgz](https://charts.keptn.sh/packages/keptn-0.7.3.tgz)

**Note:** If you have manually modified your Keptn deployment, e.g., you deleted the Kubernetes Secret `bridge-credentials` for disabling basic auth, the `keptn upgrade` command will not detect the modification. Please re-apply your modification after performing the upgrade.

## Upgrade from Keptn 0.7.1 to 0.7.2

1. Before starting the update, we strongly advise to create a backup of your Keptn projects. 
To do so, please follow the instructions in the [backup guide](../../operate/backup_and_restore)

1. To download and install the Keptn CLI for version 0.7.2, please refer to the [Install Keptn CLI](../install/#install-keptn-cli) section.

1. To upgrade your Keptn installation from 0.7.1 to 0.7.2, the Keptn CLI now offers the command [`keptn upgrade`](../../reference/cli/commands/keptn_upgrade).
    
    * Please [verify that you are connected to the correct Kubernetes cluster](../../troubleshooting/#verify-kubernetes-context-with-keptn-installation)
before executing this command.
    
    * This CLI command executes a Helm upgrade using the Helm chart from [keptn-installer/keptn-0.7.2.tgz](https://charts.keptn.sh/packages/keptn-0.7.2.tgz).

**Note:** If you have manually modified your Keptn deployment, e.g., you deleted the Kubernetes Secret `bridge-credentials` for disabling basic auth, the `keptn upgrade` command will not detect the modification. Please re-apply your modification after performing the upgrade.

## Upgrade from Keptn 0.7.0 to 0.7.1

1. Before starting the update, we strongly advise to create a backup of your Keptn projects. 
To do so, please follow the instructions in the [backup guide](../../operate/backup_and_restore)

1. To download and install the Keptn CLI for version 0.7.1, please refer to the [Install Keptn CLI](../install/#install-keptn-cli) section.

1. To upgrade your Keptn installation from 0.7.0 to 0.7.1, the Keptn CLI now offers the command [`keptn upgrade`](../../reference/cli/commands/keptn_upgrade).
    
    * Please [verify that you are connected to the correct Kubernetes cluster](../../troubleshooting/#verify-kubernetes-context-with-keptn-installation)
before executing this command.
    
    * This CLI command executes a Helm upgrade using the Helm chart from [keptn-installer/keptn-0.7.1.tgz](https://charts.keptn.sh/packages/keptn-0.7.1.tgz).

**Note:** If you have manually modified your Keptn deployment, e.g., you deleted the Kubernetes Secret `bridge-credentials` for disabling basic auth, the `keptn upgrade` command will not detect the modification. Please re-apply your modification after performing the upgrade.

## Upgrade from Keptn 0.6.2 to 0.7.0

1. Before starting the update, we strongly advise to create a backup of your Keptn projects. 
To do so, please follow the instructions in the [backup guide](../../../0.6.0/installation/backup_and_restore)

1. To download and install the Keptn CLI for version 0.7.0, please refer to the [Install Keptn CLI](../install/#install-keptn-cli) section.

1. To upgrade your Keptn installation from 0.6.2 to 0.7.0, a *Kubernetes Job* is provided that upgrades all components to the 0.7.0 release. 

    * Please [verify that you are connected to the correct Kubernetes cluster](../../troubleshooting/#verify-kubernetes-context-with-keptn-installation)
before deploying the upgrading job.

    * Keptn 0.7 uses Helm 3 while previous Keptn releases rely on Helm 2. This means that you have to upgrade the Helm releases of your Keptn-managed services. Otherwise, a `keptn send new-artifact` does not work anymore. For upgrading Helm releases, two options are available as outlined below. Please take into account that the end-of-life period of Helm 2 begins on [August 13th, 2020](https://helm.sh/blog/covid-19-extending-helm-v2-bug-fixes/).

### Job without Helm 3 Upgrade

:mag: **Info:** By using this upgrader job, Helm releases are **not** converted to Helm 3.0 and still on version Helm 2. After executing the upgrader job, you need to manually convert the Helm releases on your Kubernetes cluster as explained below.

```console
kubectl delete job upgrader -n keptn
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/release-0.7.0/upgrader/upgrade-062-070/upgrade-job.yaml
```

**Manual converting Helm release from Helm 2 to 3:**

The following guide to manually convert Helm releases is for Linux and MacOS. To perform these steps on a Windows machine, you can spin up a docker container that has already `kubectl`, `helm v2.14.3`, and `helm v3.1.2` installed. 

* Install Helm v2.14.3 CLI (*Note*: this CLI version is called to `helm`):

```console
wget https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz
tar -zxvf helm-v2.14.3-linux-amd64.tar.gz
mv linux-amd64/helm /bin/helm
rm -rf linux-amd64
```

* Install Helm v3.1.2 CLI and `2to3` plugin. (*Note*: this CLI version is renamed to `helm3`):

```console
wget https://get.helm.sh/helm-v3.1.2-linux-amd64.tar.gz
tar -zxvf helm-v3.1.2-linux-amd64.tar.gz
mv linux-amd64/helm /bin/helm3
rm -rf linux-amd64

helm3 plugin install https://github.com/helm/helm-2to3
```

* Run Helm init command (with Helm 2 CLI) and retrieve Helm releases from your cluster: 

```console
helm init --client-only
helm list -aq
```

* Manually upgrade release by first doing a dry-run and then converting the release:

```console
helm3 2to3 convert RELEASE_NAME --dry-run
helm3 2to3 convert RELEASE_NAME
```

* *Optional:* Cleanup Helm and remove Tiller: 

```console
helm3 2to3 cleanup --tiller-cleanup
```

### Job with Helm 3 Upgrade

This option is recommended when you have a Kubernetes cluster with just Keptn installed. But please consider the warning: 

:warning: **Warning:** By using this upgrader job, **all** Helm releases are upgraded from Helm 2 to 3 and Tiller will be removed. This also includes Helm releases that are not managed by Keptn. If you have Helm releases on your cluster that are on version 2 and you do not want to upgrade, don't use this upgrader.

```console
kubectl delete job upgrader -n keptn
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/release-0.7.0/upgrader/upgrade-062-070/upgrade-job-helm3.yaml
```

### Verify Upgrader Job

* To check the status of the update job, execute:

```console
kubectl get job -n keptn
```
```
NAME                COMPLETIONS   DURATION   AGE
upgrader            1/1           17s        20h
```

When the job is completed, your Keptn version has been updated to 0.7.0.

<details><summary>*Verifying result*</summary>

To verify that the upgrade process worked, please check the images and their tags using `kubectl` as described below. 

**Before the upgrade**:

```console
kubectl -n keptn get deployments -owide
```

```
NAME                                                      READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS               IMAGES                                      SELECTOR
api                                                       1/1     1            1           4h25m   api                      keptn/api:0.6.0                             run=api
bridge                                                    1/1     1            1           4h25m   bridge                   keptn/bridge2:20200308.0859                 run=bridge
configuration-service                                     1/1     1            1           4h25m   configuration-service    keptn/configuration-service:20200308.0859   run=configuration-service
eventbroker-go                                            1/1     1            1           4h25m   eventbroker-go           keptn/eventbroker-go:0.6.0                  run=eventbroker-go
gatekeeper-service                                        1/1     1            1           4h24m   gatekeeper-service       keptn/gatekeeper-service:0.6.0              run=gatekeeper-service
gatekeeper-service-evaluation-done-distributor            1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
helm-service                                              1/1     1            1           4h25m   helm-service             keptn/helm-service:0.6.0                    run=helm-service
helm-service-configuration-change-distributor             1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
helm-service-service-create-distributor                   1/1     1            1           4h25m   distributor              keptn/distributor:0.6.0                     run=distributor
jmeter-service                                            1/1     1            1           4h24m   jmeter-service           keptn/jmeter-service:0.6.0                  run=jmeter-service
jmeter-service-deployment-distributor                     1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
lighthouse-service                                        1/1     1            1           4h24m   lighthouse-service       keptn/lighthouse-service:0.6.0              run=lighthouse-service
lighthouse-service-get-sli-done-distributor               1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
lighthouse-service-start-evaluation-distributor           1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
lighthouse-service-tests-finished-distributor             1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
nats-operator                                             1/1     1            1           4h25m   nats-operator            connecteverything/nats-operator:0.6.0       name=nats-operator
remediation-service                                       1/1     1            1           4h24m   remediation-service      keptn/remediation-service:0.6.0             run=remediation-service
remediation-service-problem-distributor                   1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
shipyard-service                                          1/1     1            1           4h25m   shipyard-service         keptn/shipyard-service:0.6.0                run=shipyard-service
shipyard-service-create-project-distributor               1/1     1            1           4h25m   distributor              keptn/distributor:0.6.0                     run=distributor
shipyard-service-delete-project-distributor               1/1     1            1           4h25m   distributor              keptn/distributor:0.6.0                     run=distributor
wait-service                                              1/1     1            1           4h24m   wait-service             keptn/wait-service:0.6.0                    run=wait-service
wait-service-deployment-distributor                       1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
```

**After the upgrade**

```console
kubectl -n keptn get deployments -owide
```

```console
NAME                    READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS                          IMAGES                                                                          SELECTOR
api-gateway-nginx       1/1     1            1           21d   api-gateway-nginx                   docker.io/nginxinc/nginx-unprivileged:1.19.1-alpine                             app.kubernetes.io/instance=keptn,app.kubernetes.io/name=api-gateway-nginx
api-service             1/1     1            1           21d   api-service                         docker.io/keptn/api:0.7.1                                                       app.kubernetes.io/instance=keptn,app.kubernetes.io/name=api-service
bridge                  1/1     1            1           21d   bridge                              keptn/bridge2:b3be5c7                                                           app.kubernetes.io/instance=keptn,app.kubernetes.io/name=bridge
configuration-service   1/1     1            1           21d   configuration-service,distributor   docker.io/keptn/configuration-service:0.7.1,docker.io/keptn/distributor:0.7.1   app.kubernetes.io/instance=keptn,app.kubernetes.io/name=configuration-service
eventbroker-go          1/1     1            1           21d   eventbroker-go                      docker.io/keptn/eventbroker-go:0.7.1                                            app.kubernetes.io/instance=keptn,app.kubernetes.io/name=eventbroker-go
gatekeeper-service      1/1     1            1           21d   gatekeeper-service,distributor      docker.io/keptn/gatekeeper-service:0.7.1,docker.io/keptn/distributor:0.7.1      app.kubernetes.io/instance=keptn,app.kubernetes.io/name=gatekeeper-service
helm-service            1/1     1            1           21d   helm-service,distributor            docker.io/keptn/helm-service:0.7.1,docker.io/keptn/distributor:0.7.1            app.kubernetes.io/instance=keptn,app.kubernetes.io/name=helm-service
jmeter-service          1/1     1            1           21d   jmeter-service,distributor          docker.io/keptn/jmeter-service:0.7.1,docker.io/keptn/distributor:0.7.1          app.kubernetes.io/instance=keptn,app.kubernetes.io/name=jmeter-service
lighthouse-service      1/1     1            1           21d   lighthouse-service,distributor      docker.io/keptn/lighthouse-service:0.7.1,docker.io/keptn/distributor:0.7.1      app.kubernetes.io/instance=keptn,app.kubernetes.io/name=lighthouse-service
mongodb                 1/1     1            1           21d   mongodb                             docker.io/centos/mongodb-36-centos7:1                                           app.kubernetes.io/instance=keptn,app.kubernetes.io/name=mongodb
mongodb-datastore       1/1     1            1           21d   mongodb-datastore,distributor       docker.io/keptn/mongodb-datastore:0.7.1,docker.io/keptn/distributor:0.7.1       app.kubernetes.io/instance=keptn,app.kubernetes.io/name=mongodb-datastore
remediation-service     1/1     1            1           21d   remediation-service,distributor     docker.io/keptn/remediation-service:0.7.1,docker.io/keptn/distributor:0.7.1     app.kubernetes.io/instance=keptn,app.kubernetes.io/name=remediation-service
shipyard-service        1/1     1            1           21d   shipyard-service,distributor        docker.io/keptn/shipyard-service:0.7.1,docker.io/keptn/distributor:0.7.1        app.kubernetes.io/instance=keptn,app.kubernetes.io/name=shipyard-service
```

</details>

### Reconnect the CLI to the Keptn API

Since Keptn 0.7.0 does not use Istio VirtualServices for exposing the Keptn API anymore, the CLI needs to update the 
Keptn Endpoint. For this purpose, please follow the instructions in the [Installation documentation](../install/#access-the-keptn-api) 

### Configure delivery assistant for existing projects

To add manual approvals steps to the task sequence of delivery as described in the [Continuos delivery section](../../continuous_delivery/multi_stage/#approval-strategy), you can update the `shipyard.yaml` file of the project as follows.

For each stage you would like to enable the approval feature, you can add the `approval_strategy` property to the stage definition. 

* Assuming your existing `shipyard.yaml` is:

```yaml
stages:
  - name: "dev"
    deployment_strategy: "direct"
  - name: "hardening"
    deployment_strategy: "blue_green_service"
  - name: "production"
    deployment_strategy: "blue_green_service"
```

* You can add the following lines to the `shipyard.yaml`, if you would like to enable the approval feature for the `production` stage:

```yaml
stages:
  - name: "dev"
    deployment_strategy: "direct"
  - name: "hardening"
    deployment_strategy: "blue_green_service"
  - name: "production"
    approval_strategy: 
      pass: "manual"
      warning: "manual"
    deployment_strategy: "blue_green_service"
```

**Note**: You can only enable the approval feature for existing stages. It is **not possible** to rename, add, or remove stages.

After finishing the changes within the `shipyard.yaml`, you can update it using the `keptn add-resource` command:

```
keptn add-resource --project=<YOUR_PROJECT_NAME> --resource=shipyard.yaml
```
