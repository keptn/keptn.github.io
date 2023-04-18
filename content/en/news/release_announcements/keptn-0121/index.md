---
title: Keptn 0.12.1
weight: 80
---

This is a bug fix release for Keptn 0.12.0, containing fixes for the Keptn core services and the helm chart installer.

---

### Bug Fixes

* Adapt HTTP status code for not found upstream repositories ([#6872](https://github.com/keptn/keptn/issues/6872)) ([51e5855](https://github.com/keptn/keptn/commit/51e5855e0861d34cd6686f1b6488735c45b6de5f))
* Avoid nil pointer access for undefined value in helm charts ([#6869](https://github.com/keptn/keptn/issues/6869)) ([96bc287](https://github.com/keptn/keptn/commit/96bc287bf1236a233c4555b9e05ad9183aa197e5))
* **configuration-service:** Ensure that git user and email are set before committing ([#6871](https://github.com/keptn/keptn/issues/6871)) ([163af96](https://github.com/keptn/keptn/commit/163af96ebf835e65b0cd6c9efa783e4e7b17d8cb))
* **installer:** External connection string not used while helm upgrade ([#6870](https://github.com/keptn/keptn/issues/6870)) ([918fd83](https://github.com/keptn/keptn/commit/918fd83a2242d05c84a5f3999e1e159bf7766786))