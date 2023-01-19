---
title: Keptn 1.1.0
weight: 63
---

## [1.1.0](https://github.com/keptn/keptn/compare/1.0.0...1.1.0) (2023-01-18)


### Features

* **bridge:** Read secrets from volume mount instead from env var ([#9335](https://github.com/keptn/keptn/issues/9335)) ([94c60e5](https://github.com/keptn/keptn/commit/94c60e55a1240660ea07e1f35e8afdf809b4d4a0))
* **bridge:** Sort registration items by name ([#9344](https://github.com/keptn/keptn/issues/9344)) ([6dcf6f6](https://github.com/keptn/keptn/commit/6dcf6f686c6ea211bcdae163c52e9fa6fc79f631))
* **resource-service:** reduce git fetch operations ([#9410](https://github.com/keptn/keptn/issues/9410)) ([4a2b091](https://github.com/keptn/keptn/commit/4a2b091aac9006cfc0343db8eb3cf215f6557feb))


### Bug Fixes

* **cli:** display incompatible upgrade possibilities even if no minor upgrade is available ([#9381](https://github.com/keptn/keptn/issues/9381)) ([7d66999](https://github.com/keptn/keptn/commit/7d6699960700925cde5bfbefd1f8fb722b5b6dd2))
* Fix generation of SBOMs during releases of Keptn ([#9445](https://github.com/keptn/keptn/issues/9445)) ([5f01217](https://github.com/keptn/keptn/commit/5f01217cac3a8add79100506d7718bb40d5e7305))
* Fix some shellcheck issues in pipeline related shell scripts ([#9322](https://github.com/keptn/keptn/issues/9322)) ([676a2d0](https://github.com/keptn/keptn/commit/676a2d07ede016ca1ba2885d157d8d483b8e960a))
* **installer:** Use correct image after dependency update ([#9442](https://github.com/keptn/keptn/issues/9442)) ([af58036](https://github.com/keptn/keptn/commit/af58036e2f99dc2c7674dd5048ae497140d3e76a))
* **resource-service:** override insecureSkipTLS only if proxy is set to nil ([#9395](https://github.com/keptn/keptn/issues/9395)) ([170322a](https://github.com/keptn/keptn/commit/170322aeb9e782d5779a006e761f7cc2338f184c))
* **shipyard-controller:** Add new stage to sequence state immediately after receiving triggered event ([#9334](https://github.com/keptn/keptn/issues/9334)) ([7d27e86](https://github.com/keptn/keptn/commit/7d27e861e5a67ea44cc4fae836d4bf22192cdf17))


### Docs

* Document `/import` OAuth scopes ([#9330](https://github.com/keptn/keptn/issues/9330)) ([689750b](https://github.com/keptn/keptn/commit/689750b66f1e7ed96a3c7f5eb40e8dcbfedb5267))


### Other

* fixed false positive security errors ([#9411](https://github.com/keptn/keptn/issues/9411)) ([dbb9986](https://github.com/keptn/keptn/commit/dbb99861bf85d7472ef94906723c8e0ff3273573))