---
title: Upgrade Keptn
description: Upgrade your Keptn to 0.8
weight: 5
aliases:
  - /docs/0.8.0/operate/upgrade/
---

## Upgrade from Keptn 0.7 to 0.8

1. Before starting the update, we strongly advise to create a backup of your Keptn projects. To do so, please follow the instructions in the [backup guide](../../operate/backup_and_restore).

1. To download and install the Keptn CLI for version 0.8, please refer to the [Install Keptn CLI](../install/#install-keptn-cli) section.

1. With the merge of [#2733](https://github.com/keptn/keptn/pull/2733), the Keptn CLI supports the auto discovery of namespaces that are created by Keptn CLI during Keptn Control plane installation using annotations and labels. To patch the existing namespace, Run the following command:

   * Using Kubectl

    ```
    kubectl patch namespace <NAMESPACE> -p "{\"metadata\": {\"annotations\": {\"keptn.sh/managed-by\": \"keptn\"}, \"labels\": {\"keptn.sh/managed-by\": \"keptn\"}}}"
    ```

   * Using Keptn CLI [upgrade command](../../reference/cli/commands/keptn_upgrade)

    ```
    keptn upgrade --patch-namespace
    ```

    *Note:* If you installed Keptn in a dedicated namespace, use the `-n` flag to select the namespace:

    ```
    keptn upgrade --patch-namespace -n <NAMESPACE>
    ```
