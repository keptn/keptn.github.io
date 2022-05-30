---
title: distributor.yaml
description: Define a distributor
weight: 125
---

You can create your own distributor by writing a dedicated distributor deployment yaml:

## Syntax

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: some-service-monitoring-configure-distributor
  namespace: keptn
spec:
  selector:
    matchLabels:
      run: distributor
  replicas: 1
  template:
    metadata:
      labels:
        run: distributor
    spec:
      containers:
        - name: distributor
          image: keptndev/distributor:0.15.0
          ports:
            - containerPort: 8080
          resources:
            requests:
              memory: "32Mi"
              cpu: "50m"
            limits:
              memory: "128Mi"
              cpu: "500m"
          env:
            - name: PUBSUB_URL
              value: 'nats://keptn-nats'
            - name: PUBSUB_TOPIC
              value: 'sh.keptn.internal.event.some-event'
            - name: PUBSUB_RECIPIENT
              value: '127.0.0.1`'
```
~               

`

## Usage notes

## Differences between versions

## See also

* [Write a Keptn-service](../../../integrations/custom_integration)
* [distributor](../miscellaneous/distributor)
* [distributor source code](https://github.com/keptn/keptn/tree/master/distributor)



