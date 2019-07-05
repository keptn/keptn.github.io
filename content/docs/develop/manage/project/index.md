---
title: Project
description: Learn how to create and delete a project in keptn.
weight: 20
keywords: [manage]
aliases:
---

Learn how to manage your projects in keptn.

## Create a project


Before onboarding a service, a project needs to be created. A project represents a repository in the GitHub organization that is used by keptn. This project contains branches representing the multi-stage environment (e.g., dev, staging, and production stage). In other words, the separation of stage configurations is based on repository branches. To describe each stage, a `shipyard.yaml` file is needed that specifies the name, deployment strategy, and test strategy as shown below:

```yaml
registry: sockshop
stages:
  - name: "dev"
    deployment_strategy: "direct"
    test_strategy: "functional"
  - name: "staging"
    deployment_strategy: "blue_green_service"
    test_strategy: "performance"
  - name: "production"
    deployment_strategy: "blue_green_service"
```

Create a project is simple with the [keptn CLI](../../reference/cli). 
```
keptn create project your_project shipyard.yml
```


## Delete a project

The keptn CLI does currently not support the deletion of a project. However, by following the next steps, a project can manually be removed:

- Delete the GitHub repository for your project, e.g., sockshop.
- Delete all namespaces that have been created by keptn in your Kubernetes cluster, e.g.,
  - sockshop-dev
  - sockhop-staging
  - sockshop-production
  
    by executing

  ```console
  kubectl delete namespace sockshop-dev sockshop-staging sockshop-production
  ```

- Delete the configuration map `keptn-orgs` that has been created during installation by executing

```console
kubectl delete configmap keptn-orgs -n keptn
```
