---
date: "2020-10-12T14:26:31+02:00"
title: "keptn generate docs"
slug: keptn_generate_docs
---
## keptn generate docs

Generates the markdown documentation for the Keptn CLI

### Synopsis

Generates markdown documentation for the Keptn CLI.

This command can be used to create an up-to-date documentation of the Keptn CLI and as published on: https://v1.keptn.sh/docs

It creates one markdown file per command, suitable for rendering in Hugo.


```
keptn generate docs [flags]
```

### Examples

```
keptn generate docs

keptn generate docs --dir=/some/directory
```

### Options

```
      --dir string   directory where the docs should be written to (default "./docs")
  -h, --help         help for docs
```

### Options inherited from parent commands

```
      --mock                 Disables communication to a Keptn endpoint
  -q, --quiet                Suppresses debug and info messages
      --suppress-websocket   Disables WebSocket communication to suppress info messages from services running inside Keptn
  -v, --verbose              Enables verbose logging to print debug messages
```

### SEE ALSO

* [keptn generate](../keptn_generate/)	 - Generates the markdown CLI documentation or a support archive

###### Auto generated by spf13/cobra on 12-Oct-2020
