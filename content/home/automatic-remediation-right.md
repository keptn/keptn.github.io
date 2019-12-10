```console
remediations:
- name: cpu_usage
  actions:
  - action: scaling
    value: +1
- name: high_load
  actions:
  - action: enableFeature (staticContent)
```

```console
keptn add-resource --project=sockshop
--service=carts --stage=production
--resource=remediation.yaml
--resourceUri=remediation.yaml
```

```console
Remediation command
{
  "type": "sh.keptn.events.problem",
  "shkeptncontext":
    "08735340-6f9e-4b32-97ff-3b6c292bc509",
  "data": {
    "ImpactedEntity": "carts-primary",
    "ProblemTitle": "cpu_usage_sockshop_carts",
    "State": "OPEN"
  },
}

keptn send event --file=problem.json
```
