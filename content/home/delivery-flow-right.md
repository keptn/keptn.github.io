```console
stages:
  - name: "dev"
    deployment_strategy: "direct"
    test_strategy: "functional"
  - name: "staging"
    approval_strategy: 
      pass: "automatic"
      warning: "manual"
    deployment_strategy: "blue_green_service"
    test_strategy: "performance"
  - name: "production"
    approval_strategy:
      pass: "manual"
      warning: "manual"
    deployment_strategy: "blue_green_service"
    remediation_strategy: "automated"
```
