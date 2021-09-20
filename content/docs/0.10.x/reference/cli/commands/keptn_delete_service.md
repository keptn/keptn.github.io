---
date: "2021-06-16T14:50:20+02:00"
title: "keptn delete service"
slug: keptn_delete_service
---
## keptn delete service

Deletes a service from a project

### Synopsis

Deletes a service from a project by deleting the configuration in the GIT repository.
Furthermore, if Keptn is used for continuous delivery (i.e. services have been onboarded), this command will also uninstall the associated Helm releases.


```
keptn delete service SERVICENAME --project=PROJECTNAME [flags]
```

### Examples

```
keptn delete service carts --project=sockshop
```

### Options

```
  -p, --project string   The project from which to delete the service
```

### Options inherited from parent commands

```
  -h, --help               help
      --mock               Disables communication to a Keptn endpoint
  -n, --namespace string   Specify the namespace where Keptn should be installed, used and uninstalled in (default "keptn")
  -q, --quiet              Suppresses debug and info messages
  -v, --verbose            Enables verbose logging to print debug messages
  -y, --yes                Assume yes for all user prompts
```

### SEE ALSO

* [keptn delete](../keptn_delete/)	 - Deletes a project

###### Auto generated by spf13/cobra on 16-Jun-2021