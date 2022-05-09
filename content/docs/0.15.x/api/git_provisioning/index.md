---
title: Automatic Git Provisioning
description: Automatically provision a Git repository when a project is created.
weight: 20
keywords: [git provisioning]
aliases:
  - /docs/0.15.x/api/git_provisioning
---


### Description

Keptn provides an extension point that can be used to automatically provision a Git repository.
When a project is created, Keptn will perform a call to the service that adheres to a specific HTTP REST interface. The swagger documentation for this API can be found [here](../../../../api/).

Keptn will call the service that implements such interface passing the project name and the current namespace in which Keptn runs. The service is expected to answer with the URL, username, and token to access the repository. Keptn will use this information to configure the upstream for the project.
Similarly, when a project is deleted, Keptn will call the service implementing such an API. This can be used to deprovision the repository and perform clean up actions.

This feature is enabled via the Helm value [`features.automaticProvisioningURL`](https://github.com/keptn/keptn/blob/0.15.0/installer/manifests/keptn/charts/control-plane/values.yaml#L26). This value must contain the base URL of the service that implements the interface.

---

### Resources

[Swagger Documentation](../../../../api/)