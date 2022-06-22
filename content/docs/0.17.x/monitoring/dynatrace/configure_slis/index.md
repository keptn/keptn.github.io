---
title: Configure SLIs
description: Configure Dynatrace SLIs
weight: 3
icon: setup
---

To tell the *dynatrace-service* how to acquire the values of an SLI, the correct query needs to be configured. This is done by adding an SLI configuration to a project, stage, or service using the [add-resource](../../../reference/cli/commands/keptn_add-resource/) command. The resource identifier must be `dynatrace/sli.yaml`.

* In the following example, the SLI configuration as specified in the `sli-config-dynatrace.yaml` file is added to the service `carts` in stage `hardening` from project `sockshop`.

```console
keptn add-resource --project=sockshop --stage=hardening --service=carts --resource=sli-config-dynatrace.yaml --resourceUri=dynatrace/sli.yaml
```

**Note:** The add-resource command can be used to store a configuration on project-, stage-, or service-level. If you store SLI configurations on different levels, see [Add SLI configuration to a Service, Stage, or Project](../../../reference/files/sli/#add-sli-configuration-to-a-service-stage-or-project) to learn which configuration overrides the others based on an example.

**Example for custom SLIs:**

If you want to add your custom SLIs, take a look at the following example, which can be used as a template for your SLIs:

```yaml
---
spec_version: '1.0'
indicators:
  throughput: "metricSelector=builtin:service.requestCount.total:merge(\"dt.entity.service\"):sum&entitySelector=type(SERVICE),tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
  error_rate: "metricSelector=builtin:service.errors.total.count:merge(\"dt.entity.service\"):avg&entitySelector=type(SERVICE),tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
  response_time_p50: "metricSelector=builtin:service.response.time:merge(\"dt.entity.service\"):percentile(50)&entitySelector=type(SERVICE),tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
  response_time_p90: "metricSelector=builtin:service.response.time:merge(\"dt.entity.service\"):percentile(90)&entitySelector=type(SERVICE),tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
  response_time_p95: "metricSelector=builtin:service.response.time:merge(\"dt.entity.service\"):percentile(95)&entitySelector=type(SERVICE),tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
```
