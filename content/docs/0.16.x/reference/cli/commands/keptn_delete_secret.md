---
date: "2022-07-11T09:30:42+02:00"
title: "keptn delete secret"
slug: keptn_delete_secret
---
## keptn delete secret

Deletes a secret from the given scope

```
keptn delete secret SECRET_NAME --scope=my-scope" [flags]
```

### Examples

```
keptn delete secret SECRET_NAME --scope=my-scope"
```

### Options

```
  -s, --scope string   The scope of the secret (default "keptn-default")
```

### Options inherited from parent commands

```
      --config-file string   Specify custom Keptn Config file path (default: ~/.keptn/config)
  -h, --help                 help
      --mock                 Disables communication to a Keptn endpoint
  -n, --namespace string     Specify the namespace where Keptn should be installed, used and uninstalled in (default "keptn")
  -q, --quiet                Suppresses debug and info messages
  -v, --verbose              Enables verbose logging to print debug messages
  -y, --yes                  Assume yes for all user prompts
```

### SEE ALSO

* [keptn delete](../keptn_delete/)	 - Deletes a project

###### Auto generated by spf13/cobra on 11-Jul-2022
