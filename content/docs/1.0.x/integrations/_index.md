---
title: Custom Integrations
description: Integrate your tools with Keptn
weight: 610
icon: setup
---

Keptn can orchestrate almost any tool that generates
[Cloud Events](../reference/miscellaneous/events/).
This is discussed in [Keptn and other tools](../../concepts/keptn-tools).
A tool must have an integration that defines
the `triggered`, `started`, and `finished` events
that Keptn and the tool use for communications.
This is discussed more fully in [Integration service](how_integrate).

A number of integrations are provided on the
[Integrations](../../integrations/) page.

The pages in this section describe how integrate a tool for which we do not have an integration.
Three different paradigms are supported and documented here:

* [Keptn Integration Service](custom_integration)
  is the original facility used to integrate external tools.
  It can be used for virtually any tool
  and is the only method supported for integrating an observability platform.

* [Job Executor Service](https://github.com/keptn-contrib/job-executor-service) (JES)
  is a simpler paradigm that can be used to integrate most tools
  other than observability platforms.

  JES can run any container image and can also run scripts such as Shell, Powershell, or Python scripts
  and can pass a list of files such as those that contain instructions for a testing tool.
  JES must be installed on a Kubernetes pod, either the one where the Keptn control plane runs
  or a different pod.
  To run an external tool, it starts a new container that runs as a task on your container.

* [Webhooks](webhooks) are useful if your external tool accepts Webhooks
  and runs a "fire and forget" facility,
  such as sending a notification to Slack or triggering a Jenkins job asynchronously.

It is generally easier to integrate a tool using JES and/or Webhooks.
JES is the more flexible option and can run most tools.
Note, however, that while JES can trigger an event, it cannot send the results back to Keptn.
You can, however, use JES and Webhooks together,
with Webhooks passing data back to Keptn.

Note also that, if you just need to capture some metrics from another tool,
you may be able to write a Python script that captures the metrics
and passes them to a backend such as Prometheus,
which is then used for evaluation using quality gates.
For a small demo of this method, see
[Demo: Quality gate evaluation using metrics from another tool](../define/infracost).

If your tool needs to generate [SLIs](../reference/files/sli) that Keptn uses for evaluation,
you need to create a [Custom SLI provicer](sli_provider).

If your tool executes actions used for remediation,
you must create a [Custom Action Provider](action_provider).
