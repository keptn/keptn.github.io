---
title: Troubleshooting
description: The sections describes tips and tricks to deal with troubles that may occur when using keptn. 
weight: 30
keywords: [troubleshooting]
---

In this section, instructions are summarized that help to trouble shoot known issues that may occur when using keptn.

### Installation on Azure aborting
<details><summary>Expand instructions</summary>
<p>

**Investigation:**

The keptn installation is aborting with the following error:

```console
Cannot obtain the cluster/pod IP CIDR
```

**Reason:** 

The root cause of this issue is that `kubenet` is not used in your AKS cluster. However, it is needed to retrieve the `podCidr` according to the official docs: https://docs.microsoft.com/en-us/rest/api/aks/managedclusters/createorupdate#containerservicenetworkprofile 

**Solution:** 

Please select the **Kubenet network plugin (basic)** when setting up your AKS cluster, instead of *Azure network plugin (advanced)* and retry the installation. You can find more information here: https://docs.microsoft.com/en-us/azure/aks/configure-kubenet 

</p></details>
