---
title: Delete a project
description: Delete Keptn project
weight: 30
keywords: [1.0.x-manage]
aliases:
---

To delete a Keptn project,
use the [keptn delete project](../../reference/cli/commands/keptn_delete_project) command:

  ```
  keptn delete project PROJECTNAME
  ```

Note that this command does not delete the Git upstream that is configured for this project.
nor are deployed services deleted.
To clean up all resources (existing deployments and Helm releases) created by Keptn,
you must delete all relevant namespaces from the Kubernetes cluster where Keptn is running.

To do this, execute the following command for each stage defined in the *shipyard* of the project.

```
`kubectl delete namespace <PROJECTNAME>-<STAGENAME>`
```

For example, to delete the namespaces for the `sockshop` project
that contains the stages `dev`, `staging` and `production`:

```
kubectl delete namespace sockshop-dev
kubectl delete namespace sockshop-staging
kubectl delete namespace sockshop-production
```

