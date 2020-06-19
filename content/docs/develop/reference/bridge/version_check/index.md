---
title: Daily Version Check
description: Enable/Disable daily version check feature
weight: 21
keywords: [bridge]
---

The feature of a daily version check informs a Keptn user in the Keptn Bridge about:

-	new Keptn versions;
-	security patches for the installed Keptn control plane;
-	security patches for installed Keptn-services. 

*Implementation*: The feature is enabled when installing or upgrading Keptn and can be disabled as explained below. The feature requests a version file accessible on: https://get.keptn.sh/version.json via an HTTPS call on a daily basis. The version file is stored in an S3 bucket on AWS. The AWS account is owned by the maintainer of the Keptn project, Dynatrace. The S3 bucket is configured in a way that each request is logged into another S3 bucket. 

## Which data is gathered?

When turning on the feature, the request of the version file contains personally identifying information and information about the Keptn deployment: 

*	IP address;
*	Version of Keptn deployment;
*	Number of projects, stages, and services; 
*	Number of root events per service and day;
*	List of installed Keptn-services including version thereof. 

The request is logged in the format shown here: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html

All the information collected by the maintainer of the Keptn project will be handled in accordance with GDPR legislation and there is no disclosure of personally-identifying information. To not disclose personal information, the IP address in the log entries is exchanged by its hash value.

## Why are we collecting this data? 

The maintainer of the Keptn project collects the above-mentioned data for: 

* aggregated statistics about the distribution of Keptn deployments per version;
* aggregated statistics about the distribution of installed Keptn-services;
* decisions about user interface improvements.

Before processing the collected data, any personally-identifying information is exchanged by hash values. This builds the foundation to not disclose personally-identifying information in any statistics. 

## How to enable/diable the feature?

* *To enable the feature:* Open the user menu by clicking on the user icon on the top right corner. On the bottom of the menu, toggle the feature flag from left to right to enable the feature.

    {{< popup_image
        link="./assets/enable_feature.png"
        caption="Enable daily version check"
        width="400px">}}

*	*To disable the feature:* Open the user menu by clicking on the user icon on the top right corner. On the bottom of the menu, toggle the feature flag from right to left to disable the feature.

    {{< popup_image
        link="./assets/disable_feature.png"
        caption="Disable daily version check"
        width="400px">}}