---
title: Prometheus
description: How to setup Prometheus monitoring.
weight: 13
icon: setup
keywords: setup
---

In order to evaluate the quality gates and allow self-healing in production, we have to set up monitoring to get the needed data.

## Prerequisites

- To setup Prometheus monitoring for you Kubernetes cluster, a Keptn project and at least one onboarded service must be available. For example, finish the [Onboarding a Service](../onboard-carts-service/) tutorial or onboard your own service.

## Setup Prometheus

After creating a project and service, you can setup Prometheus monitoring and configure scrape jobs using the Keptn CLI. 

* Execute the following command to set up the rules for the *Prometheus Alerting Manager*:

  ```
  keptn configure monitoring prometheus --project=PROJECTNAME --service=SERVICENAME
  ```

* To verify that the Prometheus scrape jobs are correctly set up, you can access Prometheus by enabling port-forwarding for the prometheus-service:

    ```console
    kubectl port-forward svc/prometheus-service 8080 -n monitoring
    ```
  Prometheus is then available on [localhost:8080/targets](http://localhost:8080/targets) where you can see the targets for the service:

    {{< popup_image link="./assets/prometheus-targets.png" caption="Prometheus Targets">}}

* Finally, the *prometheus-service* need to be deployed in Keptn to make Keptn aware of Prometheus. To deploy this service, please complete following tasks: 

  ```console
  git clone --branch 0.3.0 https://github.com/keptn-contrib/prometheus-service --single-branch
  ```

  ```console
  cd prometheus-service/deploy/
  ```

  ```console
  kubectl apply -f distributor.yaml
  ```

  ```console
  kubectl apply -f service.yaml
  ```
  
## Setup Prometheus SLI provider 

During the evaluation of a quality gate, the Prometheus SLI provider is required that is implemented by an internal Keptn service, the **prometheus-sli-service**. This servcie will fetch the values for the SLIs that are referenced in SLO file.

* To install the **prometheus-sli-service**, complete the following commands:

  ```console
  git clone --branch 0.1.0 https://github.com/keptn-contrib/prometheus-sli-service --single-branch
  ```

  ```console
  cd prometheus-sli-service/deploy
  ```
  
  ```console
  kubectl apply -f distributor.yaml
  ```

  ```console
  kubectl apply -f service.yaml
  ```

* To verify that the deployment has worked, execute:

  ```console
  kubectl get pods -n keptn | grep prometheus-sli
  ```

To tell the **prometheus-sli-service** how to acquire the values of a SLI, the correct query needs to be configured. This can be done by storing the following ConfigMap in the `keptn` namespace:

```yaml
apiVersion: v1
data:
  custom-queries: |
    cpu_usage: avg(rate(container_cpu_usage_seconds_total{namespace="$PROJECT-$STAGE",pod_name=~"$SERVICE-primary-.*"}[5m]))
    response_time_p95: histogram_quantile(0.95, sum by(le) (rate(http_response_time_milliseconds_bucket{handler="ItemsController.addToCart",job="$SERVICE-$PROJECT-$STAGE-canary"}[$DURATION_SECONDS])))
kind: ConfigMap
metadata:
  name: prometheus-sli-config-PROJECTNAME
  namespace: keptn
```

* Before executing the next command, please adapt the `metadata.name` property of the ConfigMap to match the name of your project. Then, apply the ConfigMap:

```console
kubectl apply -f prometheus-sli-config.yaml
```
