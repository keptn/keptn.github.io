---
title: Keptn 0.19.1
weight: 66
---

# Release Notes [0.19.1](https://github.com/keptn/keptn/compare/0.19.0...0.19.1) (2022-10-18)

---

Keptn 0.19.1 is a bugfix release that solves issues for the resource-service, bridge, and shipyard-controller.

---

* **resource-service:** Compute git auth method once per API request  ([#8946](https://github.com/keptn/keptn/issues/8946)) ([9efdf4a](https://github.com/keptn/keptn/commit/9efdf4a2596dff2eb517f3070494824e3cd850ca)), closes [#8824](https://github.com/keptn/keptn/issues/8824)
* **resource-service:** Move history of previous upstream to new upstream ([#8947](https://github.com/keptn/keptn/issues/8947)) ([a7507ed](https://github.com/keptn/keptn/commit/a7507edc6af19eca0c11448299e4d89ae3a05a6e)), closes [#8906](https://github.com/keptn/keptn/issues/8906)
* **bridge:** Fix missing update in project settings on project change ([#8984](https://github.com/keptn/keptn/issues/8984)) ([56928d5](https://github.com/keptn/keptn/commit/56928d5e31f368db1dd057deaaf447e7ad556841))
* **installer:** Remove duplicate volumes and volumeMounts configuration ([#8950](https://github.com/keptn/keptn/issues/8950)) ([1abd798](https://github.com/keptn/keptn/commit/1abd7985b6c4e550064b6cd45c652aff412c0a00))
* **shipyard-controller:** Adapt mongodb query to be compatible with DocumentDB ([#8977](https://github.com/keptn/keptn/issues/8977)) ([749e3a0](https://github.com/keptn/keptn/commit/749e3a0c5f52fd3c5854ade3005270c0bc95a5a2))
* **shipyard-controller:** Adopt previous value of IsUpstreamAutoProvisioned when migrating project with old git credentials structure ([#8883](https://github.com/keptn/keptn/issues/8883)) ([ed38863](https://github.com/keptn/keptn/commit/ed38863ddc64fcadd586727f6c256a7fc7e60f65))
* **shipyard-controller:** Do not validate gitCredentials when not set during project update ([#8939](https://github.com/keptn/keptn/issues/8939)) ([e769b7e](https://github.com/keptn/keptn/commit/e769b7e9f3e1d9c09dc5c33cca74b3baab5f8f35))
* **shipyard-controller:** Prevent storing empty ssh private key after update ([#8960](https://github.com/keptn/keptn/issues/8960)) ([3411c1d](https://github.com/keptn/keptn/commit/3411c1d5a68439cc74e5a43badba332ae20de5ea)), closes [#8959](https://github.com/keptn/keptn/issues/8959)