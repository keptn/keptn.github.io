---
title: Upgrade Keptn
description: How to upgrade Keptn.
weight: 80
icon: setup
keywords: upgrade
---

For full details on what has changed from Keptn 0.5.x to Keptn 0.6.0 please refer to the release notes within the [Keptn repository](https://github.com/keptn/keptn/releases/0.6.0). 

# Upgrade from 0.5.x to 0.6.0

Unfortunatley, there are multiple breaking changes from Keptn 0.5.x to Keptn 0.6.x that make it impossible to provide an upgrade script from Keptn 0.5.x to Keptn 0.6.x. These breaking changes include:

* Istio sidecar injection has been introduced for blue-green deployments
* Pitometer was removed, instead the lighthouse was installed
* Ingress gateway handling was changed

Instead of an upgrade script, we will highlight the most important changes that you need to do to get your services onboarded with a fresh Keptn 0.6.0 installation.

**Note**: Advise for migrating from [Keptn 0.6.0.beta(2) to 0.6.0](#upgrade-from-0-6-0beta-2-to-0-6-0) is listed below.

## Helm Charts

Several changes to Helm charts have been made. If you want to stay compatible, please adapt your Helm charts accordingly.

* Parameterize the `replicas` in the deployment manifest. Therefore, set `replicas: {{ .Values.replicaCount }}` instead of a fixed value, e.g.: `replicas: 1`:

  ```yaml
  replicas: {{ .Values.replicaCount }}
  ```

  See example: https://github.com/keptn/examples/blob/release-0.6.0/onboarding-carts/carts/templates/deployment.yaml#L7

* Then, set a new value in `values.yaml` for each service: `replicaCount`. See example: https://github.com/keptn/examples/blob/release-0.6.0/onboarding-carts/carts/values.yaml

* Dynatrace integration: We have removed `DT_TAGS` and introduced `DT_CUSTOM_PROP`:

  ```yaml
  - name: DT_CUSTOM_PROP
    value: "keptn_project={{ .Values.keptn.project }} keptn_service={{ .Values.keptn.service }} keptn_stage={{ .Values.keptn.stage }} keptn_deployment={{ .Values.keptn.deployment }}"
  ```
  
  See example: https://github.com/keptn/examples/blob/release-0.6.0/onboarding-carts/carts/templates/deployment.yaml#L29-L30

## New Lighthouse / Pitometer was removed

Pitometer was removed including the support support for PerfSpec files. Instead, a new service called *lighthouse* has been introduced. Please follow the [Deployment with Quality Gates tutorial](../../usecases/deployments-with-quality-gates/) to learn more about the new file formats used for quality gates.

# Upgrade from 0.6.0beta(2) to 0.6.0

When we introduced the new lighthouse-service with custom SLIs in 0.6.0.beta we got a lot of feedback. We value this feedback, and we wanted to thank all our beta testers for their extensive testing and feedback provided by providing an upgrade guide from 0.6.0.beta(2) to 0.6.0.

## Lighthouse: Custom SLIs in Git repo

For Keptn 0.6.0.beta(2), we asked you to create custom SLI by creating a Kubernetes ConfigMap for Prometheus that looked like this:

```yaml
apiVersion: v1
data:
  custom-queries: |
    cpu_usage: avg(rate(container_cpu_usage_seconds_total{namespace="$PROJECT-$STAGE",pod_name=~"$SERVICE-primary-.*"}[5m]))
    response_time_p95: histogram_quantile(0.95, sum by(le) (rate(http_response_time_milliseconds_bucket{handler="ItemsController.addToCart",job="$SERVICE-$PROJECT-$STAGE"}[$DURATION_SECONDS])))
kind: ConfigMap
metadata:
  name: prometheus-sli-config-sockshop
  namespace: keptn
```

With Keptn 0.6.0, custom SLIs need to be added for the project/service/stage by using `keptn add-resource`. With this change in mind, we also had to slightly adapt the format of the file. Above file would now look as follows:

```yaml
---
spec_version: '1.0'
indicators:
  cpu_usage: avg(rate(container_cpu_usage_seconds_total{namespace="$PROJECT-$STAGE",pod_name=~"$SERVICE-primary-.*"}[5m]))
  response_time_p95: histogram_quantile(0.95, sum by(le) (rate(http_response_time_milliseconds_bucket{handler="ItemsController.addToCart",job="$SERVICE-$PROJECT-$STAGE"}[$DURATION_SECONDS])))
```

To migrate from the old format to the new format, you can:

1. Fetch the ConfigMap using ` kubectl get configmap -n keptn prometheus-sli-config-sockshop -oyaml`
1. Copy the content from within the `custom-queries: |` section (without `custom-queries: |`)
1. Create a new file called `sli.yaml` with the following content:

    ```yaml
    ---
    spec_version: '1.0'
    indicators:
      # paste-content-here
    ```

The newly created file needs to be added to as follows:

* Prometheus

    ```console
    keptn add-resource --project=sockshop --stage=staging --service=carts --resource=sli.yaml --resourceUri=prometheus/sli.yaml
    ```

* Dynatrace

    ```console
    keptn add-resource --project=sockshop --stage=staging --service=carts --resource=sli.yaml --resourceUri=dynatrace/sli.yaml
    ```

## Ingress Gateway

If you want to stay compatible, you need to perform the following steps:

1. Delete the existing gateways that are relevant for Keptn namespace using:

   ```console
   kubectl delete gateway keptn-gateway -n keptn
   ```

1. Apply the new public-gateway in namespace istio-system using:

   ```console
   kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/release-0.6.0/installer/manifests/istio/public-gateway.yaml
   ```

1. Edit the VirtualService for the Keptn api service such that it uses `public-gateway.istio-system` instead of `keptn-gateway`: 

   ```console
   kubectl get vs/api -n keptn -o yaml | sed 's/keptn-gateway/public-gateway.istio-system/g' | kubectl replace -f -
   ```

1. Verify that you can still access the API via a browser.

1. Adapt all VirtualServices of onboarded services to use the `public-gateway.istio-system` (e.g., by sending a `new-artifact` event for all those services which will be handled by the updated helm-service, or by manually editing the virtual services)

1. (Optional) Delete all generated gateways (in all namespaces of the project-stages) using: `kubectl delete gateways -n $project-$stage` for every $project and $stage)

## Update services from 0.6.0.beta2 to 0.6.0

### Update services in keptn-datastore namespace

```console
kubectl -n keptn-datastore set image deployment/mongodb-datastore mongodb-datastore=keptn/mongodb-datastore:0.6.0 --record
kubectl -n keptn-datastore set image deployment/mongodb-datastore-distributor distributor=keptn/distributor:0.6.0 --record
```

### Update services in keptn namespace

```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/release-0.6.0/installer/manifests/keptn/core.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/release-0.6.0/installer/manifests/keptn/continuous-deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/release-0.6.0/installer/manifests/keptn/quality-gates.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/release-0.6.0/installer/manifests/keptn/continuous-operations.yaml
```

### Update keptn-contrib services 

Please only update the services if you have them installed

* *dynatrace-service*: `kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-service/release-0.6.0/deploy/service.yaml`
* *dynatrace-sli-service*: `kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-sli-service/release-0.3.0/deploy/service.yaml`
* *prometheus-service*: `kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/prometheus-service/release-0.3.1/deploy/service.yaml`
* *prometheus-sli-service*: `kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/prometheus-sli-service/release-0.2.0/deploy/service.yaml`
* *notification-service*: `kubectl -n keptn set image deployment/notification-service notification-service=keptncontrib/notification-service:0.3.0 --record`

# Install new Keptn CLI

Please refer to the [install section](../setup-keptn) to install the latest Keptn CLI for version 0.6.0.
