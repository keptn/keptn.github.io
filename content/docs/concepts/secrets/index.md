---
title: Secret Service
description: Learn how to manage secrets in a Keptn cluster.
weight: 20
keywords: [keptn, use-cases]
---

The **Secret Service** is used to manage secrets in a Keptn Cluster.
It provides a simple API for creating, updating or deleting secrets in a specific secret backend such as Kubernetes or vault.

**NOTE:** The current implementation only supports [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) as a secret backend.

## Secret and Scopes

A secret created by the secret-service is bound to a scope.
A scope contains a set of capabilities which are a set of permissions.
Currently, scopes are hardcoded into a file called `scopes.yaml` which is read by the secret-service during startup.

The default scope for Keptn looks like this:

```
Scopes:
  keptn-default:
    Capabilities:
      keptn-secrets-default-read:
        Permissions:
          - get
  keptn-webhook-service:
    Capabilities:
      keptn-webhook-svc-read:
        Permissions:
          - get
  dynatrace-service:
    Capabilities:
      keptn-dynatrace-svc-read:
        Permissions:
          - get
```

In Kubernetes, *scope* maps to a Kubernetes *ServiceAccount* and a capability maps to a Kubernetes *Role*.

Based on the `scopes.yaml` file above, when a secret with scope `keptn-webhook-service` is created, the secret-service does the following:

- Creates a Kubernetes secret
- Creates a *Role* named `keptn-webhook-svc-read` containing rules to access the created secret with permissions `get`
- Creates a *Rolebinding* `keptn-webhook-service-rolebinding` with *subjects* set to the *ServiceAccount* named `keptn-webhook-service`

Thus, every Kubernetes Pod bound to the service account *keptn-webhook-service* is able to read the secret.

**NOTE:** The `scopes.yaml` must be modified manually in order to add, modify or delete any scopes.
Currently, no API endpoint is provided for that.
