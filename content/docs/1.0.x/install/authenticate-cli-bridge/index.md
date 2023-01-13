---
title: Authenticate Keptn CLI and Bridge
description: Authenticate the Keptn CLI and Bridge to your Keptn cluster
weight: 60
---

After you [instal Keptn](../helm-install),
you must authenticate the Keptn CLI and Bridge against the Keptn cluster.
To do this, you need to:

* Get the exposed Keptn endpoint
* Get the API token
* Run `keptn auth`, supplying the Keptn endpoint and API token

The Keptn endpoint and the API token  are created during the Keptn installation.

## Authenticate CLI on Linux and MacOS

Do the following from the shell:

1.  Get the Keptn endpoint from the `api-gateway-nginx`.
    Follow the instructions in [Choose access options](../access)
    to get the Keptn endpoint for the access option you are using
    and, optionally, storing that endpoint in an environment variable.

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

## Authenticate CLI on Windows

Do the folllowing in the Windows Command Line:

1. Set the environment variable `KEPTN_ENDPOINT`:

   ```
   set KEPTN_ENDPOINT=http://<ENDPOINT_OF_API_GATEWAY>/api
   ```

1. Get the Keptn API Token encoded in base64:

   ```
   kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token}
   ```


1. Save the encoded API token in a text file such as `keptn-api-token-base64.txt`.

1. Decode the file:

   ```
   certutil -decode keptn-api-token-base64.txt keptn-api-token.txt
   ```

1. Open the newly created file `keptn-api-token.txt`,
   copy the value, and paste it into the next command:

   ```
   set KEPTN_API_TOKEN=<your-token>
   ```

1. To authenticate the CLI against the Keptn cluster,
   use the [keptn auth](../../reference/cli/commands/keptn_auth) command:

   ```
   keptn.exe auth --endpoint=$Env:KEPTN_ENDPOINT --api-token=$Env:KEPTN_API_TOKEN
   ```

## Authenticate Keptn Bridge

After installing and exposing Keptn, you can access the Keptn Bridge by using a browser and navigating to the Keptn endpoint without the `api` path at the end of the URL.
You can also use the Keptn CLI to retrieve the Bridge URL using:

```
keptn status
```

The Keptn Bridge has [basic authentication](../../bridge/basic_authentication/)
enabled by default and the default user is `keptn` with an automatically generated password.

* To get the username for authentication, execute:

```
kubectl get secret -n keptn bridge-credentials -o jsonpath="{.data.BASIC_AUTH_USERNAME}" | base64 --decode
```

* To get the password for authentication, execute:

```
kubectl get secret -n keptn bridge-credentials -o jsonpath="{.data.BASIC_AUTH_PASSWORD}" | base64 --decode
```

* If you want to change the user and password for the authentication,
follow the instructions [here](../../bridge/basic_authentication/#enable-authentication/).

See [OpenID Authorization](../../bridge/oauth/)
for information about using OAUTH authorization for the Keptn Bridge.

