---
title: Keptn 0.16.2
weight: 71
---

# Release Notes 0.16.2
Keptn 0.16.2 is a bugfix release that solves issue for the resource-service and shipyard-controller.

---
### Bug Fixes

* Merge integration subscriptions into one, apply newly supplied subscriptions if existing ones are empty ([#8604](https://github.com/keptn/keptn/issues/8604)) ([13b6a1f](https://github.com/keptn/keptn/commit/13b6a1f999d16186321d1a938177943c3e4dd4e5))
* **resource-service:** Determine default branch using HEAD after initial clone ([#8696](https://github.com/keptn/keptn/issues/8696)) ([4a1bce6](https://github.com/keptn/keptn/commit/4a1bce6fe828c32709d278d3ca85b052662905da))
* **resource-service:** Use values provided by GIT_KEPTN_USER and GIT_KEPTN_EMAIL for commits to the upstream ([#8713](https://github.com/keptn/keptn/issues/8713)) ([439f383](https://github.com/keptn/keptn/commit/439f3832522a3d3f9f004e7aae795bbbe58ca43c)), closes [#8676](https://github.com/keptn/keptn/issues/8676)
* **shipyard-controller:** Added service in the Event Dispatcher's filter ([#8663](https://github.com/keptn/keptn/issues/8663)) ([6fe4aba](https://github.com/keptn/keptn/commit/6fe4aba48fa58e29e702c875c06e582fa9e84ff2))
* **shipyard-controller:** Clean up event queue when cancelling a sequence ([#8716](https://github.com/keptn/keptn/issues/8716)) ([0327218](https://github.com/keptn/keptn/commit/0327218934e100a5a20fa4a72413a2622f45cda3)), closes [#8583](https://github.com/keptn/keptn/issues/8583)
* **shipyard-controller:** Update Integration when Subscriptions field is null ([#8575](https://github.com/keptn/keptn/issues/8575)) ([c4ba3db](https://github.com/keptn/keptn/commit/c4ba3db1e0451b65c57371c713f900d185d39689))