---
title: Keptn 0.13.0
weight: 78
---

Keptn 0.13.0 provides UX improvements in the Bridge to the settings page. The Uniform and Secret screens have been moved into this page.
Besides, the resource-service got mature enough and it is marked as beta. This service will soon replace the configuration-service to speed up the interactions with the Git upstream repo.
Finally, this version of Keptn provides a beta support for [OIDC](https://openid.net/connect/) for Bridge, CLI, and Distributor.

---

**Key announcements:**

:tada: *Rolling updates*: This release is a major step towards rolling updates of Keptn core services.

:star: *UX improvements* in Bridge: The settings page received a style refresh to better organize the information.

:gift: *OIDC support*: Bridge, CLI, and Distributor have initial support for OpenID Connect. For more information on how to enable it, please check our [documentation](https://keptn.sh/docs/0.13.x/operate/user_management/).

---

## Keptn Enhancement Proposals

This release implements the KEPs: [KEP 60](https://github.com/keptn/enhancement-proposals/pull/61) and [KEP 48](https://github.com/keptn/enhancement-proposals/pull/48).

## Keptn Specification

Implemented **Keptn spec** version: [0.2.4](https://github.com/keptn/spec/tree/0.2.4)

---


### ⚠ BREAKING CHANGES

* **bridge:** The uniform screen has been moved into the settings screen.
* In keptn sdk the keptn_fake interfaces have been updated to have api.GetOption in their signature (see https://github.com/keptn/go-utils/pull/375/files#diff-245aca76b6ab2043d44c217312e1b9d487545aca0dd53418fb2106efacaec7b3
* The sequence control now supports also a `waiting` state.
* Several API endpoints have been marked as internal. For more information, please check [#6303](https://github.com/keptn/keptn/issues/6303).

### Features

* Added commitID to webhook and jmeter, updated go-utils dependencies ([#6567](https://github.com/keptn/keptn/issues/6567)) ([#6787](https://github.com/keptn/keptn/issues/6787)) ([5ad04fa](https://github.com/keptn/keptn/commit/5ad04fadad24d06616880b3538a907cb1dcdfd46))
* Added get options to fake keptn in go-sdk ([#6742](https://github.com/keptn/keptn/issues/6742)) ([c6f298c](https://github.com/keptn/keptn/commit/c6f298c8c6ea06ff0b599182738d86fc653a3f9f))
* Block external traffic to internal API endpoints ([#6625](https://github.com/keptn/keptn/issues/6625)) ([7f6a864](https://github.com/keptn/keptn/commit/7f6a8649561f9de2aaa4e00e3b6a384194234944))
* **bridge:** Login via OpenID ([#6076](https://github.com/keptn/keptn/issues/6076)) ([#6077](https://github.com/keptn/keptn/issues/6077)) ([1a657c8](https://github.com/keptn/keptn/commit/1a657c853c8f495ad931dabe014522b86bf919cf))
* **bridge:** Poll sequence metadata for filters and deployed artifacts ([#5246](https://github.com/keptn/keptn/issues/5246)) ([4c5b9df](https://github.com/keptn/keptn/commit/4c5b9dfcb93728920f081fe26078872303e0e1e7))
* **bridge:** Replace memory store with MongoDB ([8d7708f](https://github.com/keptn/keptn/commit/8d7708f736eac08967d801cb59b400b3c2835b94)), closes [#6076](https://github.com/keptn/keptn/issues/6076) [#6688](https://github.com/keptn/keptn/issues/6688) [#6784](https://github.com/keptn/keptn/issues/6784)
* **bridge:** Send access token for each request ([#6078](https://github.com/keptn/keptn/issues/6078)) ([6726306](https://github.com/keptn/keptn/commit/6726306f11a9156d5a095ba86e57d738769eb68a)), closes [#6076](https://github.com/keptn/keptn/issues/6076)
* **bridge:** Show secret scope and keys on overview table ([#6296](https://github.com/keptn/keptn/issues/6296)) ([39fef32](https://github.com/keptn/keptn/commit/39fef32852d20549734d28208d654d857027736c))
* **bridge:** Show specific error message if secret already exists ([#6297](https://github.com/keptn/keptn/issues/6297)) ([fbf7eb0](https://github.com/keptn/keptn/commit/fbf7eb07a1bcaf0342d89ac7e00efc1309b68501))
* **bridge:** Unify notifications ([#5087](https://github.com/keptn/keptn/issues/5087)) ([11941fd](https://github.com/keptn/keptn/commit/11941fdc729871e408d2f9d28c2302c61176a9ed)), closes [#6076](https://github.com/keptn/keptn/issues/6076)
* **cli:** Added `--sso-scopes` flag to cli ([#6708](https://github.com/keptn/keptn/issues/6708)) ([e6e11ba](https://github.com/keptn/keptn/commit/e6e11baf2a62ebe85b899578db9bde2df244893a))
* **cli:** Allow to skip sending the API token when using an SSO integration ([#6675](https://github.com/keptn/keptn/issues/6675)) ([5644e03](https://github.com/keptn/keptn/commit/5644e03e1839228f7b21d3964447ca2297dbeadd))
* **cli:** SSO integration ([#6549](https://github.com/keptn/keptn/issues/6549)) ([2c5f3f7](https://github.com/keptn/keptn/commit/2c5f3f76fa9edee0b73cbdfb0ed07896496ea8ec))
* **cli:** Use `state` param during Oauth flow ([#6701](https://github.com/keptn/keptn/issues/6701)) ([02aecbc](https://github.com/keptn/keptn/commit/02aecbc112fb4db8f60ec55192e10540932f89f6))
* Get and post with commitid ([#6349](https://github.com/keptn/keptn/issues/6349)) ([#6567](https://github.com/keptn/keptn/issues/6567)) ([c3496c0](https://github.com/keptn/keptn/commit/c3496c0f8e3304f916aabebe247b469c618212f5))
* **installer:** Allow API token to be pulled from pre-defined secret ([#6312](https://github.com/keptn/keptn/issues/6312)) ([dc1037a](https://github.com/keptn/keptn/commit/dc1037a1838421210ee363f4bb53822c90e7451c))
* Introduce 'waiting' status to sequences ([#6603](https://github.com/keptn/keptn/issues/6603)) ([e63f312](https://github.com/keptn/keptn/commit/e63f312d1aa4a84beeb4fef2cbecd66933d6c3c9))
* Introduce Oauth integration for distributor and Oauth enhancements for CLI ([#6729](https://github.com/keptn/keptn/issues/6729)) ([7245013](https://github.com/keptn/keptn/commit/7245013d44c45b8785f46da1c131900eae1a53dd))
* Mark endpoints as internal in swagger doc ([#6599](https://github.com/keptn/keptn/issues/6599)) ([3785eed](https://github.com/keptn/keptn/commit/3785eedd1a9581878b70edb7d801fce5c337e7d4))
* **mongodb-datastore:** Use simple join query instead of uncorrelated sub-query ([#6612](https://github.com/keptn/keptn/issues/6612)) ([f57412a](https://github.com/keptn/keptn/commit/f57412a00fccae0b1e293475d464211daa25f388))
* Release helm charts on GitHub pages ([#6559](https://github.com/keptn/keptn/issues/6559)) ([efc285e](https://github.com/keptn/keptn/commit/efc285e65f15b2a6ac6672ffdfe672a5cf4fb7c5))
* **resource-service:** Added support for directory based git model ([#6397](https://github.com/keptn/keptn/issues/6397)) ([#6714](https://github.com/keptn/keptn/issues/6714)) ([ddd5585](https://github.com/keptn/keptn/commit/ddd5585bc78d03073156ef09fab8ba50a871fc24))
* **shipyard-controller:** Propagate git commit ID passed in sequence.triggered events ([#6348](https://github.com/keptn/keptn/issues/6348)) ([#6597](https://github.com/keptn/keptn/issues/6597)) ([ac1f44e](https://github.com/keptn/keptn/commit/ac1f44e648268570da85bc92a7ed73c9e76868c4))
* Update pod config to be more strict w.r.t. security ([#6020](https://github.com/keptn/keptn/issues/6020)) ([6d69563](https://github.com/keptn/keptn/commit/6d6956332ad2259a57b965574c0a411e26bf285e))
* **webhook-service:** Allow disabling .started events ([#6524](https://github.com/keptn/keptn/issues/6524)) ([#6664](https://github.com/keptn/keptn/issues/6664)) ([e07091f](https://github.com/keptn/keptn/commit/e07091f2aa883b1250bbdd66c5618b167f500b30))


### Bug Fixes

* Adapt http status code for not found upstream repositories ([#6641](https://github.com/keptn/keptn/issues/6641)) ([a3ad118](https://github.com/keptn/keptn/commit/a3ad118f4d80ee44addbe39ab11945cd3c8c4548))
* Avoid nil pointer access for undefined value in helm charts ([#6863](https://github.com/keptn/keptn/issues/6863)) ([d845ea6](https://github.com/keptn/keptn/commit/d845ea67ca6df0477629ac3f083795c1a70af4b4))
* **bridge:** Add message that no events are available when sequence has no traces ([#5985](https://github.com/keptn/keptn/issues/5985)) ([64540b9](https://github.com/keptn/keptn/commit/64540b983da60eeadc7b9bc3911129d740b6217c))
* **bridge:** Display additional error information when creating a project ([#6715](https://github.com/keptn/keptn/issues/6715)) ([e8b263f](https://github.com/keptn/keptn/commit/e8b263f08fd9b7f74f64c5bf318f137375023ecc))
* **bridge:** Fix failed sequence shown as succeeded ([#6896](https://github.com/keptn/keptn/issues/6896)) ([e723398](https://github.com/keptn/keptn/commit/e723398a55a7e38779b69a3b52bcdbee6d187548))
* **bridge:** Fix style content security policy ([#6750](https://github.com/keptn/keptn/issues/6750)) ([bd0d569](https://github.com/keptn/keptn/commit/bd0d569f7161dd9ff809a6b44f7e7f8289bfb941))
* **bridge:** Fixed incorrectly shown loading indicator in sequence list ([#6579](https://github.com/keptn/keptn/issues/6579)) ([f238cf4](https://github.com/keptn/keptn/commit/f238cf44e7f29d2c50e43d17cb0d5674f1d50ccf))
* **bridge:** Show error when having problems parsing shipyard.yaml ([#6592](https://github.com/keptn/keptn/issues/6592)) ([#6606](https://github.com/keptn/keptn/issues/6606)) ([0ceb54d](https://github.com/keptn/keptn/commit/0ceb54dfefbd7df2defe1e74e2bcd4c0da0cad91))
* **bridge:** When updating an all events subscription, keep sh.keptn.> format ([#6628](https://github.com/keptn/keptn/issues/6628)) ([1e83fb7](https://github.com/keptn/keptn/commit/1e83fb7967b11264ad7cfb0849d52fd1f4c43a1a))
* **cli:** Added missing command description for `keptn create secret` ([#6621](https://github.com/keptn/keptn/issues/6621)) ([22bddf9](https://github.com/keptn/keptn/commit/22bddf9486f2ad7aeb15e93a085ed3f6371f5820))
* **cli:** Check for unknown subcommands ([#6698](https://github.com/keptn/keptn/issues/6698)) ([c1782c0](https://github.com/keptn/keptn/commit/c1782c01f73ff2a1a4bbe32631f92c1ad19b63bf))
* **cli:** CLI new version checker message ([#6864](https://github.com/keptn/keptn/issues/6864)) ([d836e89](https://github.com/keptn/keptn/commit/d836e890f38c43bad8ad6a2443293448adac69e5))
* **configuration-service:** Adapt to different response from git CLI when upstream branch is not there yet ([#6876](https://github.com/keptn/keptn/issues/6876)) ([#6882](https://github.com/keptn/keptn/issues/6882)) ([c9f0b78](https://github.com/keptn/keptn/commit/c9f0b78063d89d50eac4620d860869664568bd2a))
* **configuration-service:** Ensure that git user and email are set before committing ([#6645](https://github.com/keptn/keptn/issues/6645)) ([#6654](https://github.com/keptn/keptn/issues/6654)) ([d38bb6e](https://github.com/keptn/keptn/commit/d38bb6ef6f0a6eaed95190bcf14fce193c79bee6))
* Fix container image OCI labels ([#6878](https://github.com/keptn/keptn/issues/6878)) ([0f759d4](https://github.com/keptn/keptn/commit/0f759d469c19115b5ca9f507b4b5d50b33f6d688))
* Fixed wrong nginx location for bridge urls ([#6696](https://github.com/keptn/keptn/issues/6696)) ([700895e](https://github.com/keptn/keptn/commit/700895e91b85febbd1ee6c09531a6203aa644a04))
* **installer:** External connection string not used while helm upgrade ([#6760](https://github.com/keptn/keptn/issues/6760)) ([6d04780](https://github.com/keptn/keptn/commit/6d047806f21c2fcd474f6f018c73d3e4bfe47c00))
* **installer:** Fixed helm/jmeter service helm values schema ([#6629](https://github.com/keptn/keptn/issues/6629)) ([085edf1](https://github.com/keptn/keptn/commit/085edf19409ffddceccaec0346090c3cee565873))
* **installer:** Set distributor version in helm chart ([#6652](https://github.com/keptn/keptn/issues/6652)) ([#6658](https://github.com/keptn/keptn/issues/6658)) ([8c2d8de](https://github.com/keptn/keptn/commit/8c2d8dec3d5b80bd59b97fb745cb8db21158067f))
* **jmeter-service:** Finish processes when '.finished' event is sent ([#6786](https://github.com/keptn/keptn/issues/6786)) ([4484a80](https://github.com/keptn/keptn/commit/4484a80b2eb6cb393e013129b0e1fd7c36205163))
* **resource-service:** Fix git-id based file retrieval ([#6616](https://github.com/keptn/keptn/issues/6616)) ([6ba0165](https://github.com/keptn/keptn/commit/6ba01658a2c54b1efa86efd7e86ecee98e4f0a58))
* revert intaller mongoDB version dump ([#6733](https://github.com/keptn/keptn/issues/6733)) ([d96495b](https://github.com/keptn/keptn/commit/d96495bfc5481acd70233e9f7ff0b7c42c01c4f4))
* **shipyard-controller:** Reflect cancellation in sequence state even when no triggered event is there anymore ([#6837](https://github.com/keptn/keptn/issues/6837)) ([bdcd95e](https://github.com/keptn/keptn/commit/bdcd95e5c5857a7c5ef0abff49524cafdf2a8b86))
* Support Openshift 3.11 ([#6578](https://github.com/keptn/keptn/issues/6578)) ([c72dbf2](https://github.com/keptn/keptn/commit/c72dbf2aca410359baa90c52e2cc541ff9ce77f8))
* Trim Incoming Keptn Context and Triggered ID via API ([#6845](https://github.com/keptn/keptn/issues/6845)) ([32d98d9](https://github.com/keptn/keptn/commit/32d98d9ae55a9ad1dd0f61dac20aa56cf865a85a))


### Performance

* Directly return Bridge version ([#6764](https://github.com/keptn/keptn/issues/6764)) ([345469c](https://github.com/keptn/keptn/commit/345469c15106510e786eee1a6e7ce87d7a18840c))


* **bridge:** Restructuring of Bridge settings for project ([75e2842](https://github.com/keptn/keptn/commit/75e284268271070918ec5541997b8db4d6ef1d54))


### Other

* Adapted CLI to newest state of APISet in go-utils ([#6655](https://github.com/keptn/keptn/issues/6655)) ([f86774d](https://github.com/keptn/keptn/commit/f86774db1c3b411f3aaf75a73e010cd52a3a4e85))
* Add [@lmmarsano](https://github.com/lmmarsano) as a contributor ([#6046](https://github.com/keptn/keptn/issues/6046)) ([8bfdfd0](https://github.com/keptn/keptn/commit/8bfdfd0b75c3c76890fac905c10192b30c22bea9))
* Add @Im5tu as a contributor ([#6622](https://github.com/keptn/keptn/issues/6622)) ([4dcb4c8](https://github.com/keptn/keptn/commit/4dcb4c8d0c0b62be86952a7490c8b91fe87d263e))
* Add k8s resource stats to release notes ([#6718](https://github.com/keptn/keptn/issues/6718)) ([5ed8ba5](https://github.com/keptn/keptn/commit/5ed8ba50d38661dfbf09b1682623de4dfab22a38))
* Adjustments to recent changes in go-utils ([#6706](https://github.com/keptn/keptn/issues/6706)) ([e1f2fd7](https://github.com/keptn/keptn/commit/e1f2fd7ad8e9ca6ddfbe0067fb900f396fd8a6aa))
* **bridge:** Added log for used OAuth scope ([c65fd48](https://github.com/keptn/keptn/commit/c65fd489eac4f73cc6199061b7f609afd45adfc2))
* **bridge:** Remove unused dependency puppeteer ([#6762](https://github.com/keptn/keptn/issues/6762)) ([9224afe](https://github.com/keptn/keptn/commit/9224afe051a45e09240ebe2a748e7b3273cb57b9))
* **installer:** Added metadata to keptn helm chart ([#6624](https://github.com/keptn/keptn/issues/6624)) ([88c3e2b](https://github.com/keptn/keptn/commit/88c3e2bc51b30cd9956aa946eb427610e0cffbac))
* Promote [@thschue](https://github.com/thschue) to maintainers ([#6640](https://github.com/keptn/keptn/issues/6640)) ([fb06427](https://github.com/keptn/keptn/commit/fb06427e36ab03371fdd717463d161e2632eb79a))


### Docs

* Add structure for developer documentation ([#6671](https://github.com/keptn/keptn/issues/6671)) ([3fdc8b7](https://github.com/keptn/keptn/commit/3fdc8b78b907f2ecc8d1b8a3146466fd6959d012))
* Updated instructions to install master ([#6889](https://github.com/keptn/keptn/issues/6889)) ([2d4f1be](https://github.com/keptn/keptn/commit/2d4f1be3dc94536dae50be051ee51557100688f9))

<details>
<summary>Kubernetes Resource Data</summary>

### Resource Stats

| Name                  | Container Name        | CPU Request | CPU Limit | RAM Request | RAM Limit | Image                                               |
| --------------------- | --------------------- | ----------- | --------- | ----------- | --------- | --------------------------------------------------- |
| keptn-mongo           | mongodb               | null        | null      | null        | null      | docker.io/bitnami/mongodb:4.4.9-debian-10-r0        |
| api-gateway-nginx     | api-gateway-nginx     | 50m         | 100m      | 64Mi        | 128Mi     | docker.io/nginxinc/nginx-unprivileged:1.21.6-alpine |
| api-service           | api-service           | 50m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/api:0.13.0                          |
| api-service           | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.13.0                  |
| approval-service      | approval-service      | 25m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/approval-service:0.13.0             |
| approval-service      | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.13.0                  |
| configuration-service | configuration-service | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/configuration-service:0.13.0        |
| remediation-service   | remediation-service   | 50m         | 200m      | 64Mi        | 1Gi       | docker.io/keptn/remediation-service:0.13.0          |
| remediation-service   | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.13.0                  |
| bridge                | bridge                | 25m         | 200m      | 64Mi        | 256Mi     | docker.io/keptn/bridge2:0.13.0                      |
| mongodb-datastore     | mongodb-datastore     | 50m         | 300m      | 32Mi        | 512Mi     | docker.io/keptn/mongodb-datastore:0.13.0            |
| mongodb-datastore     | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.13.0                  |
| lighthouse-service    | lighthouse-service    | 50m         | 200m      | 128Mi       | 1Gi       | docker.io/keptn/lighthouse-service:0.13.0           |
| lighthouse-service    | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.13.0                  |
| secret-service        | secret-service        | 25m         | 200m      | 32Mi        | 64Mi      | docker.io/keptn/secret-service:0.13.0               |
| shipyard-controller   | shipyard-controller   | 50m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/shipyard-controller:0.13.0          |
| shipyard-controller   | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.13.0                  |
| statistics-service    | statistics-service    | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/statistics-service:0.13.0           |
| statistics-service    | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.13.0                  |
| webhook-service       | webhook-service       | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/webhook-service:0.13.0              |
| webhook-service       | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.13.0                  |
| keptn-nats-cluster    | nats                  | null        | null      | null        | null      | nats:2.1.9-alpine3.12                               |

</details>



## Upgrade to 0.13.0

- The upgrade from 0.12.x to 0.13.0 is supported by the `keptn upgrade` command. Find the documentation here: [Upgrade from Keptn 0.12.x to 0.13.0](https://keptn.sh/docs/0.13.x/operate/upgrade/#upgrade-from-keptn-0-12-x-to-0-13-0)

