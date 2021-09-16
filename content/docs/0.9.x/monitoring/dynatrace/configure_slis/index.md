---
title: Configure SLIs
description: Configure Dynatrace SLIs
weight: 3
icon: setup
---

To tell the *dynatrace-service* how to acquire the values of an SLI, the correct query needs to be configured. This is done by adding an SLI configuration to a project, stage, or service using the [add-resource](../../../reference/cli/commands/keptn_add-resource/) command. The resource identifier must be `dynatrace/sli.yaml`.

* In the below example, the SLI configuration as specified in the `sli-config-dynatrace.yaml` file is added to the service `carts` in stage `hardening` from project `sockshop`. 

```console
keptn add-resource --project=sockshop --stage=hardening --service=carts --resource=sli-config-dynatrace.yaml --resourceUri=dynatrace/sli.yaml
```

**Note:** The add-resource command can be used to store a configuration on project-, stage-, or service-level. If you store SLI configurations on different levels, see [Add SLI configuration to a Service, Stage, or Project](../../../quality_gates/sli/#add-sli-configuration-to-a-service-stage-or-project) to learn which configuration overrides the others based on an example.

**Example for custom SLIs:**

If you want to add your custom SLIs, take a look at the following example, which can be used as a template for your SLIs:

```yaml
---
spec_version: '1.0'
indicators:
  throughput: "builtin:service.requestCount.total:merge(0):count?scope=tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
  error_rate: "builtin:service.errors.total.count:merge(0):avg?scope=tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
  response_time_p50: "builtin:service.response.time:merge(0):percentile(50)?scope=tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
  response_time_p90: "builtin:service.response.time:merge(0):percentile(90)?scope=tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
  response_time_p95: "builtin:service.response.time:merge(0):percentile(95)?scope=tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
```
