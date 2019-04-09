---
title: Deployments with Quality Gates
description: Gives an overview of deployments using quality gates and blue/green deployments of a new service version.
weight: 25
keywords: []
aliases:
---

This use case gives an overview of production deployments, deployment strategies, and depicts those using Istio on Kubernetes to blue/green a new service version.

## About this use case

When developing an application, sooner or later you need to update a service in a production environment. To conduct this in a controlled manner and without impacting end-user experience, adequate deployment strategies must be in place. For example, blue-green deployments are well-known strategies to rollout a new service version by also keeping the previous service version available if something goes wrong.

To illustrate the benefit this use case addresses, you will create a second version of the carts service. Then, this version will be deployed to the production environment by releasing it as the blue or green version next to the previous version of the service. To route traffic to this new service version, the configuration of a virtual service will be changed by setting weights for the routes between blue and green.

## Set up Monitoring for the carts service
Since this use case relies on the concept of quality gates, you will need to set up monitoring for your carts service.
In this use case we will be using both the open source monitoring solution *Prometheus* as well as *Dynatrace*.

### Option 1: Set up Prometheus
As [Pitometer](https://github.com/keptn/pitometer) allows developers to add their own sources for evaluating a service's performance it is possible to use any monitoring solution to evaluate your quality gates. For this example, we will use Prometheus to monitor and evaluate the service:

  - In the examples folder you have cloned during [onboarding the carts service](../onboard-carts-service/), navigate to the directory `monitoring/prometheus`. In this directory, you will find a script called `deployPrometheus.sh`. This script will deploy Prometheus in the namespace `monitoring` and set up scrape job configurations for monitoring the carts service in the `dev`, `staging` and `production` namespace. Execute that script by calling:

  ```console
  $ ./deployPrometheus.sh
  namespace "monitoring" created
  configmap "prometheus-server-conf" created
  clusterrole.rbac.authorization.k8s.io "prometheus" created
  clusterrolebinding.rbac.authorization.k8s.io "prometheus" created
  deployment.extensions "prometheus-deployment" created
  service "prometheus-service" created
  ```

To verify the Prometheus installation, you can browse to the Prometheus web interface:

- First, enable port-forwarding for the `prometheus-service`:

```console
kubectl port-forward svc/prometheus-service 8080 -n monitoring
```

- Afterwards, open the URL [localhost:8080/targets](http://localhost:8080/targets) in your browser. Here you should see three targets for the carts service:

    {{< popup_image
      link="./assets/prometheus-targets.png"
      caption="Prometheus Targets">}}

- To set up the quality gates for the carts service, please open the file `perfspec/perfspec.json` in the repository of your carts service, and insert the following content:

  ```json
  {
    "spec_version": "1.0",
    "indicators": [
      {
            "id":"request_latency_seconds",
            "source":"Prometheus",
            "query":"rate(requests_latency_seconds_sum{job='carts-$ENVIRONMENT'}[$DURATION_MINUTESm])/rate(requests_latency_seconds_count{job='carts-$ENVIRONMENT'}[$DURATION_MINUTESm])",
            "grading":{
                "type":"Threshold",
                "thresholds":{
                  "upperSevere":1.0
                },
                "metricScore":100
            }
          }
    ],
    "objectives": {
      "pass": 90,
      "warning": 75
    }
  }
  ```

This quality gate will check that the average response time of the service is under 1&nbsp;second. If the response time exceeds this threshold, the performance evaluation will be marked as failed, the service deployment will be rejected and the requests to the service will be directed to the previous working deployment of the service.

### Option 2: Set up Dynatrace
To monitor your service with Dynatrace, please follow the [Dynatrace setup instructions](https://keptn.sh/docs/0.2.0/usecases/setup-dynatrace/).
This will deploy the OneAgent in your cluster, and set up rules for automatic tagging of your services.

After the OneAgent has been deployed, you can use Dynatrace as a source for your deployment's quality gates. The quality gates can be specified in the file `perfscpec/perfspec.json` in the repository of your carts service. In this example we are going to evaluate the average response time of the newly deployed service version after the performance tests in the staging environment have been executed. To set up this metric, please open the `perfspec/perfspec.json` file, and insert the following content:

  ```json
  {
    "spec_version": "1.0",
    "indicators": [
      {
        "id": "ResponseTime_Backend",
        "source": "Dynatrace",
        "query": {
          "timeseriesId": "com.dynatrace.builtin:service.responsetime",
          "aggregation": "AVG",
          "startTimestamp": "",
          "endTimestamp": ""
        },
        "grading": {
          "type": "Threshold",
          "thresholds": {
            "upperSevere": 1000000,
            "upperWarning": 800000
          },
          "metricScore": 100
        }
      }
    ],
    "objectives": {
      "pass": 90,
      "warning": 75
    }
  }
  ```

This quality gate will check that the average response time of the service is under 1&nbsp;second. If the response time exceeds this threshold, the performance evaluation will be marked as failed, the service deployment will be rejected and the requests to the service will be directed to the previous working deployment of the service.


## Deploy carts v1 and clone the forked repository

1. In order to start this use case, please deploy the `carts` service by completing the use case [Onboarding a Service](../onboard-carts-service/).

1. Clone the forked carts service to your local machine.

    ```console
    $ cd ~
    $ git clone https://github.com/your-github-org/carts.git
    $ cd carts
    ```

## Access service via ingress gateway

<!--
1. Ensure that the label `istio-injection` has been applied to the production namespace by executing the `kubectl get namespace -L istio-injection` command:

    ```console
    $ kubectl get namespace -L istio-injection
    NAME           STATUS    AGE       ISTIO-INJECTION
    keptn          Active    10h
    default        Active    10h
    dev            Active    10h
    istio-system   Active    10h        disabled
    kube-public    Active    10h
    kube-system    Active    10h
    production     Active    10h        enabled
    staging        Active    10h        enabled
    ```
-->

1. Run the `kubectl get svc istio-ingressgateway -n istio-system` command to get the *EXTERNAL-IP* of your `istio-ingressgateway` service.

    ```console
    $ kubectl get svc istio-ingressgateway -n istio-system
    NAME                   TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                                      AGE
    istio-ingressgateway   LoadBalancer   172.21.109.129   3*.2**.1**.8*   80:31380/TCP,443:31390/TCP,31400:31400/TCP   17h
    ```

1. Open a browser and navigate to: `http://carts.production.EXTERNAL-IP.xip.io/version`

1. You should be able to retrieve the version of the service.


## Create carts v2 with slowdown

Next, you will change the version number of the carts service to see the effect of traffic routing between two different artifact versions.

1. In the directory of your `carts` repository:
    * open the file `version` and change `0.6.0` to `0.6.1`.
    * open the file `src/main/resources/application.properties` and change the following properties:
        
    | Old values        | New values           |
    |----------------   |----------------      |
    | `version=v1`      | `version=v2`         |
    | `delayInMillis=0` | `delayInMillis=1000` |

1. Save the changes.

1. Commit the changes and then push it to the remote git repository.

    ```console
    $ git add .
    $ git commit -m "Introduced service slow down."
    $ git push
    ```

<!--
## Change Istio traffic routing (manually)
In this step, you will configure traffic routing in Istio to redirect traffic to both versions of the `carts` service.

1. Go to your github organization used by keptn (i.e., the github organization used for `keptn configure`).

1. Click on the repository called `sockshop` and change the branch to `production`.

1. Click on `helm-chart`, `templates` and open the file `istio-virtual-service-carts.yaml`.

1. Click on `Edit this file` [1] and change the weights [2] as shown in the screenshot below:

      {{< popup_image
      link="./assets/istio_traffic.png"
      caption="Traffic routing configuration for carts">}}

1. Finally, click on *Commit changes*.
--> 

## Deploy carts v2 to production

1. Trigger the CI pipeline for the `carts` service to create a new version of the artifact:
  * Use a browser to open Jenkins with the url `jenkins.keptn.EXTERNAL-IP.xip.io` and login using the credentials set in the [Onboarding a Service](../onboard-carts-service/#add-ci-pipeline-to-jenkins) use case.
  * In Jenkins go to **carts** > **master** > **Build Now** to trigger the build for the new artifact.

1. When the artifact is pushed to the docker registry, the configuration of the service is automatically updated and the CD pipeline gets triggered.

1. Watch keptn deploying the new artifact by following the pipelines in Jenkins.
  * **Phase 1**: Deploying, testing and evaluating the test in the `dev` stage:
      * **deploy**: The new artifact gets deployed to dev.
      * **run_tests**: Runs a basic health check and functional check in dev. Whenever the test pipeline has been executed, an event of the type `sh.keptn.events.tests-finished` is generated. 
      * **Pitometer test evaluation**: This event will be picked up by the Pitometer service, which is responsible for evaluating test runs, based on the quality gates specified earlier in the `perfspec.json` file. Since in the dev environment, only functional tests are executed, the Pitometer service will mark the test run as successful (functional failures would have led the **run-tests** pipeline to fail).
      * **evaluation_done**: This pipeline will promote the artifact to the next stage, i.e., staging.
  * **Phase 2**: Deploying, testing and evaluating the test in the `staging` stage:
      * **deploy**: The new artifact gets deployed to staging using a blue/green deployment strategy.
      * **run_tests**: Runs a performance test in staging and sends the `sh.keptn.events.tests-finished` event.
      * **Pitometer test evaluation**: This time, the quality gates of the service will be evaluated, because we are using the performance-tests strategy for this stage. This means that the Pitometer service will fetch the metrics for the `carts` service from either Dynatrace or Prometheus, depending on how you set up the monitoring for your service earlier. Based on the results of that evaluation, the Pitometer service will mark the test run execution as successful or failed. In our scenario, the Pitometer service will mark it as failed since the response time thresholds will be exceeded.
      * **evaluation_done**:  If the evaluation would have been successful, the artefact would be promoted to production. Since in our case we failed the performance test run, this pipeline automatically re-routes traffic to the previous colored blue or green version in staging and the artifact won't be promoted to production.
      
  **Outcome**: This slow version v2 is **not** promoted to the production namespace because of the active quality gate in place.

## Create carts v3 without slowdown

Next, you will change the `carts` service to make it pass the quality gate.

1. In the directory of your `carts` repository:
    * open the file `version` and change `0.6.1` to `0.6.2`.
    * open the file `src/main/resources/application.properties` and change change the following properties:
        
    | Old values           | New values        |
    |----------------      |----------------   |
    | `version=v2`         | `version=v3`      |
    | `delayInMillis=1000` | `delayInMillis=0` |

1. Save the changes.

1. Commit the changes and then push it to the remote git repository.

    ```console
    $ git add .
    $ git commit -m "Fixed service slow down."
    $ git push
    ```

## Deploy carts v3 to production and verify the result

1. Trigger the CI pipeline for the `carts` service to create a new artifact.

1. When the artifact is pushed to the docker registry, the configuration of the service is automatically updated and the CD pipeline gets triggered.

1. In this case, the quality gate is passed and the service gets deployed in the production namespace. 

1. To verify the deployment in production, open a browser an navigate to: `http://carts.production.EXTERNAL-IP.xip.io/version`. As a result, you see `Version = v3`.

1. Besides, you can verify the deployments in your K8s cluster using the following commands: 

    ```console
    $ kubectl get deployments -n production
    NAME             DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    carts-blue       1         1         1            0           1h
    carts-db-blue    1         1         1            0           1h
    carts-db-green   1         1         1            0           1h
    carts-green      1         1         1            0           1h
    ```

    ```console
    $ kubectl describe deployment carts-blue -n production
    ...
    Pod Template:
      Labels:  app=sockshop-selector-carts
               deployment=carts-blue
      Containers:
      carts:
        Image:      10.11.245.27:5000/sockshopcr/carts:0.6.0-1
    ```

    ```console
    $ kubectl describe deployment carts-green -n production
    ...
    Pod Template:
      Labels:  app=sockshop-selector-carts
               deployment=carts-blue
      Containers:
      carts:
        Image:      10.11.245.27:5000/sockshopcr/carts:0.6.2-3
    ```

    ```console
    $ kubectl describe virtualService -n production
    ...
    Route:
      Destination:
        Host:    carts-db.production.svc.cluster.local
        Subset:  blue
      Weight:    0
      Destination:
        Host:    carts-db.production.svc.cluster.local
        Subset:  green
      Weight:    100
    ```
