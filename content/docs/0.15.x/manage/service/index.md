---
title: Service
description: Create a service in Keptn.
weight: 30
keywords: [0.15.x-manage]
aliases:
---

After creating a project, Keptn allows creating a service into Keptn. 

## Service name restrictions

* Service name must be a valid unix directory name (*Note*: for each service a directory with the corresponding name is created in the upstream git repository)
* Keptn Version >= 0.8.3:
  Service name must be less than 43 characters (*Note*: template was reduced to `${SERVICE}-generated` to allow longer service names)

## Create a service

* To create a service, use the [keptn create service](../../reference/cli/commands/keptn_create_service) command and provide the service and project name (`--project` flag): 

```console
keptn create service SERVICENAME --project=PROJECTNAME
```

**Requirements for the Helm Chart to deploy**

After creating a service, you need to provide a Helm Chart for the service to deploy it. For Keptn, the [Helm Chart](https://Helm.sh/) has the following requirements:

1. The Helm chart _has_ to contain exactly one [deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/). In this deployment, the properties `spec.selector.matchLabels.app` and `spec.template.metadata.labels.app` have to be set.

1. The Helm chart _has_ to contain exactly one [service](https://kubernetes.io/docs/concepts/services-networking/service/). In this service, the property `spec.selector.app` has to be set.

1. The Helm chart _has_ to contain a `values.yaml` file with at least the `image` and `replicaCount` parameter for the deployment. These `image` and `replicaCount` parameters have to be used in the deployment. An example is shown below:
  
  ```yaml
  image: docker.io/keptnexamples/carts:0.13.1
  replicaCount: 1
  ```

  ```yaml
  --- 
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: your_deployment
  spec:
    replicas: {{ .Values.replicaCount }}
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

* Finally, upload the Helm Chart to your service: 

```console
keptn add-resource --project=PROJECTNAME --service=SERVICENAME --all-stages --resource=HELM_CHART.tgz --resourceUri=helm/SERVICENAME.tgz
```
