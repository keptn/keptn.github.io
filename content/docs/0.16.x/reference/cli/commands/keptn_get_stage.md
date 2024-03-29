---
date: "2022-07-11T09:30:42+02:00"
title: "keptn get stage"
slug: keptn_get_stage
---
## keptn get stage

Get details of a stage

### Synopsis

Get all stages or details of a stage from a given Keptn project

```
keptn get stage [flags]
```

### Examples

```
keptn get stages --project=sockshop
NAME           CREATION DATE                 
staging        2020-04-06T14:37:45.210Z
production     2020-04-06T14:37:45.210Z

keptn get stage staging --project sockshop
NAME           CREATION DATE                 
staging        2020-04-06T14:37:45.210Z

```

### Options

```
      --project string   keptn project name
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

* [keptn get](../keptn_get/)	 - Displays an event or Keptn entities such as project, stage, or service

###### Auto generated by spf13/cobra on 11-Jul-2022
