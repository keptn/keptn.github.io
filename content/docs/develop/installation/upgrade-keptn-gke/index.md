---
title: Upgrade keptn on GKE
description: How to upgrade keptn in GKE.
weight: 11
icon: setup
keywords: setup
---

For upgrading an existing keptn 0.2.0 installation an upgrade script is provided. This will update all keptn core components to their new version.

## Prerequisites
   
Please note that [all needed command line tools](../setup-keptn-gke#prerequisites) are needed when upgrading keptn.
Additionally, `yq` is required:

  - [yq](https://github.com/mikefarah/yq)

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
-  **Important:** Due to a [known issue](https://issues.jenkins-ci.org/browse/JENKINS-14880) in Jenkins, it is necessary to open the Jenkins configuration and click **Save** although nothing is changed.

    You can open the configuration page of Jenkins with the credentials `admin` / `AiTx4u8VyUV8tCKk` by taking the URL from the upgrade script or generating it and copying it in your browser:
    ```
    echo http://jenkins.keptn.$(kubectl describe svc istio-ingressgateway -n istio-system | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~').xip.io/configure
    ```

- **Note:** In future releases of the keptn CLI, a command `keptn upgrade` will be added, which replaces the shell script `upgradeKeptn.sh`.