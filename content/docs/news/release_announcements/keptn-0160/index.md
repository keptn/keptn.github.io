---
title: Keptn 0.16.0
weight: 72
---

# Release Notes 0.16.0

Keptn 0.16.0 provides the ability to upgrade your Keptn installation without any downtime. For this, Keptn requires each project to have an [upstream Git repository](../manage/git_upstream).
Make sure to check the [upgrade instructions](../../../0.16.x/operate/upgrade/) to ensure that you do not lose any data.


---

**Key announcements**:

:tada: *Zero downtime upgrades*: Operators can upgrade Keptn without downtime.

:star: *Performance gains in backend and frontend*: Performance implications when working with resource files have been resolved due to a new backend service. In addition, the Keptn Bridge received performance improvements by an adapted polling behavior.

:sparkles: *(experimental) New heatmap for SLI breakdown*: Keptn Bridge is leveraging a new rendering library that offers more flexibility for displaying the SLI breakdown. If you want to try it out, you can enable it by setting the Helm value `control-plane.bridge.d3heatmap.enabled` to `true`.

---


[copy release notes here]

