---
title: Install
description: Setup Prometheus monitoring
weight: 1
icon: setup
---

In order to evaluate the quality gates and allow self-healing in production, we have to set up monitoring to get the needed data.

## Prerequisites

- Keptn project and at least one onboarded service must be available.

## Setup Prometheus

After creating a project and service, you can set up Prometheus monitoring and configure scrape jobs using the Keptn CLI.

Keptn doesn't install or manage Prometheus and its components. Users need to install Prometheus and Prometheus Alert manager as a prerequisite.

Some environment variables have to set up in the prometheus-service deployment
```yaml
    # Prometheus installed namespace
    - name: PROMETHEUS_NS
    value: 'default'
    # Prometheus server configmap name
    - name: PROMETHEUS_CM
    value: 'prometheus-server'
    # Prometheus server app labels
    - name: PROMETHEUS_LABELS
    value: 'component=server'
    # Prometheus configmap data's config filename
    - name: PROMETHEUS_CONFIG_FILENAME
    value: 'prometheus.yml'
    # AlertManager configmap data's config filename
    - name: ALERT_MANAGER_CONFIG_FILENAME
    value: 'alertmanager.yml'
    # Alert Manager config map name
    - name: ALERT_MANAGER_CM
    value: 'prometheus-alertmanager'
    # Alert Manager app labels
    - name: ALERT_MANAGER_LABELS
    value: 'component=alertmanager'
    # Alert Manager installed namespace
    - name: ALERT_MANAGER_NS
    value: 'default'
    # Alert Manager template configmap name
    - name: ALERT_MANAGER_TEMPLATE_CM
    value: 'alertmanager-templates'
```

#### Execute the following steps to install prometheus-service

* Download the Keptn's Prometheus service manifest

```bash
wget https://raw.githubusercontent.com/keptn-contrib/prometheus-service/release-0.5.0/deploy/service.yaml
```

* Replace the environment variable value according to the use case and apply the manifest

```bash
kubectl apply -f service.yaml
```

* Install Role and Rolebinding to permit Keptn's prometheus-service for performing operations in the Prometheus installed namespace.

```bash
kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/prometheus-service/release-0.5.0/deploy/role.yaml -n <PROMETHEUS_NS>
```

* Execute the following command to install Prometheus and set up the rules for the *Prometheus Alerting Manager*:

```bash
keptn configure monitoring prometheus --project=sockshop --service=carts
```

#### Optional: Verify Prometheus setup in your cluster
* To verify that the Prometheus scrape jobs are correctly set up, you can access Prometheus by enabling port-forwarding for the prometheus-service:

```BASH
kubectl port-forward svc/prometheus-service 8080 -n <PROMETHEUS_NS>
```

Prometheus is then available on [localhost:8080/targets](http://localhost:8080/targets) where you can see the targets for the service.{{< popup_image link="./assets/prometheus-targets.png" caption="Prometheus Targets">}}
