---
title: Debug logging
description: Implement debug logging for your project
weight: 45
keywords: [1.0.x-manage]
aliases:
---

Modifying the log level preserves more detailed information in the logs.
This can be useful when analyzing execution problems for your project.

To do this:

* Adjust the value of the `LOG_LEVEL` environment variable
  in the shipyard controller to `debug`.
  Alternately, you can adjust the `loglevel` Helm value to `debug`.

* Also adjust the value of the `LOG_LEVEL` environment variable
  for the `resource-service` being used
  at the time of the failure you are analyzing.

Remember to reset the `LOG_LEVEL` environment variables
back to `info` when you have finished your debugging effort.

