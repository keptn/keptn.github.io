---
title: Upgrade keptn on GKE
description: How to upgrade keptn in GKE.
weight: 11
icon: setup
keywords: setup
---

For upgrading an existing keptn 0.2.0 installation an upgrade script is provided. This will update all keptn core components to their new version.

## Prerequisites

Please note that [all needed command line tools](../setup-keptn-gke#prerequisites) are still needed when upgrading keptn.

## Upgrade keptn from 0.2.0 to 0.2.1

- Clone the GitHub repository of the latest release.
```
git clone --branch 0.2.1 https://github.com/keptn/keptn
```


- Navigate to the install scripts folder:
```
cd keptn/install/scripts/
```

- Run the keptn upgrade script
```
./upgradeKeptn.sh github_username github_access_token
```