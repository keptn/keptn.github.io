---
title: Service
description: Learn how to onbaord your own service in keptn.
weight: 30
keywords: [manage]
aliases:
---

Learn how to manage your services in keptn.

## Onboard your own service

After creating a project which represents a repository in your GitHub organization, the keptn CLI allows to onboard services into this project. Please note that for describing the Kubernetes resources, [Helm charts](https://helm.sh/) are used. Therefore, the keptn CLI allows setting a Helm values description in the before created project. Optionally, the user can also provide a Helm deployment and service description.

When onboarding your own service instead of the provided `carts` service, a values file _has_ to be provided. In addition, a service and a deployment file _can_ be provided.
The following snippet will help to define your own `values.yaml` file:

```yaml
replicaCount: 1
image:
    repository: null
    tag: null
    pullPolicy: IfNotPresent
service:
    name: myservice 
    internalPort: 8080
container:
    name: myservice
```

First, define how many instances of your deployment should be running by providing this number as the `replicaCount`. Next, the `image repository` and `tag` can be set to null since they will be set with the keptn CLI command `keptn send event new-artifact`. For the `service`, provide the name of your service as well as the internal port you want your service to be reachable. For the `container name` provide a name you want to call your container. Additionally, make sure that your actual service provides a `/health` endpoint at port `8080` since this is needed for the [liveness and readiness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/) for Kubernetes.

Furthermore, keptn needs to have access to the `perfspec.json` file as well as the JMeter files. Therefore, fork the GitHub repo of your service into the GitHub organization that you have created earlier.
Make sure in your repository there are the needed files in the corresponding folders:

```
SERVICENAME
│  README.md
│  ...    
│
└── jmeter
│   │   basiccheck.jmx
│   │   SERVICENAME_load.jmx
│   │   SERVICENAME_perfcheck.jmx
│   
└── perfspec
│   │   perfspec.json
│
└── src
└── ...
```


**TODO: explain that currently only JMeter is allowed for tests and which parameters are allowed.**


An example of a perfspec file is listed below:

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

To onboard a service, use the command `onboard service` and provide the project name (flag `--project`), the Helm chart values (flag `--values`) and optionally also deployment (flag `--deployment`) and service (flag `--service`) configuration.

- Use default deployment and service configuration:

```console
keptn onboard service --project=your_project --values=values.yaml
```

- Use custom deployment and service configuration:
  
```console
keptn onboard service --project=your_project --values=values.yaml --deployment=deployment.yaml --service=service.yaml
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

