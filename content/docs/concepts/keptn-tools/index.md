---
title: Keptn and other tools
description: Understand how Keptn works with other tools
weight: 7
---

It is common to think about one tool _versus_ another.
Indeed, many vendors and other open source projects have such a page / table on their websites.
The phrase "keptn vs." may have brought you from a search engine to this page.
However, when dealing with Keptn, that mindset is not helpful or accurate.

> **Rather than "Keptn vs. ..." think "Keptn and ..."**

While Keptn includes some default services
(Helm, JMeter and Webhook services), usage of these tools is not mandatory.
They can be easily swapped for tooling you prefer.

Keptn is designed to be tool and vendor agnostic.
Keptn orchestrates and executes any tooling that you choose.
Tools, which Keptn calls "integrations", are triggered via [CloudEvents](https://cloudevents.io/).
This is an open specification for describing event data, and Keptn provides its own [event specification](https://github.com/keptn/spec) based on it.
It allows for interoperability and any kinds of integrations in the Keptn ecosystem.

## Start with the shipyard

Keptn's [shipyard](../../0.17.x/reference/files/shipyard) file is the blueprint for your Keptn environment.
While it may look like a pipeline, nowhere does it mention the tooling used to action each task.
This is deliberate and by design.
It is this factor that allows hot-swapping of tools.

Consider this stub of a *shipyard* file:

```
stages:
  - name: "dev"
    sequences:
      - name: "delivery"
        tasks:
          - name: "deployment"
          - name: "test"
          - name: "evaluation"
          - name: "release"
```

In this *shipyard* file, we can guess that, when we trigger the `delivery` sequence in the `dev` stage,
the `deployment` task will be executed.
But nowhere does the *shipyard* define what tool performs this task.
This is the flexibility of Keptn!
Keptn distributes an `sh.keptn.event.deployment.triggered` event
and your chosen tool simply listens for and reacts to that event.

Want to swap deployment tool? Easy - just remove the subscription for the original tool,
install the new service and configure it to listen for the task instead.

So... out-of-the-box, which tools listen for the tasks above?

* The Helm service listens for `deployment.triggered` events
* The JMeter service listens for `test.triggered` events
* The Lighthouse service listens for `evaluation.triggered` events
* The Helm service also listens for `release.triggered` events

You are not restricted to these task names.
Define whatever task names you need to implement your custom sequences.

Let's have a look at some comparisons between popular tooling.

## Keptn and Pipeline Tooling (Jenkins, Azure DevOps, CircleCI etc.)

At first glance, a Keptn sequence as expressed in the *shipyard* file
looks a lot like a pipeline.
But you are in full control of which tools execute for each task.

* For example, if one team wants CircleCI to action the deployment task.
you can have CircleCI listen for the `deployment.triggered` task and run an entire pipeline in response.
* If a different team uses Jenkins instead,
their project can have Jenkins listen for the `deployment.triggered` event.
The sequence is identical but the two teams are empowered to use different tooling.

## Keptn and Load Testing Tools (JMeter, NeoLoad, BlazeMeter, k6 etc.)

Out-of-the box, Keptn includes the JMeter service that listens for the `test.triggered` event.

Prefer a different load testing tool?
Uninstall the Jmeter Service and install a service that listens for the `test.triggered` event and you are done.

## Keptn and Observability Tools (Prometheus, Dynatrace, Splunk etc.)

Keptn uses observability tools (more generally, tools that provide metrics)
as the data source for monitoring during the `evaluation` task.
The `evaluation` task is an out-of-the-box Keptn feature
that provides a [quality gate](../quality_gates).
This quality gate can work with any metric from any tool.

During creation of a Keptn project,
Keptn is configured to know which backend metric provider it should use for this particular project.
For example, Prometheus may be chosen as the metric store.
You will also be required to install the relevant service
which listens for the `get-sli.triggered` cloudevent.

During the evaluation task, Keptn automatically issues a `get-sli.triggered` event.
Your metric provider then reacts and retrieves metrics from the backend of your choice.
After all, the Prometheus Service should know how to retrieve Prometheus metrics!

Just like any other Keptn service, if you want to change the monitoring provider,
simply uninstall the existing service (eg. Prometheus service)
and install the new service (eg. Dynatrace service).
Now quality gate metrics will be retrieved from Dynatrace and not Prometheus.

## Discover Integrations

Keptn comes pre-installed with services for:

* Helm
* JMeter
* Webhooks

All other existing Keptn integrations are listed on the
[Integrations](https://keptn.sh/docs/integrations/) page.

Don't see your tool listed? You have three options:

* Use the Webhook service to trigger your tool
* Use the [Job Executor Service](https://artifacthub.io/packages/keptn/keptn-integrations/job-executor-service)
to run your container or script
* Develop a custom Keptn service:

  * Use this [Go template](https://github.com/keptn-sandbox/keptn-service-template-go)
    to begin development of your Keptn service.
    Please follow the [contributions guide](https://github.com/keptn-sandbox/contributing)
    for contributing it to Keptn Sandbox.

  * Raise a GitHub issue and / or
  * Join the #help-integrations channel on Slack for guidance and assistance

More details are provided at the bottom of the Integrations page.

