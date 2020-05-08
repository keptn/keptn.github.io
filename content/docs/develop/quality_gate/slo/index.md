---
title: Service Level Objectives (SLO)
description: Configure and add Service Level Objectives (SLO) to your service.
weight: 1
---

The Service Level Objective (SLO) configuration specifies a target value or range of values for a service level that is measured by [Service Level Indicators (SLI)](../sli). 

## Service Level Objective

* An SLO is defined per service.
* An SLO consists of a filter that uniquely identifies a deployment of a service.
* An SLO defines objectives for the service that depend on the selected comparison strategy. 
* An SLO returns a score represented by a value between 0 and 100. 

**Example of Service Level Objective (SLO):**

```yaml
spec_version: '1.0'
filter:
  mz_id: "4711"
  svc_id: "a14b-cd87-0d51"
comparison:
  compare_with: "single_result"
  include_result_with_score: "pass"
  aggregate_function: avg
objectives:
  - sli: response_time_p95
    pass:
      - criteria:
          - "<=+10%"
          - "<1000"
    warning:
      - criteria:
          - "<=800"
total_score:
  pass: "90%"
  warning: "75%"
```

### Filter
This property allows a list of key-value pairs that are used to uniquely identify a deployment of a service. This means that the key of a filter can be used as a placeholder in an SLI query. For example, the filter `svc_id: "a14b-cd87-0d51"` specifies a unique identifier of the deployment of a service. Consequently, the key of the filter (i.e., `svc_id`) can be referenced in an SLI query by `$svc_id`. 

The filters *project*, *stage*, *service*, and *deployment* can be inferred from the Keptn configuration by using `$PROJECT`, `$STAGE`, `$SERVICE`, and `$DEPLOYMENT` in SLI queries respectively. These values can also be overwritten in the configuration. The default filters are:

* project
* stage
* service
* deployment

**Example of an SLO with a list of filters:**
```yaml
spec_version: '1.0'
filter:
  mz_id: "4711"
  svc_id: "a14b-cd87-0d51"
comparison:
...
```

**Example of an SLI with reference to the `mz_id` filter from the SLO:**
```yaml
spec_version: "1.0"
indicators:
  throughput: "builtin:service.requestCount.total:merge(0):count?scope=tag(keptn_service:$SERVICE),mzId($mz_id)"
```

### Comparison
By default, Keptn compares with the previous values of the SLIs. To support more advanced comparion strategies, the following properties are available: 

* The **compare_with** config parameter controls how many previous results are compared: `single_result` or `several_results`. 

* The **number_of_comparison_results** config parameter configures the actual number of previous results if `compare_with` is set to `several_results`.

* The **include_result_with_score** config parameter controls which of the previous results are included in the comparison: `pass`, `pass_or_warn`, or `all` (`all` is the default, also used if not specified). 

**Note:** If you configure `compare_with: "single_result"` in combination with number_of_comparison_results, compare_with will negate the number_of_comparison_results. 

**1. Example:**

```yaml
comparison:
  compare_with: "single_result"
  include_result_with_score: "pass"
  aggregate_function: avg
```
This comparison configuration means that the current result is only compared to the last result that passed. 

**2. Example:**

```yaml
comparison:
  compare_with: "several_results"
  number_of_comparison_results: 3
  include_result_with_score: "pass_or_warn"
  aggregate_function: "avg"
```

This comparison configuration means that the current result is compared to the average of the three previous results that had pass or warning as a result.

### Objectives
An objective consists of:

* The **SLI**  refers to an SLI from an SLI configuration. 
* The **pass** criteria represents the upper limit up to which an evaluation is successful.
* The (optional) **warning** criteria describes the border where the result is not pass and not fail, and a manual approval might be needed to decide.
* The (optional) **weight** criteri is used to emphasize the importance of one SLI over the others. By default, `weight` is 1 for all SLIs and can be overwritten. The weight is important for calculating the score later.
* The (optional) **key_sli** flag can be set to true meaning that the objective is not met if this SLI fails.

**Example of an Objective:**

```yaml
objectives:
  - sli: response_time_p95
    pass:
      - criteria:
          - "<=+10%"
          - "<1000"
    warning:
      - criteria:
          - "<=800"
    weight: 2
    key_sli: true
```

### Scoring
An evaluation for *pass* counts for one point, an evaluation for *warning* half a point, and an evaluation for *fail* zero points. The default weight of an SLI is 1 and can be overwritten. The maximum score is the sum of the weights of all SLIs.

The actual evaluation result is divided by the maximum score and gives the `total_score` in percent. For example, the maximum score is 92 and the evaluation result is 85 - the `total_score` is 92.39% (85/92*100).

The pass and warning criteria for the `total_score` use the logical operator ">=" by default.

## Add SLO configuration to a Service

**Important:** In the following command, the value of the `resourceUri` must be set to `slo.yaml`.

* To add an SLI configuration to a service, use the [keptn add-resource](../../reference/cli/commands/keptn_add-resource) command:

  ```console
  keptn add-resource --project=sockshop --stage=staging --service=carts --resource=slo-quality-gates.yaml --resourceUri=slo.yaml
  ```
