---
title: Loading integrations
description: Loading integrations page in Bridge from external source
weight: 40
---

The Keptn Bridge provides now an additional page with information about integrations. This makes it easier to start using Keptn and also shows custom integrations.

This page also has a dynamic page content, which is loaded from <https://get.keptn.sh/integrations.html> when the user clicks the "Load more information about integrations"-Button. This page is stored in an S3 bucket on AWS. The AWS account is owned by the maintainer of the Keptn project, Dynatrace. The S3 bucket is configured in a way that each request is logged into another S3 bucket.

{{< popup_image
        link="./assets/load_information.png"
        caption="Load integrations page into Bridge"
        width="100%">}}

## Which data is gathered?

When loading the external page, the request of the file contains personally identifying information:

* IP address;
* Version of Keptn deployment;
* Number of projects, stages, and services;
* Number of root events per service and day;
* List of installed Keptn-services including version thereof.

The request is logged in the format shown here: <https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html>

All the information collected by the maintainer of the Keptn project will be handled in accordance with GDPR legislation and there is no disclosure of personally-identifying information. To not disclose personal information, the IP address in the log entries is exchanged by its hash value.

## Why are we collecting this data?

The maintainer of the Keptn project collects the above-mentioned data for:

* aggregated statistics about the distribution of Keptn deployments per version;
* aggregated statistics about the distribution of installed Keptn-services;
* decisions about user interface improvements.

Before processing the collected data, any personally-identifying information is exchanged by hash values. This builds the foundation to not disclose personally-identifying information in any statistics.
