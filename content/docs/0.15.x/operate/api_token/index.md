---
title: API Token
description: Manage the API token of a Keptn installation.
weight: 80
---

In this section, the management of the API token of a Keptn installation is explained.

## Retrieve API Token

* To retrieve the API token of a running Keptn installation, execute:

    ```console
    kubectl get secret keptn-api-token -n keptn -ojsonpath='{.data.keptn-api-token}'
    ```

* To decode the retrieved API token, use means provided by the operating system:

    <details><summary>on Linux / macOS</summary>
    <p>

    ```console
    kubectl get secret keptn-api-token -n keptn -ojsonpath='{.data.keptn-api-token}' | base64 --decode
    ```

    </p>
    </details>

    <details><summary>on Windows</summary>
    <p>

    Please expand the corresponding section matching your CLI tool.

    <details><summary>PowerShell</summary>
    <p>

    For the Windows PowerShell, a small script is provided that installs the `PSYaml` module and sets the environment variables. Please note that the PowerShell might have to be started with **Run as Administrator** privileges to install the module.

  * Copy the following snippet and paste it in the PowerShell. The snippet will be automatically executed line by line.

        ```
        $tokenEncoded = $(kubectl get secret keptn-api-token -n keptn -ojsonpath='{.data.keptn-api-token}')
        [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($tokenEncoded))
        ```

    </p>
    </details>

    <details><summary>Command Line</summary>
    <p>

    In the Windows Command Line, a couple of steps are necessary.

    1. Get the Keptn API Token encoded in base64:

        ```console
        kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token}
        ```

        ```console
        abcdefghijkladfaea
        ```

    1. Take the encoded API token; it is the value from the key `keptn-api-token` (in this example, it is `abcdefghijkladfaea`) and save it in a text file, e.g.: `keptn-api-token-base64.txt`

    1. Decode the file using `certutil`:

        ```
        certutil -decode keptn-api-token-base64.txt keptn-api-token.txt
        ```

    1. Open the newly created file `keptn-api-token.txt`, in which you find the API token.

    </p>
    </details>
    </p>
    </details>

## Create API Token

* To create an API token, use means provided by the operating system:

    <details><summary>on Linux </summary>
    <p>

  * To generate an API token, use the following command and store it into the environment variable `KEPTN_API_TOKEN`:

        ```console
        KEPTN_API_TOKEN=$(tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 45)
        ```

  * To create an API token, execute:

        ```console
        kubectl create secret generic -n keptn keptn-api-token --from-literal=keptn-api-token="$KEPTN_API_TOKEN"
        ```

    </p>
    </details>

    <details><summary>on macOS</summary>
    <p>

  * To generate an API token, use the following command and store it into the environment variable `KEPTN_API_TOKEN`:

        ```console
        KEPTN_API_TOKEN=$(LC_CTYPE=C tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 45)
        ```

  * To create an API token, execute:

        ```console
        kubectl create secret generic -n keptn keptn-api-token --from-literal=keptn-api-token="$KEPTN_API_TOKEN"
        ```

    </p>
    </details>

    <details><summary>on Windows PowerShell</summary>
    <p>

  * To generate an API token, use the following command and store it into the environment variable `$Env:KEPTN_API_TOKEN`:

        ```console
        $Env:KEPTN_API_TOKEN =  Write-Output ( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 45  | % {[char]$_}) )
        ```

  * To create an API token, execute:

        ```console
        kubectl create secret generic -n keptn keptn-api-token --from-literal=keptn-api-token="$Env:KEPTN_API_TOKEN"
        ```

    </p>
    </details>

If you want to make use of a self provided API token during the installation of Keptn, you can use the  `tokenSecretName` helm value.
This will prevent Helm from generating a new secret on installation and instead will have helm use the secret you provided.

## Reset API Token

* To reset an API token of a Keptn installation, first delete the secret:

    ```console
    kubectl delete secret -n keptn keptn-api-token
    ```

* [Create a new API token](./#create-api-token) as explained above.

* Restart API service since it requires the new token:

    ```console
    kubectl delete pods -n keptn --selector=app.kubernetes.io/name=api-service
    ```

* Re-authenticate Keptn CLI as explained [here](../../reference/cli/commands/keptn_auth).

* **Don't forget** to replace the API token at tools that interact with the Keptn API, e.g., *Problem Notification* setting in Dynatrace or *WebHook* in Prometheus.
