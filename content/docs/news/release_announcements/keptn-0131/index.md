---
title: Keptn 0.13.1
weight: 77
---

This is a bug fix release for Keptn 0.13.0, containing fixes for the the Quality Gate use case and hardening of the Keptn components.

---

### Bug Fixes

* **bridge:** Fix incorrect content security policy ([4b94f47](https://github.com/keptn/keptn/commit/4b94f47f62e120853b62a82cee6ce6b09d9bcda2))
* **distributor:** Include event filter for project, stage, service ([#6968](https://github.com/keptn/keptn/issues/6968)) ([eceef0d](https://github.com/keptn/keptn/commit/eceef0d927e44c9e2d0e4ea2606326124de0c1c9))
* **distributor:** Increase timout of http client to 30s ([#6948](https://github.com/keptn/keptn/issues/6948)) ([4db3b83](https://github.com/keptn/keptn/commit/4db3b83edf82915576fce5eca39f609e98360a43))
* **distributor:** Update go-utils dependencies ([#6957](https://github.com/keptn/keptn/issues/6957)) ([18eef68](https://github.com/keptn/keptn/commit/18eef68f13e2396dd841288d13a0770e3b3ca409))
* Ensure indicators are set in computeObjectives ([#6923](https://github.com/keptn/keptn/issues/6923)) ([ed8ee22](https://github.com/keptn/keptn/commit/ed8ee22ecdfe9dee46abae23b75527ac3fc5c0c7))
* Hardening of oauth in distributor and cli ([#6917](https://github.com/keptn/keptn/issues/6917)) ([#6941](https://github.com/keptn/keptn/issues/6941)) ([7b69261](https://github.com/keptn/keptn/commit/7b6926149c5a3e1b4045742ae69373f14a81e9b1))
* **installer:** Make securityContext configurable ([#6932](https://github.com/keptn/keptn/issues/6932)) ([1580524](https://github.com/keptn/keptn/commit/15805240772ce4d056b6de392bece22741ff54c8))

## Upgrade to 0.13.1

* The upgrade from 0.12.x or 0.13.0 to 0.13.1 is supported by the `keptn upgrade` command. Find the documentation here: [Upgrade from Keptn 0.12.x to 0.13.0](https://keptn.sh/docs/0.13.x/operate/upgrade/#upgrade-from-keptn-0-12-x-to-0-13-0)
