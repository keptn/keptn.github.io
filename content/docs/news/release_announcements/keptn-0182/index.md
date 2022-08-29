---
title: Keptn 0.18.2
weight: 68
---

# Release Notes 0.18.2

Keptn 0.18.1 is a bugfix release that solves issue for the resource-service and shipyard-controller.

---

### Bug Fixes

* Merge integration subscriptions into one, apply newly supplied subscriptions if existing ones are empty ([#8566](https://github.com/keptn/keptn/issues/8566)) ([bec68ed](https://github.com/keptn/keptn/commit/bec68eddc0de44862ffd9e2c2a55a6e904fa88f2))
* **resource-service:** GetDefaultBranch looks for HEAD before fallback to master ([#8627](https://github.com/keptn/keptn/issues/8627)) ([05b6ac4](https://github.com/keptn/keptn/commit/05b6ac4a77382b27b6f455551e673a117ce4110f))
* **resource-service:** Use values provided by GIT_KEPTN_USER and GIT_KEPTN_EMAIL for commits to the upstream ([#8711](https://github.com/keptn/keptn/issues/8711)) ([e4eb42e](https://github.com/keptn/keptn/commit/e4eb42e0ef30f7e48fe99a8e43fe12471f650956)), closes [#8676](https://github.com/keptn/keptn/issues/8676)
* **shipyard-controller:** Added shipyard service filter in event dispatcher ([#8682](https://github.com/keptn/keptn/issues/8682)) ([e02aed8](https://github.com/keptn/keptn/commit/e02aed8992ee4b8fd87055dcd8f5a56b04300187))
* **shipyard-controller:** Clean up event queue when cancelling a sequence ([#8715](https://github.com/keptn/keptn/issues/8715)) ([a27aafd](https://github.com/keptn/keptn/commit/a27aafd63f4d6ec327016df866dcb74b193a5716)), closes [#8583](https://github.com/keptn/keptn/issues/8583)
* **shipyard-controller:** Update Integration when Subscriptions field is null ([#8600](https://github.com/keptn/keptn/issues/8600)) ([7fd044e](https://github.com/keptn/keptn/commit/7fd044e4f180b10ebcc001d70e7c170a93da4ca8))
