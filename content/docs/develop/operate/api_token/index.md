---
title: API Token
description: Manage the API token of a Keptn installation.
weight: 35
keywords: [api, api-token]
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

    <details><summary>on Linux / macOS</summary>
    <p>

    * To generate a base64 encoded token use the following command and store it into the environment variable `KEPTN_API_TOKEN`: 

        ```console
        KEPTN_API_TOKEN=$(head -c 16 /dev/urandom | base64)
        ```

    * To create an API token, execute:
    
        ```console
        kubectl create secret generic -n keptn keptn-api-token --from-literal=keptn-api-token="$KEPTN_API_TOKEN"
        ```

    </p>
    </details>

    <details><summary>on Windows</summary>
    <p>

    Please expand the corresponding section matching your CLI tool.

    <details><summary>PowerShell</summary>
    <p>

    * To generate a base64 encoded token use the following command and store it into the environment variable `$Env:KEPTN_API_TOKEN`: 

        ```console
        [Reflection.Assembly]::LoadWithPartialName("System.Web")
        $token_bytes = [System.Text.Encoding]::Unicode.GetBytes([System.Web.Security.Membership]::GeneratePassword(16,2))
        $Env:KEPTN_API_TOKEN = [Convert]::ToBase64String($token_bytes)
        ```

    * To create an API token, execute:

        ```console
        kubectl create secret generic -n keptn keptn-api-token --from-literal=keptn-api-token="$Env:KEPTN_API_TOKEN"
        ``` 

    </p>
    </details>

    <details><summary>Command Line</summary>
    <p>

    In the Windows Command Line, a couple of steps are necessary.

    1. Generate a random token with at least 16 characters and save it in a text file: `keptn-api-token.txt`

    1. Encode the file using `certutil`:

        ```console
        certutil -encode keptn-api-token.txt keptn-api-token-base64.txt
        ```

    1. Open the newly created file `keptn-api-token-base64.txt`, in which you find the base64 encoded API token. Then set the environment variable `KEPTN_API_TOKEN`:

        ```console
        set KEPTN_API_TOKEN=
        ```

    1. To create an API token, execute:

        ```console
        kubectl create secret generic -n keptn keptn-api-token --from-literal=keptn-api-token="%KEPTN_API_TOKEN%"
        ``` 

    </p>
    </details>

    </p>
    </details>

## Reset API Token

* To reset an API token of a Keptn installation, first delete the secret:
  
    ```console
    kubectl delete secret -n keptn keptn-api-token
    ```

* [Create API token](./#create-api-token) as explained above. 

* Re-start API service since it requires the new token:

    ```console
    kubectl delete pods -n keptn --selector=run=api-service
    ```

* Re-authenticate Keptn CLI as explained [here](../cli/#authenticate-keptn-cli).

* **Don't forget** to replace the API token at tools that interact with the Keptn API, e.g., *Problem Notification* setting in Dynatrace or *WebHook* in Prometheus.