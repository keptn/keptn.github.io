---
title: Service
description: Learn how to onboard your own service in Keptn.
weight: 30
keywords: [manage]
aliases:
---

Learn how to manage your services in Keptn.

## Onboard your own service

After creating a project, the Keptn CLI allows creating new Keptn-managed services (i.e., to *onboard* services into Keptn). The onboarded services are organized in the before created project.
For describing the Kubernetes resources, [Helm charts](https://Helm.sh/) are used. More precisely, the user has to provide a Helm chart package, which has to fulfill the following requirements:

1. The Helm chart _has_ to contain exactly one [deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/).
In this deployment, the properties `spec.selector.matchLabels.app` and `spec.template.metadata.labels.app` have to be set.

1. The Helm chart requires _at least one_ [service](https://kubernetes.io/docs/concepts/services-networking/service/).
In each service, the property `spec.selector.app` has to be set.

1. The Helm chart _has_ to contain a `values.yaml` file with at least the `image` and `replicas` parameters for the deployment. These parameters are used in the deployment and Keptn references exactly their names. An example is shown below:
  
  ```yaml
  image: docker.io/keptnexamples/carts:0.9.1
  replicas: 1
  ```

  ```yaml
  --- 
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: your_deployment
  spec:
    replicas: {{ .Values.replicas }}
    selector:
      matchLabels:
        app: your_service
    template:
      metadata: 
        labels:
          app: your_service
      spec:
        containers:
        - name: your_service
          image: "{{ .Values.image }}"
  ```

<!-- Make sure that your actual service provides a `/health` endpoint at port `8080` since this is needed for the [liveness and readiness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/) of Kubernetes. -->


To onboard a service, use the command `onboard service` and provide the service name (e.g., `my-service`), project name (`--project` flag), as well as the root direcotry of a Helm chart or the path to an already packed Helm chart (`--chart` flag). 

```console
keptn onboard service SERVICENAME --project=PROJECTNAME --chart=FILEPATH
```

```console
keptn onboard service SERVICENAME --project=PROJECTNAME --chart=HELM_CHART.tgz
```

**Note:** If you are using custom configurations and you would like to have the environment variables `KEPTN_PROJECT`, `KEPTN_STAGE`, and `KEPTN_SERVICE` within your service, add the following environment variables to your deployment configuration.

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

**Note:** If you need to store resources (e.g., test files, configuration files, etc.) that are required by a service, use the Keptn CLI with the [`add-resource`](../../reference/cli#keptn-add-resource) command and specifiy the `--project`, `--stage`, and `--service` as shown below:

```console
keptn add-resource --project=your-project --service=my-service --stage=staging --resource=jmeter/load.jmx
```

<!--
Furthermore, Keptn needs the `perfspec.json` file as well as the JMeter files. Therefore, add those resources to your onboarded service:

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