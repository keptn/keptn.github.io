---
title: Webhook Service
description: Configuration for Webhook Service.
weight: 30
aliases:
  - /docs/0.16.0/operate/webhook_service/
---

## Block URLs and IPs

The Webhook service provides a way to block specific URLs and IPs. This list can be configured via the `ConfigMap` called `keptn-webhook-config`. Keptn looks for the `denyList` key in the config map to read the list of blocked URLs and IPs.
There must be a single URL/IP per line.

By default, Keptn is configured with the following list:

```
kubernetes
kubernetes.default
kubernetes.default.svc
kubernetes.default.svc.cluster.local
localhost
127.0.0.1
::1
```

For example, Keptn creates the following `ConfigMap`:

```yaml
apiVersion: v1
data:
  denyList: |-
    kubernetes
    kubernetes.default
    kubernetes.default.svc
    kubernetes.default.svc.cluster.local
    localhost
    127.0.0.1
    ::1
kind: ConfigMap
metadata:
  name: keptn-webhook-config
```
