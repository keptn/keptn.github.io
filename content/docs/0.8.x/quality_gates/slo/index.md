---
title: Service-Level Objectives (SLO)
description: Configure and add Service-Level Objectives (SLO) to your service.
weight: 15
keywords: [0.8.x-quality_gates]
---

The Service-Level Objective (SLO) configuration specifies a target value or range of values for a service level that is measured by [Service-Level Indicators (SLI)](../sli). 

## Service-Level Objective

* An SLO is defined per service.
* An SLO can contain a filter that can be used to uniquely identify a deployment of a service.
* An SLO defines objectives for the service that depend on the selected comparison strategy. 
* An SLO allows to define the total score, which have to be met in order to get a `pass` or `warning` evaluation result.

**Example of Service-Level Objective (SLO):**

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

* `compare_with`: Defines how many previous results are considered for the comparision: *single_result* or *several_results* (*single_result* is the default and is used if not specified).
* `include_result_with_score`: Controls which of the previous evaluations are included in the comparison. Therefore, this property accepts the values: *pass*, *pass_or_warn*, or *all* (*all* is the default and is used if not specified), which target the overall evaluation result and not the single SLI evaluation. In other words, the overall evaluation result decides whether SLI values are considered for the comparison or not.
* `number_of_comparison_results`: Defines the exact number of previous results to consider (1 is the default and is used if not specified).
* `aggregate_function` *(optional)*: Allows overriding the default aggregation function which is `avg`. 

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

* `sli`: Refers to the name of the SLI.
* `pass`: Represents the upper limit up to which an evaluation is successful. 
* `warning` *(optional)*: Describes the border where the result is not pass and not fail, and a manual approval might be needed to decide. 
* `weight` *(optional)*: Can be used to emphasize the importance of one SLI over the others. By default, `weight` is 1 for all SLIs and can be overwritten. The weight is important for calculating the score later. 
* `key_sli` *(optional)*: Can be set to true meaning that the objective is not met if this SLI fails.

**Configuring the criteria:**

The pass and warning criteria allow a list of boolean expressions with a logical operator [<, <=, >, >=] and a *absolute* or *relative* value. While the absolute value is a numberical number, the realtive value requires a (+/-) at the beginning and a % sign at the end, e.g.: `-10%`. 

* All boolean expressions in the list are combined with a logical AND. According to the next example, the pass criteria is met when its measured absolute value is below 1000 **and** the increase of the relative value is lower/equals 10 percent. 

```
pass:
  - criteria:
    - "<1000"
    - "<=+10%"
```

* The criteria of a pass and warning can also be splitted. This means that the two lists are combined with a logical OR. According to the next example, the pass criteria is met when either the measured absolute value is below 1000 **or** the increase of the relative value is lower/equals 10 percent. 

```
pass:
  - criteria:
    - "<1000"
  - criteria:
    - "<=+10%"
```

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
