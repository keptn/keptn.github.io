---
title: Upgrade Keptn
description: Upgrade your Keptn to 0.7
weight: 5
keywords: upgrade
aliases:
  - /docs/0.7.0/operate/upgrade/
---

## Upgrade from Keptn 0.6.2 to 0.7

1. To download and install the Keptn CLI for version 0.7.0, please refer to the [Install Keptn CLI](../install/#install-keptn-cli) section.

1. To upgrade your Keptn installation from 0.6.2 to 0.7.0, a *Kubernetes Job* is provided that upgrades all components to the 0.7.0 release. 

    * Please [verify that you are connected to the correct Kubernetes cluster](../../troubleshooting/#verify-kubernetes-context-with-keptn-installation)
before deploying the upgrading job.

    * Keptn 0.7 uses Helm 3 while previous Keptn releases rely on Helm 2. This means that you have to upgrade the Helm releases of your Keptn-managed services. Otherwise, a `keptn send new-artifact` does not work anymore. For upgrading Helm releases, two options are availble as outlined below. Please take into account that the end-of-life period of Helm 2 begins on [August 13th, 2020](https://helm.sh/blog/covid-19-extending-helm-v2-bug-fixes/).

### Job without Helm 3 Upgrade

:mag: **Info:** By using this upgrader job, Helm releases are **not** converted to Helm 3.0 and still on version Helm 2. After executing the upgrader job, you need to manually convert the Helm releases on your Kubernetes cluster as explained below.

```console
kubectl delete job upgrader -n default
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.7.0/upgrader/upgrade-062-070/upgrade-job.yaml
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
kubectl delete job upgrader -n default
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.7.0/upgrader/upgrade-062-070/upgrade-job-helm3.yaml
```

### Verify Upgrader Job

* To check the status of the update job, execute:

```console
kubectl get job -n default
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
prometheus-service                                        1/1     1            1           27m     prometheus-service       keptn/prometheus-service:0.3.1              run=prometheus-service
prometheus-service-monitoring-configure-distributor       1/1     1            1           27m     distributor              keptn/distributor:0.5.0                     run=distributor
prometheus-sli-service                                    1/1     1            1           24m     prometheus-sli-service   keptn/prometheus-sli-service:0.2.0          run=prometheus-sli-service
prometheus-sli-service-monitoring-configure-distributor   1/1     1            1           24m     distributor              keptn/distributor:0.5.0                     run=distributor
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
NAME                                                      READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS                          IMAGES                                                                            SELECTOR
api-gateway-nginx                                         1/1     1            1           65m   api-gateway-nginx                   docker.io/nginxinc/nginx-unprivileged:1.17.9                                      run=api-gateway-nginx
api-service                                               1/1     1            1           65m   api-service                         docker.io/keptn/api:latest                                                        run=api-service
bridge                                                    1/1     1            1           65m   bridge                              docker.io/keptn/bridge2:latest                                                    run=bridge
configuration-service                                     1/1     1            1           65m   configuration-service,distributor   docker.io/keptn/configuration-service:latest,docker.io/keptn/distributor:latest   run=configuration-service
eventbroker-go                                            1/1     1            1           65m   eventbroker-go                      docker.io/keptn/eventbroker-go:latest                                             run=eventbroker-go
helm-service                                              1/1     1            1           65m   helm-service,distributor            docker.io/keptn/helm-service:latest,docker.io/keptn/distributor:latest            run=helm-service
lighthouse-service                                        1/1     1            1           65m   lighthouse-service,distributor      docker.io/keptn/lighthouse-service:latest,docker.io/keptn/distributor:latest      run=lighthouse-service
mongodb                                                   1/1     1            1           65m   mongodb                             docker.io/centos/mongodb-36-centos7:1                                             name=mongodb
mongodb-datastore                                         1/1     1            1           65m   mongodb-datastore,distributor       docker.io/keptn/mongodb-datastore:latest,docker.io/keptn/distributor:latest       run=mongodb-datastore
prometheus-service                                        1/1     1            1           85m   prometheus-service                  keptn/prometheus-service:0.3.3                                                    run=prometheus-service
prometheus-service-monitoring-configure-distributor       1/1     1            1           85m   distributor                         keptn/distributor:0.6.0                                                           run=distributor
prometheus-sli-service                                    1/1     1            1           85m   prometheus-sli-service              keptncontrib/prometheus-sli-service:0.2.2                                         run=prometheus-sli-service
prometheus-sli-service-monitoring-configure-distributor   1/1     1            1           85m   distributor                         keptn/distributor:latest                                                          run=distributor
remediation-service                                       1/1     1            1           65m   remediation-service,distributor     docker.io/keptn/remediation-service:latest,docker.io/keptn/distributor:latest     run=remediation-service
shipyard-service                                          1/1     1            1           65m   shipyard-service,distributor        docker.io/keptn/shipyard-service:latest,docker.io/keptn/distributor:latest        run=shipyard-service
```

</details>

### Reconnect the CLI to the Keptn API

Since Keptn 0.7.0 does not use Istio VirtualServices for exposing the Keptn API anymore, the CLI needs to update the 
Keptn Endpoint. For this purpose, please follow the instructions in the [Installation documentation](../install/#access-the-keptn-api) 

### Configure delivery assistant for existing projects

To add manual approvals steps to the delivery workflow as described in the [Continuos delivery section](../../continuous_delivery/multi_stage/#approval-strategy), you can update the `shipyard.yaml` file of the project as follows.

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
