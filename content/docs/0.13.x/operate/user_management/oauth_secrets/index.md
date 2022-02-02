---
title: OpenID Session Secrets
description: Manage session and database encryption secret of your Keptn Bridge.
weight: 30
---

In this section, the management of the session and database encryption secret of the Keptn Bridge is explained.

- `session secret`: This secret is used to hash the session of the user.
- `database encryption secret`: This secret is used to encrypt the session in the database.

## Create session and database encryption secret

* To create the session and database encryption secret, use the following commands provided by the operating system:

    <details><summary>on Linux </summary>
    <p>

    * To generate the secrets, use the following commands and store them into the environment variables `OAUTH_SESSION_SECRET` and `OAUTH_DATABASE_ENCRYPT_SECRET`:

        ```console
        OAUTH_SESSION_SECRET=$(tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 45)
        OAUTH_DATABASE_ENCRYPT_SECRET=$(tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 32)
        ```

    * To create the secrets, execute:

        ```console
        kubectl create secret generic -n keptn bridge-oauth --from-literal=OAUTH_SESSION_SECRET="$OAUTH_SESSION_SECRET" --from-literal=OAUTH_DATABASE_ENCRYPT_SECRET="$OAUTH_DATABASE_ENCRYPT_SECRET"
        ```

    </p>
    </details>

    <details><summary>on macOS</summary>
    <p>

    * To generate the secrets, use the following commands and store them into the environment variables `OAUTH_SESSION_SECRET` and `OAUTH_DATABASE_ENCRYPT_SECRET`:

        ```console
        OAUTH_SESSION_SECRET=$(LC_CTYPE=C tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 45)
        OAUTH_DATABASE_ENCRYPT_SECRET=$(LC_CTYPE=C tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 32)
        ```

    * To create the secrets, execute:

        ```console
        kubectl create secret generic -n keptn bridge-oauth --from-literal=OAUTH_SESSION_SECRET="$OAUTH_SESSION_SECRET" --from-literal=OAUTH_DATABASE_ENCRYPT_SECRET="$OAUTH_DATABASE_ENCRYPT_SECRET"
        ```

    </p>
    </details>

    <details><summary>on Windows PowerShell</summary>
    <p>

    * To generate the secrets, use the following commands and store them into the environment variables `$Env:OAUTH_SESSION_SECRET` and `$Env:OAUTH_DATABASE_ENCRYPT_SECRET`:

        ```console
        $Env:OAUTH_SESSION_SECRET =  Write-Output ( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 45  | % {[char]$_}) )
        $Env:OAUTH_DATABASE_ENCRYPT_SECRET =  Write-Output ( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32  | % {[char]$_}) )
        ```

    * To create the secrets, execute:

        ```console
        kubectl create secret generic -n keptn bridge-oauth --from-literal=OAUTH_SESSION_SECRET="$Env:OAUTH_SESSION_SECRET" --from-literal=OAUTH_DATABASE_ENCRYPT_SECRET="$Env:OAUTH_DATABASE_ENCRYPT_SECRET"
        ```

    </p>
    </details>

## Reset session and database encryption secret

* To reset the session and the database encryption secret of a Keptn installation, first delete the secret:

    ```console
    kubectl delete secret -n keptn bridge-oauth
    ```

* [Create the secrets](./#create-session-and-database-encryption-secret) as explained above.

* Re-start the Keptn Bridge since it requires new secrets:

    ```console
    kubectl delete pods -n keptn --selector=app.kubernetes.io/name=bridge
    ```
