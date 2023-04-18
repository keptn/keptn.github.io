---
title: Keptn 0.18.1
weight: 68
---

# Release Notes 0.18.1

Keptn 0.18.1 is a bugfix release that solves an issue while creating webhooks via the Bridge.

### Bug Fixes

* **bridge:** Fix invalid header property for webhook ([#8543](https://github.com/keptn/keptn/issues/8543)) ([#8547](https://github.com/keptn/keptn/issues/8547)) ([8540ae1](https://github.com/keptn/keptn/commit/8540ae16fdbc8df1ebba7ebc5e0a2f0bb97027c8))

<details>
<summary>Kubernetes Resource Data</summary>

### Resource Stats

| Name                | Container Name      | CPU Request | CPU Limit | RAM Request | RAM Limit | Image                                               |
| ------------------- | ------------------- | ----------- | --------- | ----------- | --------- | --------------------------------------------------- |
| keptn-mongo         | mongodb             | 200m        | 1000m     | 100Mi       | 500Mi     | docker.io/bitnami/mongodb:4.4.13-debian-10-r52      |
| api-gateway-nginx   | api-gateway-nginx   | 50m         | 100m      | 64Mi        | 128Mi     | docker.io/nginxinc/nginx-unprivileged:1.22.0-alpine |
| api-service         | api-service         | 50m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/api:0.18.1                          |
| approval-service    | approval-service    | 25m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/approval-service:0.18.1             |
| bridge              | bridge              | 25m         | 200m      | 64Mi        | 256Mi     | docker.io/keptn/bridge2:0.18.1                      |
| lighthouse-service  | lighthouse-service  | 50m         | 200m      | 128Mi       | 1Gi       | docker.io/keptn/lighthouse-service:0.18.1           |
| mongodb-datastore   | mongodb-datastore   | 50m         | 300m      | 32Mi        | 512Mi     | docker.io/keptn/mongodb-datastore:0.18.1            |
| remediation-service | remediation-service | 50m         | 200m      | 64Mi        | 1Gi       | docker.io/keptn/remediation-service:0.18.1          |
| resource-service    | resource-service    | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/resource-service:0.18.1             |
| secret-service      | secret-service      | 25m         | 200m      | 32Mi        | 64Mi      | docker.io/keptn/secret-service:0.18.1               |
| shipyard-controller | shipyard-controller | 50m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/shipyard-controller:0.18.1          |
| statistics-service  | statistics-service  | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/statistics-service:0.18.1           |
| statistics-service  | distributor         | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.18.1                  |
| webhook-service     | webhook-service     | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/webhook-service:0.18.1              |
| keptn-nats          | nats                | 200m        | 500m      | 500Mi       | 1Gi       | nats:2.8.4-alpine                                   |

</details>
