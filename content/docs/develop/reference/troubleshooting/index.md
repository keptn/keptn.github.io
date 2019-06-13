---
title: Troubleshooting
description: The sections describes tips and tricks to deal with troubles that may occur when using keptn. 
weight: 30
keywords: [troubleshooting]
---

In this section, instructions are summarized that help to trouble shoot known issues that may occur when using keptn.

<!-- ## Knative Eventing -->

### Service does not receive event, even though it has been sent
<details><summary>Expand instructions</summary>
<p>

**Investigation:**

1. Check the logs of the *event-broker* using the [keptn's log](../keptnslog/) and looking for the current *keptnContext*, e.g., `keptnContext: 6177178624927956405`
1. The event-broker was not able to send an event to a channel, if the log shows:
    ```
    {"keptnContext":"6177178624927956405","message":"Error while sending request: Error: Request failed with status code 500","keptnService":"eventbroker","logLevel":"ERROR"}
    ```

**Reason:** 

Internal knative problem, seen with knative 0.4

**Solution:** 

1. Re-apply the channel, which should have received the event, e.g., the *problem* channel. The manifest is provided by the event-broker: 
    ```
    kubectl apply -f ./keptn/core/eventbroker/config/problem-channel.yaml
    ```

1. Re-apply the services that have a subscription to this channel, e.g., for the *problem* channel it is the *servicenow-service*: 
    ```
    kubectl apply -f keptn/install/scripts/keptn-services/servicenow-service/config/servicenow-service.yaml
    ```

1. (optional) Delete all pods in the *knative-eventing* namespace:
    ```
    kubectl delete pods --all -n knative-eventing
    ```
</p></details>

<!-- ## Control service is not available -->

### CLI command was not executed correctly
<details><summary>Expand instructions</summary>
<p>

**Investigation:**

The control service is not available at the time when a command was sent by the keptn CLI. 
The resulting response message will look similar to this:

```console
keptn onboard service --project=sockshop --values=values_carts.yaml
```

```console
Starting to onboard service
Onboard service was unsuccessful
Error: Post https://control.keptn.1xx.xxx.xx.xx.xip.io/service: dial tcp: lookup control.keptn.1xx.xxx.xx.xx.xip.io: no such host
``` 

**Reason:** 

The root cause of this issue is that during peak hours, xip.io is unfortunately not very reliable. Therefore, the host can not be resolved and the CLI will return this error.

**Solution:** 

Please wait a couple of minutes and retry. Since this is an external dependency, there is nothing to fix inside the keptn installation.

</p></details>