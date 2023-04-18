---
title: Keptn 0.16.1
weight: 71
---

# Release Notes 0.16.1

Keptn 0.16.1 is a bugfix release that solves issue for the resource-service and shipyard-controller.

---
### Bug Fixes

* **resource-service:** Always delete local project directory when project creation fails ([#8144](https://github.com/keptn/keptn/issues/8144)) ([19bc61c](https://github.com/keptn/keptn/commit/19bc61c96160d81794ada0bf6c5478fa77561c35)), closes [#8123](https://github.com/keptn/keptn/issues/8123)
* **resource-service:** Remove token enforcement ([#8040](https://github.com/keptn/keptn/issues/8040)) ([#8206](https://github.com/keptn/keptn/issues/8206)) ([6585037](https://github.com/keptn/keptn/commit/65850379d2a7878a483b24f56ac1c744202607e7))
* **shipyard-controller:** Delete project should not return error if the upstream is failing  ([#8227](https://github.com/keptn/keptn/issues/8227)) ([90115da](https://github.com/keptn/keptn/commit/90115dabdef698f602545dab349daeebaea44617))
* Use distributor values namespace and hostname in svc env vars ([#8311](https://github.com/keptn/keptn/issues/8311)) ([cc3a2fe](https://github.com/keptn/keptn/commit/cc3a2feca3653588c558919cd753e2ac378d6703))


### Other

* Bump swagger-ui to version 4.12.0 ([#8281](https://github.com/keptn/keptn/issues/8281)) ([52e91a4](https://github.com/keptn/keptn/commit/52e91a47ea78adabe3b154b5208bc3c86908e7be))