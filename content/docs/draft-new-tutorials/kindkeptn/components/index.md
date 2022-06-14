---
title: Components The Kind Keptn
description: See what components are installed in TheKindKeptn
weight: 24
---

Congratulations, you are running the kind keptn, but what is actually installed?

1. A fully functioning kubernetes cluster
2. A web-based terminal window: `http://localhost:7681` (try `kubectl get namespaces`)
4. [Keptn](https://keptn.sh) installed in the `keptn` namespace
5. The keptn's UI (bridge) available at: `http://localhost/bridge`
6. The [job executor service](https://github.com/keptn-contrib/job-executor-service) installed in `keptn-jes` namespace
7. A keptn project created and linked to the Git upstream that you provided
8. A very basic "hello world" sequence has already been executed for you.

## Job Executor Service
The [job executor service](https://github.com/keptn-contrib/job-executor-service) (JES) is a handy service as it allows running any container, shell, powershell or python script for keptn tasks.

This demo uses the JES to spin up an `alpine` image and `echo Hello, world!` in response to the `sh.keptn.event.hello-world.triggered` event.

