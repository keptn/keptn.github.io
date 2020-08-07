---
title: Delivery Assistent
description: Approval of deployment for manual approval strategy
weight: 50
keywords: [0.7.x-bridge]
---

If you configured `manual` approval for your [multi-stage delivery](../../../continuous_delivery/multi_stage/#approval-strategy), the Keptn Bridge allows you to send an `approval.finished` event to Keptn to confirm/decline an open approval.
 
* To confirm/decline an approval, open the *Environment* view, click on the stage that has a pending approval. When you expand the service on the right side, you will see all pending approvals. 

* By clicking on the green checkmark, the deployment will be approved. You can also decline by clicking on the red abort button. 

    {{< popup_image
      link="./assets/bridge_environment_assisteddelivery.png"
      caption="Keptn Bridge Assisted Delivery">}}