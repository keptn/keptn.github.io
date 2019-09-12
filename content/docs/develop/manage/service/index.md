---
title: Service
description: Learn how to onbaord your own service in keptn.
weight: 30
keywords: [manage]
aliases:
---

Learn how to manage your services in keptn.

## Onboard your own service

After creating a project the keptn CLI allows to onboard services into this project. Please note that for describing the Kubernetes resources, [Helm charts](https://Helm.sh/) are used. 
When onboarding your own service instead of the provided demo example, the Helm chart _has_ to contain a `values.yaml` file with at least the `image` and `replicas` parameter for the deployment and service template. An example is shown below:

```yaml
image: docker.io/keptnexamples/carts:0.9.1
replicas: 1
```
<!--
First, define how many instances of your deployment should be running by providing this number as the `replicaCount`. Next, the `image repository` and `tag` can be set to null since they will be set with the keptn CLI command `keptn send event new-artifact`. For the `service`, provide the name of your service as well as the internal port you want your service to be reachable. For the `container name` provide a name you want to call your container. Additionally, make sure that your actual service provides a `/health` endpoint at port `8080` since this is needed for the [liveness and readiness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/) of Kubernetes.
-->

To onboard a service, use the command `onboard service` and provide the service name (e.g., `my-service`), project name (`--project` flag) and the Helm chart (`--chart` flag):

```console
keptn onboard service my-service --project=your-project --chart=my-service.tgz
```

> **Note:** If you are using custom configurations and you would like to have the environment variables `KEPTN_PROJECT`, `KEPTN_STAGE`, and `KEPTN_SERVICE` within your service, add the following environment variables to your deployment configuration.

```yaml
env:
...
- name: KEPTN_PROJECT
  value: "{{ .Chart.Name }}"
- name: KEPTN_SERVICE
  value: "{{ .Values.SERVICE_PLACEHOLDER_C.service.name }}"
- name: KEPTN_STAGE
  valueFrom:
    fieldRef:
      fieldPath: "metadata.namespace"
```

> **Note:** If you need to store resources (e.g., test files, configuration files, etc.) that are needed by a service, use the keptn cli with the `add-resource` command and specifiy the `--project`, `--stage`, and `--service` as shown below:

```console
keptn add-resource --project=your-project --service=my-service --stage=staging --resource=jmeter/load.jmx
```

<!--
Furthermore, keptn needs the `perfspec.json` file as well as the JMeter files. Therefore, add those resources to your onboarded service:

```console
keptn add-resource --project=your-project --service=my-service --resource=perfspec.json
```

An example of a perfspec file is shown below:

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
            "upperSevere":0.8
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

**TODO: explain pitometer file in more detail**

In this file, [Prometheus](https://prometheus.io) is gathering metrics on the request latency in seconds. A threshold grader is then used to evaluate if the threshold is met. A score to this single metric is assigned, as well as objectives that have to be met to consider the quality of the service satisfying.
-->