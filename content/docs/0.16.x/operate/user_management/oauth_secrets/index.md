---
title: OpenID Session Secrets
description: Manage session and database encryption secret of your Keptn Bridge.
weight: 30
---

This section explains the management of the session and database encryption secrets of the Keptn Bridge.

- `session secret`: Used to hash the session of the user.
- `database encryption secret`: Used to encrypt the session in the database.

## Create session and database encryption secret

- To create the session and database encryption secret, use the following commands provided by the operating system:

    <details><summary>on Linux </summary>
    <p>

  - Use the following commands to generate the secrets and store the results into the environment variables `session_secret` and `database_encrypt_secret`

        ```console
        session_secret=$(tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 45)
        database_encrypt_secret=$(tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 32)
        ```

  - To create the secrets, execute:

        ```console
        kubectl create secret generic -n keptn bridge-oauth --from-literal=session_secret="$session_secret" --from-literal=database_encrypt_secret="$database_encrypt_secret"
        ```

    </p>
    </details>

    <details><summary>on macOS</summary>
    <p>

  - Use the following commands to generate the secrets and store the results into the environment variables `session_secret` and `database_encrypt_secret`

        ```console
        session_secret=$(LC_CTYPE=C tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 45)
        database_encrypt_secret=$(LC_CTYPE=C tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 32)
        ```

  - To create the secrets, execute:

        ```console
        kubectl create secret generic -n keptn bridge-oauth --from-literal=session_secret="$session_secret" --from-literal=database_encrypt_secret="$database_encrypt_secret"
        ```

    </p>
    </details>

    <details><summary>on Windows PowerShell</summary>
    <p>

  - Use the following commands to generate the secrets and store the results into the environment variables `session_secret` and `database_encrypt_secret`

        ```console
        $Env:session_secret =  Write-Output ( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 45  | % {[char]$_}) )
        $Env:database_encrypt_secret =  Write-Output ( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32  | % {[char]$_}) )
        ```

  - To create the secrets, execute:

        ```console
        kubectl create secret generic -n keptn bridge-oauth --from-literal=session_secret="$Env:session_secret" --from-literal=database_encrypt_secret="$Env:database_encrypt_secret"
        ```

    </p>
    </details>

## Reset session and database encryption secret

- To reset the session and the database encryption secret of a Keptn installation, first delete the secret:

    ```console
    kubectl delete secret -n keptn bridge-oauth
    ```

- [Create the secrets](./#create-session-and-database-encryption-secret) as explained above.

- Re-start the Keptn Bridge to fetch the new secrets:

    ```console
    kubectl delete pods -n keptn --selector=app.kubernetes.io/name=bridge
    ```
