---
title: Upgrade Keptn
description: Upgrade your Keptn to 0.16
weight: 30
aliases:
  - /docs/0.16.0/operate/upgrade/
  - /docs/0.16.0/operate/upgrade/
---

## Upgrade from Keptn 0.15.x to Keptn 0.16.x

With Keptn 0.16.x, every Keptn project requires an [upstream Git repository](../../manage/git_upstream). Hence, before upgrading Keptn you must (i) attach an upstream to your Keptn projects and (ii) do a [backup](..//backup_and_restore/#back-up-configuration-service).
If you already have an upstream for all your Keptn projects, no additional steps are required and you can run `helm upgrade keptn keptn/keptn -n keptn --version 0.16.0 --reuse-values`.

Suppose you need the additional features provided by the *resource-service*,  such as HTTPS/SSH or Proxy, to configure your Keptn project with an upstream. In that case,
you can also deploy the *resource-service* and configure the Git repositories later. For this, a backup is necessary.

1. Back up the [configuration-service](../backup_and_restore/#back-up-configuration-service).
2. For each Keptn project in the backup data, open a shell in that directory and make sure the `Git` CLI is available.
3. Attach your upstream to the Keptn project via the Git CLI with `git remote add origin <remoteURL>`, where `<remoteURL>` is your Git upstream.
4. Run `git push --all` to synchronize your backup with your Git repository.
5. Upgrade to Keptn 0.16.x using `helm upgrade keptn keptn/keptn -n keptn --version 0.16.0 --reuse-values`
6. Navigate to your Bridge installation and configure an upstream to the Keptn projects.
