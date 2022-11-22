---
title: Keptn 0.17.1
weight: 70
---

# Release Notes 0.17.1

Keptn 0.17.1 is a bugfix release that solves issue for the bridge, resource-service, and shipyard-controller.

---

### Bug Fixes

* **bridge:** Fix invalid header property for webhook ([#8544](https://github.com/keptn/keptn/issues/8544)) ([defe0b6](https://github.com/keptn/keptn/commit/defe0b6ad9ace4a04f3a05b3da78953ab21083f6))
* Merge integration subscriptions into one, apply newly supplied subscriptions if existing ones are empty ([#8597](https://github.com/keptn/keptn/issues/8597)) ([1cdd2a9](https://github.com/keptn/keptn/commit/1cdd2a9a12e27aeac052a734589d164c84ad523b))
* **resource-service:** Determine default branch using HEAD after initial clone ([#8693](https://github.com/keptn/keptn/issues/8693)) ([c1551b8](https://github.com/keptn/keptn/commit/c1551b853e573166ca744751a73d35ff7544b707))
* **resource-service:** Use values provided by GIT_KEPTN_USER and GIT_KEPTN_EMAIL for commits to the upstream ([#8712](https://github.com/keptn/keptn/issues/8712)) ([28e43a8](https://github.com/keptn/keptn/commit/28e43a8335086e34eb3c045bf14c16990a06de59)), closes [#8676](https://github.com/keptn/keptn/issues/8676)
* **shipyard-controller:** Added service to shipyard filter in Event Dispatcher ([#8679](https://github.com/keptn/keptn/issues/8679)) ([db34627](https://github.com/keptn/keptn/commit/db346276a9f9bae10ecded6e976d743f2d2a1179))
* **shipyard-controller:** Clean up event queue when cancelling a sequence  ([#8717](https://github.com/keptn/keptn/issues/8717)) ([b4152f5](https://github.com/keptn/keptn/commit/b4152f52bc2171f0b4c07d8968e22ee4e90b77ea)), closes [#8583](https://github.com/keptn/keptn/issues/8583)
* **shipyard-controller:** Handling error messages ([#8485](https://github.com/keptn/keptn/issues/8485)) ([1ee49e2](https://github.com/keptn/keptn/commit/1ee49e203bf0e8edc5ca3f14beea65cbc5fe9fd4))
* **shipyard-controller:** Update Integration when Subscriptions field is null ([#8598](https://github.com/keptn/keptn/issues/8598)) ([2367cf8](https://github.com/keptn/keptn/commit/2367cf8f54144c0a306959b0433b371b106b696c))