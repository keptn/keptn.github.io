---
title: Prometheus
description: Set up Prometheus monitoring
weight: 2
icon: setup
---

To get the data required to evaluate the quality gates and allow self-healing in production, we must set up monitoring.
This requires installing *prometheus-service* in the same namespace
as the Keptn control plane.
It is also possible to fetch SLIs from a remote Prometheus installation
by installing one external *prometheus-server* for collecting metrics
and creating a secret to access the external *prometheus-server*.
These are the only use cases currently supported for Prometheus.
