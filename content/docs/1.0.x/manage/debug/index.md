---
title: Debug logging
description: Implement debug logging for your project
weight: 45
keywords: [1.0.x-manage]
aliases:
---

Modifying the log level preserves more detailed information in the logs.
This can be useful when analyzing execution problems for your project.

You can set the log level in either of two ways:

* Adjust the `loglevel` value to `debug`
  in the [Helm chart](../../reference/files/values)
  or by using the [-set flag](../../install/helm-install/#the---set-flag)
  on the **helm** command line.
  This is a global setting that sets the log level
  for **all** Keptn core services.

* All Keptn services support the `LOG_LEVEL` environment variable.
  Set this to `debug` to set the log level for an individual service.
  In most cases, you will get the debugging information you need
  by setting this for the `shippy` shipyard controller
  and for the `resource-service` being used
  at the time of the failure you are analyzing.

Remember to reset the `LOG_LEVEL` environment variables
back to `info` when you have finished your debugging effort.

