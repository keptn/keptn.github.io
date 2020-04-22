---
title: Service
description: Create or onboard your service in Keptn
weight: 30
keywords: [manage]
aliases:
---

Learn how to manage your services in Keptn.

## Onboard your service

After creating a project, the Keptn CLI allows creating new Keptn-managed services (i.e., to *onboard* services into Keptn). The onboarded services are organized in the before created project.
For describing the Kubernetes resources, [Helm charts](https://Helm.sh/) are used. More precisely, the user has to provide a Helm chart package, which has to fulfill the following requirements:

1. The Helm chart _has_ to contain exactly one [deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/).
In this deployment, the properties `spec.selector.matchLabels.app` and `spec.template.metadata.labels.app` have to be set.

1. The Helm chart _has_ to contain exactly one [service](https://kubernetes.io/docs/concepts/services-networking/service/).
In this service, the property `spec.selector.app` has to be set.

1. The Helm chart _has_ to contain a `values.yaml` file with at least the `image` parameter for the deployment. This `image` parameter has to be used in the deployment. An example is shown below:
  
  ```yaml
  image: docker.io/keptnexamples/carts:0.9.1
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

To onboard a service, use the [onboard service](../../reference/cli#keptn-onboard-service) command and provide the service name, project name (`--project` flag), and the root directory of a Helm chart (`--chart` flag). 

```console
keptn onboard service SERVICENAME --project=PROJECTNAME --chart=FILEPATH
```

If you have already an archived Helm chart, the archive with ending `.tgz` can be referenced. In this case, the Helm chart will be stored unpacked. 

```console
keptn onboard service SERVICENAME --project=PROJECTNAME --chart=HELM_CHART.tgz
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

**Note:** If you need to store resources (e.g., test files, configuration files, etc.) that are required by a service, use the [add-resource](../../reference/cli#keptn-add-resource) command and specifiy the `--project`, `--stage`, and `--service` as shown below:

```console
keptn add-resource --project=your-project --service=my-service --stage=staging --resource=jmeter/load.jmx
```