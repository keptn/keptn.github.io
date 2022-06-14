---
title: Start TheKindKeptn
description: Create TheKindKeptn environment
weight: 10
---
# The Kind Keptn

The kind keptn is a disposable, temporary mechanism that runs a Keptn installation on your laptop
so you can quickly evaluate [keptn](https://keptn.sh). The only prerequisite is a current version of Docker.

The kind keptn is **not** designed as a production-ready installation. It is **not** designed for long term use. For those, you want [a proper installation of keptn](https://keptn.sh/docs/0.15.x/operate/install) or a SaaS hosted version.

This microsite covers the basics of the kind keptn. It is not intended as a replacement for the full docs and tutorials on the [keptn site](https://keptn.sh).

----
To begin, execute the following command from the shell of your laptop.
You may want to create a separate directory and execute the command there.

## Quick Start

```
docker run --rm -it \
--name thekindkeptn \
-v /var/run/docker.sock:/var/run/docker.sock:ro \
--add-host=host.docker.internal:host-gateway \
--publish 7681:7681 \
gardnera/thekindkeptn:{{ .site.thekindkeptn_version }}
```

----

This takes 10-15 minutes to execute, possibly longer, depending on your computer and the speed of your Internet connection.
When it completes, you will see a "Keptn is now running" block and a shell prompt.

## I've Installed. What Now?

You now have a Docker container running that contains a small Kubernetes cluster
with Keptn and the Keptn CLI installed,
as well as a very simple Keptn project that we will use to explore what Keptn can do.

You will also find a web-based terminal shell on `http://localhost:{{ .site.ttyd_port }}`

See [first steps](first-steps.md) to start the Keptn discovery path.

----

## Quick Links
- Browser based web terminal to interact with the cluster: [http://localhost:7681](http://localhost:7681)
- Keptn's bridge: [http://localhost/bridge](http://localhost/bridge/dashboard)

----

## Components

See [components](components.md) for what is installed when you run the above command

