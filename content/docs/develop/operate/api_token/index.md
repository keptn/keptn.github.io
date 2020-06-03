---
title: API Token
description: Manage the API token of a Keptn installation.
weight: 12
keywords: [api, setup]
---

In this section, the functionality and commands of the Keptn REST API are described.

## Retrieve API Token

* To retrieve the API token of a running Keptn installation, execute: 

    ```console
    kubectl get secret keptn-api-token -n keptn -ojsonpath='{.data.keptn-api-token}'
    ``` 

* To decode the retrieved API token, use means offered by the operating system: 

    <details><summary>For Linux / macOS</summary>
    <p>

    Set the needed environment variables.

    ```console
    KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
    ```

    </p>
    </details>

    <details><summary>For Windows</summary>
    <p>

    Please expand the corresponding section matching your CLI tool.

    <details><summary>PowerShell</summary>
    <p>

    For the Windows PowerShell, a small script is provided that installs the `PSYaml` module and sets the environment variables. Please note that the PowerShell might have to be started with **Run as Administrator** privileges to install the module.

    * Copy the following snippet and paste it in the PowerShell. The snippet will be automatically executed line by line.

        ```
        $tokenEncoded = $(kubectl get secret keptn-api-token -n keptn -ojsonpath='{.data.keptn-api-token}')
        $Env:KEPTN_API_TOKEN = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($tokenEncoded))
        ```

    </p>
    </details>

    <details><summary>Command Line</summary>
    <p>

    In the Windows Command Line, a couple of steps are necessary.

    1. Get the Keptn API Token encoded in base64

        ```console
        kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token}
        ```

        ```console
        abcdefghijkladfaea
        ```

    1. Take the encoded API token - it is the value from the key `keptn-api-token` (in this example, it is `abcdefghijkladfaea`) and save it in a text file, e.g., `keptn-api-token-base64.txt`

    1. Decode the file

        ```
        certutil -decode keptn-api-token-base64.txt keptn-api-token.txt
        ```

    1. Open the newly created file `keptn-api-token.txt`, copy the value and paste it into the next command

        ```
        set KEPTN_API_TOKEN=keptn-api-token
        ```
    </p>
    </details>
    </p>
    </details>

## Create API Token

* To create an API token, execute:
  
    ```console
    KEPTN_API_TOKEN=$(head -n 16 /dev/urandom | base64)
    kubectl create secret generic -n keptn keptn-api-token --from-literal=keptn-api-token="$KEPTN_API_TOKEN"
    ```

## Reset API Token

* To reset an API token of a Keptn installation, first delete the secret:
  
    ```console
    kubectl delete secret -n keptn keptn-api-token
    ```

* Generate a token and create the secret: 

    ```console
    KEPTN_API_TOKEN=$(head -c 16 /dev/urandom | base64)
    kubectl create secret generic -n keptn keptn-api-token --from-literal=keptn-api-token="$KEPTN_API_TOKEN"
    ```

* Re-start API service since it requires the new token:

    ```console
    kubectl delete pods -n keptn --selector=run=api-service
    ```

* Re-authenticate Keptn CLI as explained [here](../cli/#authentication).