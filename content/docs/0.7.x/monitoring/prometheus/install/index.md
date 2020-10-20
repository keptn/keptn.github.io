---
title: Install
description: Setup Prometheus monitoring
weight: 1
icon: setup
---

In order to evaluate the quality gates and allow self-healing in production, we have to set up monitoring to get the needed data.

## Prerequisites

- Keptn project and at least one onboarded service must be available.

## Deploy Prometheus on Kubernetes

## 1. Deploy Prometheus

* https://coreos.com/operators/prometheus/docs/latest/user-guides/getting-started.html

## 2. Verify Prometheus setup in your cluster

* To verify that the Prometheus scrape jobs are correctly set up, you can access Prometheus by enabling port-forwarding for the prometheus-service:

    ```console
    kubectl port-forward svc/prometheus-service 8080 -n monitoring
    ```

Prometheus is then available on [localhost:8080/targets](http://localhost:8080/targets) where you can see the targets for the service:
{{< popup_image link="./assets/prometheus-targets.png" caption="Prometheus Targets">}}

## Setup Prometheus

After creating a project and service, you can setup Prometheus monitoring and configure scrape jobs using the Keptn CLI. Therefore you need to deploy the *prometheus-service*. 

* Specify the version of the prometheus-service you want to deploy. Please see the [compatibility matrix](https://github.com/keptn-contrib/prometheus-service#compatibility-matrix) of the prometheus-service to pick the version that works with your Keptn.  

    ```console
    VERSION=<VERSION>   # e.g.: VERSION=0.3.5
    ```

* To install the *prometheus-service*, execute: 

    ```console
    kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/prometheus-service/$VERSION/deploy/service.yaml
    ```

 * Execute the following command to set up the rules for the *Prometheus Alerting Manager*:

    ```
    keptn configure monitoring prometheus --project=PROJECTNAME --service=SERVICENAME
    ```




