---
title: Upgrade Keptn
description: Upgrade your Keptn to 0.7
weight: 5
keywords: upgrade
---

## Upgrade from 0.6.2 to 0.7

* To download and install the Keptn CLI for version 0.7.0, please refer to the [Install Keptn CLI section](../setup-keptn/#install-keptn-cli).

* To upgrade your Keptn installation from 0.6.2 to 0.7.0, you can deploy a *Kubernetes Job* that will take care of updating all components to the 0.7.0 release. Please [verify that you are connected to the correct Kubernetes cluster](../../reference/troubleshooting/#verify-kubernetes-context-with-keptn-installation)
before deploying the upgrading job with the next command:

```console
kubectl delete job upgrader -n default
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.7.0/upgrader/upgrade-062-070/upgrade-job.yaml
```

* To check the status of the update job, please execute:

```console
kubectl get job -n default
```
```
NAME                COMPLETIONS   DURATION   AGE
upgrader            1/1           17s        20h
```

When the job is completed, your Keptn version has been updated to 0.7.0.

<details><summary>*Verifying that the upgrade worked*</summary>

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

```console
kubectl -n keptn-datastore get deployments -owide
```

```console
NAME                            READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS          IMAGES                                  SELECTOR
mongodb                         1/1     1            1           4h25m   mongodb             centos/mongodb-36-centos7:1             name=mongodb
mongodb-datastore               1/1     1            1           4h25m   mongodb-datastore   keptn/mongodb-datastore:20200308.0859   run=mongodb-datastore
mongodb-datastore-distributor   1/1     1            1           4h25m   distributor         keptn/distributor:0.6.0                 run=distributor
```

**After the upgrade**

```console
kubectl -n keptn get deployments -owide
```

```console
NAME                                                      READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS               IMAGES                                  SELECTOR
api-gateway-nginx                                         1/1     1            1           73m     api-gateway-nginx        nginx:1.17.9                            run=api-gateway-nginx
api-service                                               1/1     1            1           4h39m   api                      keptn/api:0.7.0                         run=api
bridge                                                    1/1     1            1           4h39m   bridge                   keptn/bridge2:0.7.0                     run=bridge
configuration-service                                     1/1     1            1           4h39m   configuration-service    keptn/configuration-service:0.7.0       run=configuration-service
eventbroker-go                                            1/1     1            1           4h39m   eventbroker-go           keptn/eventbroker-go:0.7.0              run=eventbroker-go
gatekeeper-service                                        1/1     1            1           4h39m   gatekeeper-service       keptn/gatekeeper-service:0.7.0          run=gatekeeper-service
gatekeeper-service-approval-distributor                   1/1     1            1           4h39m   distributor              keptn/distributor:0.7.0                 run=distributor
gatekeeper-service-evaluation-done-distributor            1/1     1            1           4h39m   distributor              keptn/distributor:0.7.0                 run=distributor
helm-service                                              1/1     1            1           4h39m   helm-service             keptn/helm-service:0.7.0                run=helm-service
helm-service-configuration-change-distributor             1/1     1            1           4h39m   distributor              keptn/distributor:0.7.0                 run=distributor
helm-service-service-create-distributor                   1/1     1            1           4h39m   distributor              keptn/distributor:0.7.0                 run=distributor
jmeter-service                                            1/1     1            1           4h39m   jmeter-service           keptn/jmeter-service:0.7.0              run=jmeter-service
jmeter-service-deployment-distributor                     1/1     1            1           4h39m   distributor              keptn/distributor:0.7.0                 run=distributor
lighthouse-service                                        1/1     1            1           4h39m   lighthouse-service       keptn/lighthouse-service:0.7.0          run=lighthouse-service
lighthouse-service-distributor                            1/1     1            1           72s     distributor              keptn/distributor:0.7.0                 run=distributor
nats-operator                                             1/1     1            1           4h40m   nats-operator            connecteverything/nats-operator:0.6.0   name=nats-operator
prometheus-service                                        1/1     1            1           41m     prometheus-service       keptn/prometheus-service:0.3.1          run=prometheus-service
prometheus-service-monitoring-configure-distributor       1/1     1            1           41m     distributor              keptn/distributor:0.5.0                 run=distributor
prometheus-sli-service                                    1/1     1            1           38m     prometheus-sli-service   keptn/prometheus-sli-service:0.2.1      run=prometheus-sli-service
prometheus-sli-service-monitoring-configure-distributor   1/1     1            1           38m     distributor              keptn/distributor:latest                run=distributor
remediation-service                                       1/1     1            1           4h39m   remediation-service      keptn/remediation-service:0.7.0         run=remediation-service
remediation-service-problem-distributor                   1/1     1            1           4h39m   distributor              keptn/distributor:0.7.0                 run=distributor
shipyard-service                                          1/1     1            1           4h39m   shipyard-service         keptn/shipyard-service:0.7.0            run=shipyard-service
shipyard-service-create-project-distributor               1/1     1            1           4h39m   distributor              keptn/distributor:0.7.0                 run=distributor
shipyard-service-delete-project-distributor               1/1     1            1           4h39m   distributor              keptn/distributor:0.7.0                 run=distributor
wait-service                                              1/1     1            1           4h39m   wait-service             keptn/wait-service:0.7.0                run=wait-service
wait-service-deployment-distributor                       1/1     1            1           4h39m   distributor              keptn/distributor:0.7.0                 run=distributor

```

```console
kubectl -n keptn-datastore get deployments -owide
```

```console
NAME                            READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS          IMAGES                          SELECTOR
mongodb                         1/1     1            1           2m41s   mongodb             centos/mongodb-36-centos7:1     name=mongodb
mongodb-datastore               1/1     1            1           4h40m   mongodb-datastore   keptn/mongodb-datastore:0.7.0   run=mongodb-datastore
mongodb-datastore-distributor   1/1     1            1           4h40m   distributor         keptn/distributor:0.7.0         run=distributor
```

</details>

### Enabling manual approvals for existing projects

To enable the manual-approval feature described in the [Continuos delivery section](../../continuous_delivery/multi_stage/#approval-strategy), you can update the `shipyard.yaml` file of the project as follows:

For each stage you would like to enable the approval feature, you can add the `approval_strategy` property to the stage definition. So for example, when your existing `shipyard.yaml` is:

```yaml
stages:
  - name: "dev"
    deployment_strategy: "direct"
  - name: "hardening"
    deployment_strategy: "blue_green_service"
  - name: "production"
    deployment_strategy: "blue_green_service"
```

, and you would like to enable the approval feature for the `production` stage, you can add the following lines to the `shipyard.yaml`

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

**NOTE**: You can only enable the approval feature for existing stages. It is not possible to rename, add or remove stages.

After finishing the changes within the `shipyard.yaml`, you can update it using the `keptn add-resource` command:

```
keptn add-resource --project=<YOUR_PROJECT_NAME> --resource=shipyard.yaml
```
