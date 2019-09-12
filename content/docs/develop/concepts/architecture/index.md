---
title: Architecture
description: Learn about the architecture of Keptn
weight: 20
keywords: [keptn, architecture]
---

Keptn is a control plane for continuous delivery that runs on Kubernetes. It's built on [Knative](https://cloud.google.com/knative/) and uses a publish-subscribe pattern to forward events, like when a new container has been pushed to an artifact registry, to one or a number of Knative services that react to that event. To continue the continuous delivery workflow those services need to send an event to Keptn. The events that Keptn understands are documented [here](../../reference/custom-service/). All Keptn events follow the [cloudevents](https://cloudevents.io/) specification [v2](https://github.com/cloudevents/spec/tree/v0.2).

{{< popup_image link="./assets/architecture.jpg" caption="Keptn architecture">}}

Keptn has a number of core components that are set up during the installation of Keptn. [Istio](https://istio.io) and Knative are prerequisites. The CLI {{<emoji ":one:">}} needs to be installed on the local machine and is used to send commands to Keptn. To communicate with keptn you need to know a shared secret that is generated during the installation and verified in the authentication component {{<emoji ":two:">}}. On the server side, the control component {{<emoji ":three:">}} receives the commands from the CLI and executes the requested task. To that end, it mostly uses other internal services or forwards event to the internal event broker {{<emoji ":four:">}}.

External tools can communicate with keptn through the external eventbroker component {{<emoji ":five:">}}. Again, the external tool and keptn must share a secret to validate the authenticity of an event. For example, when a new container has been pushed to an artifact registry you usually can configure webhooks to notify others about that event. The external eventbroker understands a number of external events, transforms them to keptn events and forwards them to the internal eventbroker using an internal channel.

Tools and components that run in the Kubernetes cluster can communicate with keptn using the internal eventbroker. The internal eventbroker receives keptn events and forwards those events to the appropriate channels {{<emoji ":six:">}}, based on the event type. Each channel can have a number of subscribers {{<emoji ":seven:">}} that receive the event and can react to it. Subscribers are implemented with Knative services. Either the service executes a task as a reaction to the received event or it again transforms and forwards the event to a third party component {{<emoji ":eight:">}} that then executes a task. Either way, after the task is done, a new event must be sent to keptn to continue the continuous delivery workflow.
