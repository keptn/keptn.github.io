---
title: Keptn Bridge
description: Explains how the access the Keptn's Bridge.
weight: 21
keywords: [bridge]
---

The Keptn Bridge is the user interface of Keptn and presents all projects and services managed by Keptn. It is automatically installed with your Keptn deployment.

## Expose/Lockdown Bridge

The Keptn Bridge is not publicly accessible by default.

* To expose the Keptn Bridge, execute the following command. It is then available on: `https://bridge.keptn.YOUR.DOMAIN/`

```console
keptn configure bridge --action=expose
```

**Note:** This command shows the warning `Warning: Make sure to enable basic authentication as described here: ...`. Please follow the warning and enable basic authentication explained [below](./#enable-authentication).

* To lockdown the Keptn Bridge:

```console
keptn configure bridge --action=lockdown
```

## Configure Basic Authentication

The Keptn Bridge has a basic authentication feature, which can be controlled by setting the following two environment variables:

* `BASIC_AUTH_USERNAME` - username
* `BASIC_AUTH_PASSWORD` - password

### Enable Authentication

To enable this feature, a secret has to be created that holds the two variables. This secret has to be applied within the Kubernetes deployment for the Keptn Bridge.

* Create the secret using:

    ```console
    kubectl -n keptn create secret generic bridge-credentials --from-literal="BASIC_AUTH_USERNAME=<USERNAME>" --from-literal="BASIC_AUTH_PASSWORD=<PASSWORD>"
    ```

    **Note:** Replace `<USERNAME>` and `<PASSWORD>` with the desired credentials.

* If you are using Keptn 0.6.1 or older, edit the deployment using:

    ```console
    kubectl -n keptn edit deployment bridge
    ```
   
    * Add the secret to the `bridge` container, as shown below:

    ```yaml
    ...
    spec:
      containers:
      - name: bridge
        image: keptn/bridge2:0.6.1
        imagePullPolicy: Always
        # EDIT STARTS HERE
        envFrom:
          - secretRef:
              name: bridge-credentials
              optional: true
        # EDIT ENDS HERE
        ports:
        - containerPort: 3000
        ...
    ```

* Restart the pod of the Keptn Bridge by executing:

    ```console
    kubectl -n keptn scale deployment bridge --replicas=0
    kubectl -n keptn scale deployment bridge --replicas=1
    ```

### Disable Authentication

* To disable the basic authentication, delete the secret by executing: 

    ```console
    kubectl -n keptn delete secret bridge-credentials
    ```

* Restart the respective pod of the Keptn Bridge by executing:

    ```console
    kubectl -n keptn scale deployment bridge --replicas=0
    kubectl -n keptn scale deployment bridge --replicas=1
    ```

## Views in Keptn Bridge

### Project view

The Keptn's Bridge provides an easy way to browse all events that are sent within Keptn. When you access the Keptn's Bridge, all projects will be shown on the start screen. When clicking on a project, the stages of this project and all onboarded services are shown on the next view.

  {{< popup_image
  link="./assets/bridge_empty.png"
  caption="Keptn's Bridge project view">}}

When selecting one service, all events that belong to this service are listed on the right side. Please note that this list only represents the start of a deployment (or problem) of a new artifact. More information on the executed steps can be revealed when you click on one event.

### Event Stream

When selecting an event, the Keptn's Bridge displays all other events that are in the same Keptn context and belong to the selected entry point. As can be seen in the screenshot below, the entry point around 4:03 pm has been selected and all events belonging to this entry point are displayed on the right side.

  {{< popup_image
  link="./assets/bridge_details.png"
  caption="Keptn's Bridge event stream">}}


## Early Access Version of Keptn's Bridge

<!--
Right now there is no early access version of Keptn's Bridge available. You can upgrade to the latest version (0.6.1) by executing the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge:0.6.1 --record
kubectl -n keptn set image deployment/configuration-service bridge=keptn/configuration-service:0.6.1 --record
kubectl -n keptn-datastore set image deployment/mongodb-datastore mongodb-datastore=keptn/mongodb-datastore:0.6.1 --record
```
-->


There is an early access version of Keptn's Bridge available (compatible with Keptn 0.6.1):

  {{< popup_image
  link="./assets/bridge_eap.png"
  caption="Keptn's Bridge EAP">}}

To install it, you have to update the Docker images of *Keptn's Bridge*, *configuration-service* and the *mongodb-datastore* deployment by executing the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:20200402.1046 --record
```

If you want to access the new Keptn's Bridge you have to use `port-forward` again:

```console
kubectl port-forward svc/bridge -n keptn 9000:8080
```

If you want to restore the old version of bridge, configuration-service and mongodb-datastore (as delivered with Keptn 0.6.1), you can use the following commands:

```console
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:0.6.1 --record
```

If you have any questions or feedback regarding Keptn's Bridge, please contact us through our [Keptn Community Channels](https://github.com/keptn/community)!
