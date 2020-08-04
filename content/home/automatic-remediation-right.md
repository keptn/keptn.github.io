```console
apiVersion: spec.keptn.sh/0.1.4
kind: Remediation
metadata:
  name: serviceXYZ-remediation
spec:
  remediations:  
  - problemType: Response time degradation
    actionsOnOpen:
    - name: Scaling ReplicaSet by 1
      description: Scales the ReplicaSet of a Deployment
      action: scaling
      value: "1"
    - name: Toogle feature flag
      action: featuretoggle
      description: Toggles feature flag EnablePromotion
      value: 
        EnablePromotion: off
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
