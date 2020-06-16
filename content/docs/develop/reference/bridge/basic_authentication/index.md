---
title: Basic Authentication
description: Enable/Disable basic authentication
weight: 21
keywords: [bridge]
---

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

    <details><summary>*If you are using Keptn 0.6.1 or older, please click here.*</summary>
    <p>

    * Edit the deployment of the bridge using:

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

    </p>
    </details>


* Restart the pod of the Keptn Bridge by executing:

    ```console
    kubectl -n keptn delete pods --selector=run=bridge
    ```

### Disable Authentication

* To disable the basic authentication, delete the secret by executing: 

    ```console
    kubectl -n keptn delete secret bridge-credentials
    ```

* Restart the respective pod of the Keptn Bridge by executing:

    ```console
    kubectl -n keptn delete pods --selector=run=bridge
    ```
