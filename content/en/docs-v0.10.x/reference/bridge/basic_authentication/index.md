---
title: Basic Authentication
description: Enable/Disable basic authentication
weight: 10
keywords: [0.10.x-bridge]
---

The Keptn Bridge has a basic authentication feature, which can be controlled by setting the following two environment variables in the deployment of the bridge:

* `BASIC_AUTH_USERNAME` - username
* `BASIC_AUTH_PASSWORD` - password

## Enable Authentication

* Basic authentication is enabled when executing the below command. The `bridge-credentials` secret can be configured with your username and password.
These two variables are used to set your credentials: `BASIC_AUTH_USERNAME` and `BASIC_AUTH_PASSWORD`.

    ```
    kubectl edit secrets -n keptn bridge-credentials
    ```

    **Example:**
    ```
    apiVersion: v1
    data:
        BASIC_AUTH_PASSWORD: myUserNameBase64Encoded=
        BASIC_AUTH_USERNAME: myPasswordBase64Encoded=
    kind: Secret
    metadata:
        creationTimestamp: "2021-08-24T11:15:59Z"
        name: bridge-credentials
        namespace: keptn
        resourceVersion: "23676055"
        selfLink: /api/v1/namespaces/keptn/secrets/bridge-credentials
        uid: 67cfe5c1-5555-427c-9c4a-e91c51b7e8ba
    type: Opaque
    ```

* Restart the pod of the Keptn Bridge by executing:

    ```console
    kubectl -n keptn rollout restart deployment bridge
    ```

## Disable Authentication

* To disable the basic authentication, delete the secret by executing:

    ```console
    kubectl -n keptn delete secret bridge-credentials
    ```

* Restart the pod of the Keptn Bridge by executing:

    ```console
    kubectl -n keptn rollout restart deployment bridge
    ```
