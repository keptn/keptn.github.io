---
title: Setup Prometheus
description: How to setup Prometheus monitoring.
weight: 10
icon: setup
keywords: setup
---

In order to evaluate the quality gates, we have to set up monitoring to provide the needed data.

1. Checkout the needed files.

    - If you have not yet onboarded the carts service, please execute the following commands to receive the needed files:
        ```
        cd ~
        git clone https://github.com/keptn/examples.git
        cd ~/examples/monitoring/prometheus
        ```

    - If you already have [onboarded the carts service](../../usecases/onboard-carts-service/), navigate to the directory `monitoring/prometheus`. 

1. In this directory, you will find a script called `deployPrometheus.sh`. This script will deploy Prometheus in the namespace `monitoring` and set up scrape job configurations for monitoring the carts service in the `dev`, `staging`, and `production` namespace. Execute that script by calling:

    ```console
    ./deployPrometheus.sh
    
    namespace "monitoring" created
    configmap "prometheus-server-conf" created
    clusterrole.rbac.authorization.k8s.io "prometheus" created
    clusterrolebinding.rbac.authorization.k8s.io "prometheus" created
    deployment.extensions "prometheus-deployment" created
    service "prometheus-service" created
    ```

To verify the Prometheus installation, you can browse to the Prometheus web interface:

1. First, enable port-forwarding for the `prometheus-service`:

    ```console
    kubectl port-forward svc/prometheus-service 8080 -n monitoring
    ```

1. Afterwards, open the URL [localhost:8080/targets](http://localhost:8080/targets) in your browser. Here you should see three targets for the carts service:

    {{< popup_image
      link="./assets/prometheus-targets.png"
      caption="Prometheus Targets">}}

    Please note that if you have not onboarded the carts service yet, the Prometheus dashboard will report _down_ in the state column.

