---
title: Service
description: Create or onboard your service in Keptn
weight: 30
keywords: [manage]
aliases:
---

After creating a project, Keptn allows creating a service or onboarding a service into Keptn. The difference between creating and onboarding is as follows:

- **Create a service:** This creates a new and empty service in the specified project. This option is used when **not** deploying a service with Keptn. 

- **Onboard a service:** This creates a new service and uploades the configuration to deploy the service. The configuration has to be a Helm Chart.

## Create a service

* To create a service, use the [keptn create service](../../../reference/cli/commands/keptn_create_service) command and provide the service and project name (`--project` flag): 

```console
keptn create service SERVICENAME --project=PROJECTNAME
```

## Onboard a service

For describing the deployable Kubernetes resources of a service that gets onboarded, [Helm charts](https://Helm.sh/) are used with the following requirements:

1. The Helm chart _has_ to contain exactly one [deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/). In this deployment, the properties `spec.selector.matchLabels.app` and `spec.template.metadata.labels.app` have to be set.

1. The Helm chart _has_ to contain exactly one [service](https://kubernetes.io/docs/concepts/services-networking/service/). In this service, the property `spec.selector.app` has to be set.

1. The Helm chart _has_ to contain a `values.yaml` file with at least the `image` parameter for the deployment. This `image` parameter has to be used in the deployment. An example is shown below:
  
  ```yaml
  image: docker.io/keptnexamples/carts:0.11.1
  ```

  ```yaml
  --- 
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: your_deployment
  spec:
    replicas: 2
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

**Note:** If you are using custom configurations and you would like to have the environment variables `KEPTN_PROJECT`, `KEPTN_STAGE`, and `KEPTN_SERVICE` within your service, add the following environment variables to your deployment configuration.

```yaml
env:
...
- name: KEPTN_PROJECT
  value: "{{ .Chart.Name }}"
- name: KEPTN_STAGE
  valueFrom:
    fieldRef:
      fieldPath: "metadata.namespace"
- name: KEPTN_SERVICE
  value: "{{ .Values.SERVICE_PLACEHOLDER_C.service.name }}"
```

**Onboard a service:**

* To onboard a service, use the [onboard service](../../../reference/cli/commands/keptn_onboard_service) command and provide the service name, project name (`--project` flag), and the root directory of a Helm chart (`--chart` flag): 

```console
keptn onboard service SERVICENAME --project=PROJECTNAME --chart=FILEPATH
```

* If you have already an archived Helm chart, the archive with ending `.tgz` can be referenced. In this case, the Helm chart will be stored unpacked. 

```console
keptn onboard service SERVICENAME --project=PROJECTNAME --chart=HELM_CHART.tgz
```
