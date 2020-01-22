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

* To install the *prometheus-service*, execute: 

```console
kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/prometheus-service/0.3.1/deploy/service.yaml
```

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

  
## Setup Prometheus SLI provider 

During the evaluation of a quality gate, the Prometheus SLI provider is required that is implemented by an internal Keptn service, the *prometheus-sli-service*. This service will fetch the values for the SLIs that are referenced in a SLO configuration.

* To install the *prometheus-sli-service*, execute:

```console
kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/prometheus-sli-service/0.2.0/deploy/service.yaml
```

* To verify that the deployment has worked, execute:

```console
kubectl get pods -n keptn --selector run=prometheus-sli-service
```

---

**Provider configuration:**

To tell the *prometheus-sli-service* how to acquire the values of an SLI, the correct query needs to be configured. This is done by adding an SLI configuration to a project, stage, or service using the [add-resource](../../cli/#keptn-add-resource) command. The resource identifier must be `prometheus/sli.yaml`.

* In the below example, the SLI configuration as specified in the `sli-config-prometheus.yaml` file is added to the service `carts` in stage `hardening` from project `sockshop`. 

```console
keptn add-resource --project=sockshop --stage=hardening --service=carts --resource=sli-config-prometheus.yaml --resourceUri=prometheus/sli.yaml
```

**Note:** The add-resource command can be used to store a configuration on project-, stage-, or service-level. In the context of an SLI configuration, Keptn first uses SLI configuration stored on the service-level, then on the stage-level, and finally Keptn uses SLI configuration stored on the project-level.
