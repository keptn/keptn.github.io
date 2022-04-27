---
title: Install
description: Set up Prometheus monitoring
weight: 1
icon: setup
---

In order to evaluate the quality gates and allow self-healing in production, we must set up monitoring to get the needed data and fetch the values for the SLIs that are referenced in an SLO configuration.


## Prerequisites

- Keptn project and at least one onboarded service must be available.
- Keptn does not install or manage Prometheus and its components. Users must install *Prometheus* and *Prometheus Alert Manager* as a prerequisite.

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus --namespace default
```
- The *prometheus-service* (which will be deployed later) needs access to the Prometheus instance.
By default it uses the Prometheus instance running in the same name space as Keptn.
If you are using another, external Prometheus instance, create a secret containing the user, password, and url.
The secret must have the following format (please note the double-space indentation):

```yaml
    user: username
    password: ***
    url: http://prometheus-service.monitoring.svc.cluster.local:8080
```

If this information is stored in a file, e.g. `prometheus-creds.yaml`, the secret can be created with the following command.
Please note that there is a naming convention for the secret because this can be configured per **project**.
Thus, the secret must have the name `prometheus-credentials-<project>`.
Do not forget to replace the `<project>` placeholder with the name of your project:

```console
kubectl create secret -n keptn generic prometheus-credentials-<project> --from-file=prometheus-credentials=./prometheus-creds.yaml
```

For more details, see the [README for prometheus-service](https://github.com/keptn-contrib/prometheus-service#advanced-usage).

## Set up Prometheus Keptn integration

After creating a project and service, you can set up Prometheus monitoring and configure scrape jobs using the Keptn CLI.

* Replace the environment variable value according to the use case and apply the manifest

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
    # Prometheus Server Endpoint
    - name: PROMETHEUS_ENDPOINT
      value: "http://prometheus-server.monitoring.svc.cluster.local:80"
```

**Execute the following steps to install prometheus-service**

* Download the manifest of the prometheus-service:

```bash
wget https://raw.githubusercontent.com/keptn-contrib/prometheus-service/release-0.7.0/deploy/service.yaml
```

* Replace the environment variable value according to the use case and apply the manifest

```bash
kubectl apply -f service.yaml -n keptn
```

* Install Role and RoleBinding to permit the prometheus-service for performing operations in the Prometheus installed namespace:

```bash
kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/prometheus-service/release-0.7.0/deploy/role.yaml -n keptn
```

* Execute the following command which performs: 
  * an update of the Prometheus configuration to add scrape jobs for the service in the specified Keptn project
  * the defintion of alert rules based on the SLO configuration of that service in the various stages. *Please note:* If no SLO is available in a stage, no alert rule will be created. Besides, the alert will be firing after monitoring a violation of the SLO for more than 10 minutes. 

```bash
keptn configure monitoring prometheus --project=sockshop --service=carts
```

## Verify Prometheus setup in your cluster

* To verify that the Prometheus scrape jobs are correctly set up, you can access Prometheus by enabling port-forwarding for the prometheus-server:

```BASH
kubectl port-forward svc/prometheus-server 8080:80 -n default
```

Prometheus is then available on [localhost:8080/targets](http://localhost:8080/targets) where you can see the targets for the service.

{{< popup_image link="./assets/prometheus-targets.png" caption="Prometheus Targets">}}


## Configure custom Prometheus SLIs

To tell the *prometheus-service* how to acquire the values of an SLI, the correct query needs to be configured. This is done by adding an SLI configuration to a project, stage, or service using the [add-resource](../../../reference/cli/commands/keptn_add-resource) command. The resource identifier must be `prometheus/sli.yaml`.

* In the below example, the SLI configuration as specified in the `sli-config-prometheus.yaml` file is added to the service `carts` in stage `hardening` from project `sockshop`. 

```console
keptn add-resource --project=sockshop --stage=hardening --service=carts --resource=sli-config-prometheus.yaml --resourceUri=prometheus/sli.yaml
```

**Note:** The add-resource command can be used to store a configuration on project-, stage-, or service-level. If you store SLI configurations on different levels, see [Add SLI configuration to a Service, Stage, or Project](../../../quality_gates/sli/#add-sli-configuration-to-a-service-stage-or-project) to learn which configuration overrides the others based on an example.

**Example for custom SLI:** 

Please take a look at this snippet, which implements a concrete SLI configuration to learn more about the structure of a SLI file. It is possible to use placeholders such as `$PROJECT`, `$SERVICE`, `$STAGE` and `$DURATION_SECONDS` in the queries.

```yaml
---
spec_version: '1.0'
indicators:
  response_time_p50: histogram_quantile(0.5, sum by(le) (rate(http_response_time_milliseconds_bucket{job="$SERVICE-$PROJECT-$STAGE"}[$DURATION_SECONDS])))
  response_time_p90: histogram_quantile(0.9, sum by(le) (rate(http_response_time_milliseconds_bucket{job="$SERVICE-$PROJECT-$STAGE"}[$DURATION_SECONDS])))
  response_time_p95: histogram_quantile(0.95, sum by(le) (rate(http_response_time_milliseconds_bucket{job="$SERVICE-$PROJECT-$STAGE"}[$DURATION_SECONDS])))
```
