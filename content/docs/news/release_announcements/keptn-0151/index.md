---
title: Keptn 0.15.1
weight: 73
---

This is a bug fix release for Keptn containing fixes for shipyard-controller and the handling of database connections.

### Bug Fixes

* Ensure all MongoDB cursors are being closed ([#7946](https://github.com/keptn/keptn/issues/7946)) ([6117e59](https://github.com/keptn/keptn/commit/6117e5987a7838237e824ae8144699207e8f6be2))
* **shipyard-controller:** Allow parallel sequence execution if the service is different ([#7825](https://github.com/keptn/keptn/issues/7825)) ([f6bb098](https://github.com/keptn/keptn/commit/f6bb098fe3380c26b923e8cfe52aae523bc3898e))
* **shipyard-controller:** Dispatch new sequence directly only if no older sequence is waiting ([#7831](https://github.com/keptn/keptn/issues/7831)) ([a4394f9](https://github.com/keptn/keptn/commit/a4394f9bbdb2bcfbe445d00a6b3d62c58234a58a)), closes [#7793](https://github.com/keptn/keptn/issues/7793)
* **shipyard-controller:** Set the sequence execution state back to `started` when approval task has been finished  ([#7840](https://github.com/keptn/keptn/issues/7840)) ([c4e82e0](https://github.com/keptn/keptn/commit/c4e82e0ac3118fb8f4e70266a1cca76bc6f85220)), closes [#7838](https://github.com/keptn/keptn/issues/7838)
