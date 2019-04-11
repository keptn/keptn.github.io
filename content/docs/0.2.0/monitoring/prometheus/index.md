---
title: Setup Prometheus
description: How to setup Prometheus monitoring.
weight: 10
icon: setup
keywords: setup
---

In order to evaluate the quality gates, we have to set up monitoring to provide the needed data.

For this example, we will use Prometheus to monitor and evaluate our onboarded carts service:

**TODO: VERIFY IF CARTS SERVICE HAS TO BE DEPLOYED FIRST OR PROMETHEUS CAN BE INSTALLED AS A FIRST STEP**

  - In the examples folder you have cloned during [onboarding the carts service](../../usecases/onboard-carts-service/), navigate to the directory `monitoring/prometheus`. In this directory, you will find a script called `deployPrometheus.sh`. This script will deploy Prometheus in the namespace `monitoring` and set up scrape job configurations for monitoring the carts service in the `dev`, `staging` and `production` namespace. Execute that script by calling:

  ```console
  $ ./deployPrometheus.sh
  namespace "monitoring" created
  configmap "prometheus-server-conf" created
  clusterrole.rbac.authorization.k8s.io "prometheus" created
  clusterrolebinding.rbac.authorization.k8s.io "prometheus" created
  deployment.extensions "prometheus-deployment" created
  service "prometheus-service" created
  ```

To verify the Prometheus installation, you can browse to the Prometheus web interface:

- First, enable port-forwarding for the `prometheus-service`:

```console
kubectl port-forward svc/prometheus-service 8080 -n monitoring
```

- Afterwards, open the URL [localhost:8080/targets](http://localhost:8080/targets) in your browser. Here you should see three targets for the carts service:

    {{< popup_image
      link="./assets/prometheus-targets.png"
      caption="Prometheus Targets">}}


