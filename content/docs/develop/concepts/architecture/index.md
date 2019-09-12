---
title: Architecture
description: Learn about the architecture of Keptn
weight: 20
keywords: [keptn, architecture]
---

Keptn is a control plane for continuous delivery that runs on Kubernetes. When installing Keptn on a Kubernetes cluster, core components, Tiller, and Istio are installed. Keptn itself follows an event-driven approach with the benefits of loosly coupled components and a flexible design that allows easily integrating other components and services. The events that Keptn understands are specified [here](https://github.com/keptn/keptn/blob/master/specification/cloudevents.md) and follow the [Cloud Events](https://cloudevents.io/) specification [v2](https://github.com/cloudevents/spec/tree/v0.2).

{{< popup_image link="./assets/architecture.png" caption="Keptn architecture">}}

## Prerequisites

During a Keptn installation, following components are installed on the Kubernetes cluster:

- [Istio](https://istio.io)  
- [Tiller](https://helm.sh/) 

## Keptn CLI
The Keptn CLI needs to be installed on the local machine and is used to send commands to Keptn. To communicate with Keptn you need to know a shared secret that is generated during the installation and verified by the *api* component.

**Note:** A dedicated Keptn CLI section is provided [here](../../reference/cli/), which helps you to get started and lists all commands that are currently available.

## Keptn core components 

Keptn has a number of core components that are set up during the installation.

### api

The api component provides a publicly exposed REST API that allows to communicate with Keptn. Thus, it receives the commands from the CLI and executes the requested task. The api component mostly uses other internal services or forwards events to the *eventbroker*.

### eventbroker

The eventbroker 

Tools and components that run in the Kubernetes cluster can communicate with keptn using the internal eventbroker. The internal eventbroker receives keptn events and forwards those events to the appropriate *distributor* {{<emoji ":six:">}}, based on the event type.

### distributor

A distributor can have one subscriber {{<emoji ":seven:">}} that receive the event and can react to it.

### mongodb-datastore

The mongodb-datastore

### bridge

The Keptn's bridge lets a user browse the Keptn's log by providing a user interface that shows all Keptn events and log messages correlated to those events.

**Note:** A dedicated section for the Keptn's bridge is provided [here](../../reference/keptnsbridge/), which explains how to access it and shows the user interface.

### configuration-service

### internal-keptn-services

- **shipyard-service:**

- **helm-service:**

- **wait-service:**

- **gatekeeper-service:**

- **remediation-service:**

