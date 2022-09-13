---
title: Create a service
description: Create a service for your project
weight: 23
keywords: [0.19.x-manage]
aliases:
---

After creating a project, you can create one or more services for that project.
A service spans stages in your project,
so Keptn can run sequences for a particular microservice in different stages,
applying different configurations to different stages.

## Service name restrictions

* The service name must be a a string that can be a valid *nix directory name
because the service name is used as the name of the directory that is created in the upstream git repository.
* The service name must be less than 43 characters long.

## Create a service

You can create a service for your project in either of the following ways:

* Use the Keptn Bridge UI
* Use the Keptn CLI

In both cases, you must specify the service and project names.

### Use the Keptn Bridge

To create a service from the Keptn Bridge:

1. Click on the "Services" button for your project.
1. Click "Create service".
1. Give your service a name.
1. Click "Create service".

### Use the Keptn CLI

Use the [keptn create service](../../reference/cli/commands/keptn_create_service) command
to create a service from the command line.
You must [install](../../../install/cli-install) and [authenticate](../../../install/authenticate-cli-bridge)
the Keptn CLI before you can run this command:

```
keptn create service <SERVICENAME> --project=<PROJECTNAME>
```

## Requirements for the Helm Chart to deploy

After creating a service, you ,must provide a Helm Chart where the service deploys.
For Keptn, the [Helm Chart](https://Helm.sh/) has the following requirements:

1. The Helm chart _must_ contain exactly one [deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/). The properties `spec.selector.matchLabels.app` and `spec.template.metadata.labels.app` must be set in this deployment.

1. The Helm chart _must_ contain exactly one [service](https://kubernetes.io/docs/concepts/services-networking/service/). The property `spec.selector.app` must be set in this service.

1. The Helm chart _must_ contain a `values.yaml` file with at least the `image` and `replicaCount` parameter for the deployment. These `image` and `replicaCount` parameters must be used in the deployment. An example is shown below:

  ```
  image: docker.io/keptnexamples/carts:0.13.1
  replicaCount: 1
  ```

  ```
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

```
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

```
keptn add-resource --project=PROJECTNAME --service=SERVICENAME --all-stages --resource=HELM_CHART.tgz --resourceUri=helm/SERVICENAME.tgz
```
