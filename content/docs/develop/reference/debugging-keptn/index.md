---
title: Debugging keptn
description: The sections describes instructions for debugging keptn
weight: 34
keywords: [troubleshooting]
---

In this section, we collect instructions for debugging keptn. These instructions should help 
to determine problems and solve them.

### Problems when installing keptn
<details><summary>Expand instructions</summary>
<p>

**Investigation:**

Here we can use the installation logs. The installation logs can be found in the folder `.keptn` in your Home directory, i.e., for Linux and Mac, the log file is located at `$HOME/.keptn/keptn-installer.log`.

- Check this log file for any messages which e.g. could indicate insufficient rights.
- If this log file does not end with "Installation of keptn complete", check whether the connection between the CLI and the installer was interrupted. 
    If the connection was interrupted you should see the `installer` deployment because the CLI was not able to delete the deployment after a successful installation.

    Obtain the `installer` deployment:

    ```console    
    kubectl get deployments
    ```
    ```console
    NAME        DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    installer   1         1         1            0           1m5s
    ```    

    Obtain the serving `installer` pod:
    ```console
    kubectl get pods 
    ```

    ```console
    NAME                        READY   STATUS    RESTARTS   AGE
    installer-xxxxxxxxxx-xxxxx   1/1     Running   0          4m54s
    ```

    Obtain the logs directly from the installer pod:
    ```console    
    kubectl logs installer-xxxxxxxxxx-xxxxx
    ```

</p></details>

### Problems when calling `keptn configure` or `keptn create project`
<details><summary>Expand instructions</summary>
<p>

**TODO:** Visualize the following steps as figures!

For debugging the commands `keptn configure` and `keptn create project`, the following steps can be executed and verified:

1. The `control-service` checks whether the message is correctly signed. Therefore, it uses the `authenticator-service`.
    - If the authentication of the CLI fails, check whether your CLI is configured to the correct keptn installation, i.e., by executing `keptn auth`.
1. The `control-service` posts the received event into the `keptn-channel`.
    - Check the availability of this channel using `kubectl get channels -n keptn`.
1. The `github-service` has a subscription called `github-service-keptn-channel-subscription` to this channel.
    - Check the subscription of this subscription using `kubectl get subscriptions -n keptn`.
1. For `keptn configure`, the `github-service` creates the `github-credentials` secret where the GitHub credentials are stored.
    - Check whether the secret is correctly created using `kubectl get secret github-credentials -oyaml -n keptn`. Note that the shown values are base64 decoded.
1. For `keptn create project`, the `github-service` creates the project storing the configuration.
    - Check on GitHub whether the project was created. Therefore, also check whether it contains branches for all stages specified in your shipyard file.
    - If the CLI shows any error messages, try a new project by either choosing a different name or by first deleting the project on GitHub.
1. For obtaining further insights, you can check the logs of the `github-service`.
    - Check the logs by executing `kubectl logs github-service-xxxxx-deployment-xxxxxxxxxx-xxxxx -n keptn -c user-container`

</p></details>

### Problems when calling `keptn send event new-artifact`
<details><summary>Expand instructions</summary>
<p>

**TODO:** Visualize the following steps as figures!

For debugging the command `keptn send event new-artifact`, the following steps can be executed and verified:

1. **control-service**
    1. The `control-service` checks whether the message is correctly signed. Therefore, it uses the `authenticator-service`.
        - If the authentication of the CLI fails, check whether your CLI is configured to the correct keptn installation, i.e., by executing `keptn auth`.
    1. The `control-service` posts the received event to the endpoint `http://event-broker.keptn.svc.cluster.local/keptn`.
        - Check whether the `eventbroker-service` received the event by using the keptn's bridge.
1. **eventbroker-service**
    1. The `eventbroker-service` posts this event into the `new-artifact` channel.
        - Check the availability of this channel using `kubectl get channels -n keptn`.
1. **github-service**
    1. The `github-service` has a subscription called `github-service-new-artifact-subscription` to this channel.
        - Check the subscription of this subscription using `kubectl get subscriptions -n keptn`.
        - Check whether the `github-service` received the event by using the keptn's bridge.
    1. The `github-service` sets a new image in the config project.
        - Check on GitHub whether the new image is set in the branch representing your first stage, e.g. in the `dev` branch. 
    1. The `github-service` sends a `configuration-changed` event to the endpoint `http://event-broker.keptn.svc.cluster.local/keptn`.
        - Check whether the `eventbroker-service` received the event by using the keptn's bridge.
1. **eventbroker-service**
    1. The `eventbroker-service` posts this event into the `configuration-changed` channel.
        - Check the availability of this channel using `kubectl get channels -n keptn`.
1. **helm-service**
    1. The `helm-service` has a subscription called `helm-service-configuration-changed-subscription` to this channel.
        - Check the subscription of this subscription using `kubectl get subscriptions -n keptn`.
        - Check whether the `helm-service` received the event by using the keptn's bridge.
    1. The `helm-service` deploys the new artifact.
        - Check whether the `helm-service` successfully deployed the new artifact by using the keptn's bridge.
        - Check whether the service deployed with the new artifact is available.
    1. The `helm-service` sends a `deployment-finished` event to the endpoint `http://event-broker.keptn.svc.cluster.local/keptn`.
        - Check whether the `eventbroker-service` received the event by using the keptn's bridge.
1. **eventbroker-service**
    1. The `eventbroker-service` posts this event into the `deployment-finished` channel.
        - Check the availability of this channel using `kubectl get channels -n keptn`.
1. **jmeter-service**
    1. The `jmeter-service` has a subscription called `jmeter-service-deployment-finished-subscription` to this channel.
        - Check the subscription of this subscription using `kubectl get subscriptions -n keptn`.
        - Check whether the `jmeter-service` received the event by using the keptn's bridge.
    1. The `jmeter-service` executes tests.
        - Check whether the `jmeter-service` successfully executed the tests by using the keptn's bridge.
    1. The `jmeter-service` either sends in case the tests are passed a `tests-finished` event or in case the tests are failed  an `evaluation-done` event
    to the endpoint `http://event-broker.keptn.svc.cluster.local/keptn`.
        - Check whether the `eventbroker-service` received the event by using the keptn's bridge.
1. **eventbroker-service**
    1. For the `tests-finished` event, the `eventbroker-service` posts this event into the `tests-finished` channel.
        - Check the availability of this channel using `kubectl get channels -n keptn`.
1. **pitometer-service**
    1. The `pitometer-service` has a subscription called `pitometer-service-tests-finished-subscription` to this channel.
        - Check the subscription of this subscription using `kubectl get subscriptions -n keptn`.
        - Check whether the `perfspec` file is available for the deployed service, e.g., for carts check whether in the folder `your_organization/carts/perfspec/perfspec.json` is available and 
        
        pthe `pitometer-service` can find the `perfspec` file. 
        - Check whether the `pitometer-service` received the event by using the keptn's bridge.
    1. The `pitometer-service` evaluates the test results and sends an `evaluation-done` event to the endpoint `http://event-broker.keptn.svc.cluster.local/keptn`.
        - Check whether the `eventbroker-service` received the event by using the keptn's bridge.
1. **eventbroker-service**
    1. The `eventbroker-service` posts the `evaluation-done` event either received from the `jmeter-service` or the `pitometer-service`
    into the `evaluation-done ` channel.
        - Check the availability of this channel using `kubectl get channels -n keptn`.
1. **gatekeeper-service**
    1. The `gatekeeper-service` has a subscription called `gatekeeper-service-evaluation-done-subscription` to this channel.
        - Check the subscription of this subscription using `kubectl get subscriptions -n keptn`.
        - Check whether the `gatekeeper-service` received the event by using the keptn's bridge.
    1. The `gatekeeper-service` evaluates the result of the tests and either promotes the artifact to the next stage by sending a `new-artifact` event 
    or makes a rollback by sending a `configuration-changed` event in case a blue/green deployment is used. 

</p></details>

**TODO:** Currently, we only provide debugging instructions. However, we do not address what the user should/can do when he/she determines an
deviations from the target state.