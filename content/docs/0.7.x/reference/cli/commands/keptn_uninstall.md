---
date: "2020-10-12T14:26:31+02:00"
title: "keptn uninstall"
slug: keptn_uninstall
---
## keptn uninstall

Uninstalls Keptn from a Kubernetes cluster

### Synopsis

Uninstalls Keptn from a Kubernetes cluster.

This command does *not* delete: 

* Dynatrace monitoring
* Prometheus monitoring
* Any (third-party) service installed in addition to Keptn (e.g., notification-service, slackbot-service, ...)

Besides, deployed services and the configuration on the Git upstream (i.e., GitHub, GitLab, or Bitbucket) are not deleted. To clean-up created projects and services, please see [Delete a project](https://v1.keptn.sh/docs/0.7.x/manage/project/#delete-a-project).

**Note:** This command requires a *Kubernetes current context* pointing to the cluster where Keptn should get uninstalled from.


```
keptn uninstall [flags]
```

### Examples

```
keptn uninstall
```

### Options

```
  -h, --help                       help for uninstall
  -s, --insecure-skip-tls-verify   Skip tls verification for kubectl commands
  -n, --namespace string           Specify the namespace Keptn should be installed in (default keptn). (default "keptn")
```

### Options inherited from parent commands

```
      --mock                 Disables communication to a Keptn endpoint
  -q, --quiet                Suppresses debug and info messages
      --suppress-websocket   Disables WebSocket communication to suppress info messages from services running inside Keptn
  -v, --verbose              Enables verbose logging to print debug messages
```

### SEE ALSO

* [keptn](../keptn/)	 - The CLI for using Keptn

###### Auto generated by spf13/cobra on 12-Oct-2020
