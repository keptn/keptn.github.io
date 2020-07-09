---
title: Assisted delivery
description: Approval of deployment for manual approval strategy
weight: 21
keywords: [bridge]
---

The Keptn Bridge allows you to send an `approval.finished` event to Keptn in order to confirm an open approval, in case that you configured `manual` approval for your
 [Multi-stage delivery workflow](../../continuous_delivery/multi_stage/#approval-strategy).
 
To do so, open the "Environment" view, click on the stage that has a pending approval and when you expand the service on the right side you will see all pending approvals. By clicking on the green checkmark the deployment will be approved, or you can also decline by clicking on the abort button. 

  {{< popup_image
    link="./assets/bridge_environment_assisteddelivery.png"
    caption="Keptn Bridge Assisted Delivery">}}