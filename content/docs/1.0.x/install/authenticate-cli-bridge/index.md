---
title: Authenticate Keptn CLI and Bridge
description: Authenticate the Keptn CLI and Bridge to your Keptn cluster
weight: 60
---

To authenticate and associate the Keptn CLI and Keptn bridge to your Keptn cluster,
you need the exposed Keptn endpoint and API token.
The endpoint values and the method of querying them
are determined by the access options you use.
See [Choose access options](../access) for details.

## Get the Keptn endpoint

To authenticate the Keptn CLI against the Keptn cluster,
the exposed Keptn endpoint and API token are required. 
After [installing Keptn](../helm-install), you already have your Keptn endpoint.


Get the Keptn endpoint from the `api-gateway-nginx`.
If you are using port-forward to expose Keptn,
your endpoint is `localhost` and the `port` to which you forwarded Keptn
such as `http://localhost:8080`.)

   ```
   kubectl -n keptn get service api-gateway-nginx
   ```

   ```
   NAME                TYPE        CLUSTER-IP    EXTERNAL-IP                  PORT(S)   AGE
   api-gateway-nginx   ClusterIP   10.117.0.20   <ENDPOINT_OF_API_GATEWAY>    80/TCP    44m
   ```


## Get API Token and Authenticate Keptn CLI

**On Linux and MacOS**

1. Set the environment variable `KEPTN_API_TOKEN`:

   ```
   KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn `
       -ojsonpath={.data.keptn-api-token} | base64 --decode)
   ```

1. To authenticate the CLI against the Keptn cluster,
   use the [keptn auth](../../reference/cli/commands/keptn_auth) command:

   ```
   keptn auth --endpoint=$KEPTN_ENDPOINT --api-token=$KEPTN_API_TOKEN
   ```

   **Note**: If you receive a warning
   `Using a file-based storage for the key because the password-store seems to be not set up.`,
   it means that no password store could be found in your environment.
   In this case, the credentials are stored in `~/.keptn/.password-store` in your home directory.

**Using Windows PowerShell**

For the Windows PowerShell, a small script is provided
that installs the `PSYaml` module and sets the environment variables.

1. Set the environment variable `KEPTN_ENDPOINT`:

   ```
   $Env:KEPTN_ENDPOINT = 'http://<ENDPOINT_OF_API_GATEWAY>/api'
   ```

1. Copy the following snippet and paste it in the PowerShell.
   The snippet retrieves the API token and sets the environment variable `KEPTN_API_TOKEN`:

   ```
   $tokenEncoded = $(kubectl get secret keptn-api-token -n keptn -ojsonpath='{.data.keptn-api-token}')
   $Env:KEPTN_API_TOKEN = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($tokenEncoded))
   ```

1. To authenticate the CLI against the Keptn cluster,
   use the [keptn auth](../../reference/cli/commands/keptn_auth) command:

   ```
   keptn auth --endpoint=$Env:KEPTN_ENDPOINT --api-token=$Env:KEPTN_API_TOKEN
   ```

**Using the Windows Command Line**

In the Windows Command Line, do the following:

1. Set the environment variable `KEPTN_ENDPOINT`:

   ```
   set KEPTN_ENDPOINT=http://<ENDPOINT_OF_API_GATEWAY>/api
   ```

1. Get the Keptn API Token encoded in base64:

   ```
   kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token}
   ```

   ```
   abcdefghijkladfaea
   ```

1. Save the encoded API token in a text file such as `keptn-api-token-base64.txt`.
   The encoded API token is the value from the key `keptn-api-token`;
   in this example, it is `abcdefghijkladfaea`.

1. Decode the file:

   ```
   certutil -decode keptn-api-token-base64.txt keptn-api-token.txt
   ```

1. Open the newly created file `keptn-api-token.txt`,
   copy the value, and paste it into the next command:

   ```
   set KEPTN_API_TOKEN=keptn-api-token
   ```

1. To authenticate the CLI against the Keptn cluster,
   use the [keptn auth](../../reference/cli/commands/keptn_auth) command:

   ```
   keptn.exe auth --endpoint=$Env:KEPTN_ENDPOINT --api-token=$Env:KEPTN_API_TOKEN
   ```
## Authenticate Keptn Bridge

After installing and exposing Keptn, you can access the Keptn Bridge by using a browser and navigating to the Keptn endpoint without the `api` path at the end of the URL.
You can also use the Keptn CLI to retrieve the Bridge URL using:

```console
keptn status
```

The Keptn Bridge has basic authentication enabled by default and the default user is `keptn` with an automatically generated password.

* To get the username for authentication, execute:

```console
kubectl get secret -n keptn bridge-credentials -o jsonpath="{.data.BASIC_AUTH_USERNAME}" | base64 --decode
```

* To get the password for authentication, execute:

```console
kubectl get secret -n keptn bridge-credentials -o jsonpath="{.data.BASIC_AUTH_PASSWORD}" | base64 --decode
```

* If you want to change the user and password for the authentication,
follow the instructions [here](../../bridge/basic_authentication/#enable-authentication).

