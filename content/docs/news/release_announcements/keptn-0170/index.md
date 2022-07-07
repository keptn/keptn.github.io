---
title: Keptn 0.17.0
weight: 70
---

# Release Notes 0.17.0

Keptn 0.17.0 provides more customizability options in the Helm Charts. Make sure to check the [upgrade guide](https://keptn.sh/docs/install/upgrade/#upgrade-from-keptn-0-16-x-to-keptn-0-17-x) to ensure that you do not lose any data.

---

**Key announcements**:

:information_source: *CLI*: The CLI does not offer anymore the install/uninstall/upgrade commands. Please refer to our [documentation](../../../install/helm-install/) to see how you can use Helm to operate Keptn.

---


## [0.17.0](https://github.com/keptn/keptn/compare/0.16.0...0.17.0) (2022-07-06)


### ⚠ BREAKING CHANGES

* Git credentials for git authentication have been moved to a separate sub-structure in the `go-utils` package and split to either ssh or HTTP sub-structures depending on the user authentication method. This leads to new models for creating, updating, and retrieving the project information via REST APIs.
* **installer:** Keptn's Helm charts were reworked and some values were changed and/or moved. Please consult the [upgrade guide](https://keptn.sh/docs/install/upgrade/#upgrade-from-keptn-0-16-x-to-keptn-0-17-x) to make sure your installation can be upgraded successfully. With this change, users now have the option to customize resource limits/requests and to add custom sidecars and extra volumes from the Helm values.

### Features

* Adapt go-utils changes in git credentials models ([#8020](https://github.com/keptn/keptn/issues/8020)) ([e8e2e6c](https://github.com/keptn/keptn/commit/e8e2e6cfe7af4b30f4071de6aef38ecdc12907c7))
* Add headers to git provisioner ([#8132](https://github.com/keptn/keptn/issues/8132)) ([f02aeba](https://github.com/keptn/keptn/commit/f02aeba6d384b9d7bb2aa50ce1796fc9e4cb3d6d))
* Add OAuth scopes to swagger and add possibility to disable deprecated APIs ([#8051](https://github.com/keptn/keptn/issues/8051)) ([0dc1203](https://github.com/keptn/keptn/commit/0dc12034548d1003bd02f331979e7219f4557d73))
* **api:** Create import endpoint ([#8137](https://github.com/keptn/keptn/issues/8137)) ([75ae009](https://github.com/keptn/keptn/commit/75ae0093c16ebb0396ee0eca3ac6c47592510a19))
* **bridge:** Add approval-item-module ([#8069](https://github.com/keptn/keptn/issues/8069)) ([15050ba](https://github.com/keptn/keptn/commit/15050ba60ce48a171d2ccf9926c480243e623f37))
* **bridge:** Add deletion dialog module ([#8060](https://github.com/keptn/keptn/issues/8060)) ([bac2bc8](https://github.com/keptn/keptn/commit/bac2bc8e2fd1870ccf188e504c5b02eab1d155f5))
* **bridge:** Add ktb-confirmation-dialog module ([#8058](https://github.com/keptn/keptn/issues/8058)) ([dfc286e](https://github.com/keptn/keptn/commit/dfc286e516e2ed185335c94832f202fbddc0b752))
* **bridge:** Add ktb-copy-to-clipboard module ([#8072](https://github.com/keptn/keptn/issues/8072)) ([473fce5](https://github.com/keptn/keptn/commit/473fce5baa601fee106af1d1c4b409e7cc74911c))
* **bridge:** Add ktb-create-service-module ([#8073](https://github.com/keptn/keptn/issues/8073)) ([ff73348](https://github.com/keptn/keptn/commit/ff73348b5a817981195d76ade00334463fbc541a))
* **bridge:** Add ktb-loading module ([#8048](https://github.com/keptn/keptn/issues/8048)) ([b6717fd](https://github.com/keptn/keptn/commit/b6717fdd1a7beee657a9fbccd5c609ee900974ef))
* **bridge:** Add modules in a bulk (01) ([#8077](https://github.com/keptn/keptn/issues/8077)) ([eeef827](https://github.com/keptn/keptn/commit/eeef827260015b8aa4b0bbf669b4f3926e9f4f3f))
* **bridge:** Add modules in a bulk (02) ([#8091](https://github.com/keptn/keptn/issues/8091)) ([1cc9a44](https://github.com/keptn/keptn/commit/1cc9a44e47f6505af3e6124d6e76f54580ab628d))
* **bridge:** Add modules in a bulk (03) ([#8125](https://github.com/keptn/keptn/issues/8125)) ([a28be76](https://github.com/keptn/keptn/commit/a28be76bca7bc05d3af5139d9afba376d2433c5e))
* **bridge:** Add sli-breakdown-module ([#8062](https://github.com/keptn/keptn/issues/8062)) ([dcd09da](https://github.com/keptn/keptn/commit/dcd09da0b72ff98eff4f2c274a9e2ebb947d5399))
* **bridge:** Bundle size report ([#8274](https://github.com/keptn/keptn/issues/8274)) ([ef3c504](https://github.com/keptn/keptn/commit/ef3c504f3d7cf47fa7ef6d9d1fe1ddb917461e63))
* **bridge:** Cleanup app modules and fix missing modules ([#8199](https://github.com/keptn/keptn/issues/8199)) ([58ada1e](https://github.com/keptn/keptn/commit/58ada1ee68176522dd6aaaa37433ce50476f7a54))
* **bridge:** Introduce Configuration and ComponentLogger ([#8042](https://github.com/keptn/keptn/issues/8042)) ([aa4bcf0](https://github.com/keptn/keptn/commit/aa4bcf0eda42faa8d108bafee7a711ad60f73ad0))
* **bridge:** Introduce modules for ktb-proxy-input and others ([#8127](https://github.com/keptn/keptn/issues/8127)) ([258c5a6](https://github.com/keptn/keptn/commit/258c5a603498ef89d7c563298c68b9b273ec4a0f)), closes [#7932](https://github.com/keptn/keptn/issues/7932) [#7932](https://github.com/keptn/keptn/issues/7932) [#7932](https://github.com/keptn/keptn/issues/7932)
* **bridge:** Introduce modules for ktb-sequence-controls and others [#7932](https://github.com/keptn/keptn/issues/7932) ([#8139](https://github.com/keptn/keptn/issues/8139)) ([448e53f](https://github.com/keptn/keptn/commit/448e53fd888a37ca865b431dbdab1db3ce711f57))
* **bridge:** Introduce modules for ktb-sequence-state-info and others [#7932](https://github.com/keptn/keptn/issues/7932) ([#8119](https://github.com/keptn/keptn/issues/8119)) ([e9ff5cc](https://github.com/keptn/keptn/commit/e9ff5cc47a3a5c9d4d414d1dea9c4c91397facf0))
* **bridge:** Introduce modules for sequence-timeline and others [#7932](https://github.com/keptn/keptn/issues/7932) ([#8153](https://github.com/keptn/keptn/issues/8153)) ([e7b2ec6](https://github.com/keptn/keptn/commit/e7b2ec6527f429a8ea28088c96f44a42d5463eb1))
* **bridge:** ktb-certificate-input module ([#8071](https://github.com/keptn/keptn/issues/8071)) ([8cf36aa](https://github.com/keptn/keptn/commit/8cf36aac4155d4061fdaf7b90fb600f647a52903))
* **bridge:** ktb-evaluation-details module ([#8066](https://github.com/keptn/keptn/issues/8066)) ([e7640dd](https://github.com/keptn/keptn/commit/e7640dddc420a9e45990e7973068a90f9180d334))
* **bridge:** Refactor dashboard to use interfaces ([#8205](https://github.com/keptn/keptn/issues/8205)) ([2cbbc2d](https://github.com/keptn/keptn/commit/2cbbc2da7c59791662af4932bf134c6257b6c788))
* **bridge:** Refactor DataService's loadProjects ([#8268](https://github.com/keptn/keptn/issues/8268)) ([8c55b1b](https://github.com/keptn/keptn/commit/8c55b1beb3f3c0cb0e5199bbf8c439f27ae9f342))
* **bridge:** Rename dashboard to dashboard-legacy ([#8097](https://github.com/keptn/keptn/issues/8097)) ([cffbf50](https://github.com/keptn/keptn/commit/cffbf502edb3c128c99ef79b6c98386300c79d43))
* **bridge:** RX-ify the dashboard component ([#8167](https://github.com/keptn/keptn/issues/8167)) ([6d1c05d](https://github.com/keptn/keptn/commit/6d1c05d9ad4047b5bdb941562f27abdc149aab52))
* **bridge:** Support configured AUTH_MSG ([#8043](https://github.com/keptn/keptn/issues/8043)) ([0589b26](https://github.com/keptn/keptn/commit/0589b262fa1844097ee499c8cc153fdefca4f614))
* **bridge:** Support new webhook.yaml version v1beta1 ([#8247](https://github.com/keptn/keptn/issues/8247)) ([bad1ee7](https://github.com/keptn/keptn/commit/bad1ee757c456d1d959ed80934053fb08e1e6c6a))
* **bridge:** Use Configuration Object instead of Env Var ([#8096](https://github.com/keptn/keptn/issues/8096)) ([6a3bc4d](https://github.com/keptn/keptn/commit/6a3bc4daca9f588936af026558acf39e46795cc6))
* **cp-connector:** Connect to NATS only at event source startup ([#8064](https://github.com/keptn/keptn/issues/8064)) ([9793f4e](https://github.com/keptn/keptn/commit/9793f4e252a8cff7621f4f0dffb1d799118b09c9))
* **cp-connector:** HTTP based EventSource implementation ([#8140](https://github.com/keptn/keptn/issues/8140)) ([5e2f548](https://github.com/keptn/keptn/commit/5e2f548ac192064c86414d64abf39fccd8e71654))
* **cp-connector:** Injectable logger implementation ([#8024](https://github.com/keptn/keptn/issues/8024)) ([d074978](https://github.com/keptn/keptn/commit/d0749780a7e57cdf433e0120bcc6699efda0778d))
* **go-sdk:** Use APISet instead of resource handler ([#8059](https://github.com/keptn/keptn/issues/8059)) ([8e00834](https://github.com/keptn/keptn/commit/8e00834cbe93c7cd854c415f5cfd38b9b24817f5))
* **installer:** Helm Chart revamp ([#7678](https://github.com/keptn/keptn/issues/7678)) ([f78f867](https://github.com/keptn/keptn/commit/f78f867743e6477c28b311f4cc84db60bc1f5df3))


### Bug Fixes

* Added longer retry in provisioning URL test ([#8074](https://github.com/keptn/keptn/issues/8074)) ([2d97f9c](https://github.com/keptn/keptn/commit/2d97f9c451397432a910224a22ac862c93a325d0))
* Added proxy to integration test ([#8052](https://github.com/keptn/keptn/issues/8052)) ([52509d6](https://github.com/keptn/keptn/commit/52509d6a1ed4907dc8aeb47af2139f63e52b26ee))
* **bridge:** Corrected misleading message in creating project ([#8142](https://github.com/keptn/keptn/issues/8142)) ([6a1d013](https://github.com/keptn/keptn/commit/6a1d013ea6b0e51aa11858ba8197a507021f392d))
* **bridge:** Fix 'view more' of quick filter ([#8306](https://github.com/keptn/keptn/issues/8306)) ([9453e5b](https://github.com/keptn/keptn/commit/9453e5ba7a852d7e129221f82dc5805e22157b6a))
* **bridge:** Fix approval being sent twice ([#8004](https://github.com/keptn/keptn/issues/8004)) ([3a31f55](https://github.com/keptn/keptn/commit/3a31f552ccb610af982792b91e91aa216ecf71e3))
* **bridge:** Fix broken UI if connection was lost ([#8050](https://github.com/keptn/keptn/issues/8050)) ([746be23](https://github.com/keptn/keptn/commit/746be23f7f86fe5a5b9c4b3173a81c061168749c))
* **bridge:** Fix incorrect selected stage on refresh ([#7974](https://github.com/keptn/keptn/issues/7974)) ([9abd6a3](https://github.com/keptn/keptn/commit/9abd6a31731687646f155b69bb069e051384a921))
* **bridge:** Fix missing evaluation score of sequence ([#8032](https://github.com/keptn/keptn/issues/8032)) ([3fe27e0](https://github.com/keptn/keptn/commit/3fe27e039875bf01e33ddffd3de878bf25df20bb))
* **bridge:** Fix missing sequence menu icon selection ([#8308](https://github.com/keptn/keptn/issues/8308)) ([d841387](https://github.com/keptn/keptn/commit/d8413876fa724291f74c5095d203489297057463))
* **bridge:** Handle invalid bridge versions ([#8283](https://github.com/keptn/keptn/issues/8283)) ([7a17271](https://github.com/keptn/keptn/commit/7a17271df64f3fb4947c6147a22ace3e29d16918))
* **bridge:** Remove previous filter from URL ([#7998](https://github.com/keptn/keptn/issues/7998)) ([fcd19ac](https://github.com/keptn/keptn/commit/fcd19ac27f8270ed1387abed2bbf42276f658d61))
* **bridge:** Respond with a default version payload, when the call to get.keptn.sh/version.json fails ([#8037](https://github.com/keptn/keptn/issues/8037)) ([b4be4ca](https://github.com/keptn/keptn/commit/b4be4cac68f35df15a7f959680e99302f7808320))
* **bridge:** Save client secret in k8s secret ([#8269](https://github.com/keptn/keptn/issues/8269)) ([27f1b6a](https://github.com/keptn/keptn/commit/27f1b6a646743c1984ec2d92c5ca4940c5cae015))
* **bridge:** Settings view overflow problem ([#8291](https://github.com/keptn/keptn/issues/8291)) ([f473eb6](https://github.com/keptn/keptn/commit/f473eb6b24a4a2a3c68ca64452fa2de6ed0f810e))
* **bridge:** Show all evaluations in the environment screen ([#8090](https://github.com/keptn/keptn/issues/8090)) ([ffb937c](https://github.com/keptn/keptn/commit/ffb937ce40d0204daedcfaa37400d334ee693143))
* **bridge:** Show loading indicator for sequences before filters are applied the first time ([#8033](https://github.com/keptn/keptn/issues/8033)) ([04a7eb8](https://github.com/keptn/keptn/commit/04a7eb88b12156941dd78fccb515eca4c9b4a6bd))
* **bridge:** Show the heatmap even if the SLO of an evaluation is invalid ([#7965](https://github.com/keptn/keptn/issues/7965)) ([d0edcbc](https://github.com/keptn/keptn/commit/d0edcbc1052b4dff02741f2d715ce3302bb97c7a))
* **bridge:** Update projects if dashboard is visited ([#7997](https://github.com/keptn/keptn/issues/7997)) ([e201bc1](https://github.com/keptn/keptn/commit/e201bc1aba518ffa6521a5ea097d597ea9ac733b))
* Change name label to respect the nameOverride ([#8249](https://github.com/keptn/keptn/issues/8249)) ([6f6af8b](https://github.com/keptn/keptn/commit/6f6af8bcf38ea70752bdf5c05ec8c79bb96a3c95))
* **cli:** Skip version check for auth sub command ([#8126](https://github.com/keptn/keptn/issues/8126)) ([0b03dd0](https://github.com/keptn/keptn/commit/0b03dd07a3ccc21fef8626d4aa491a7bdae6e1e5))
* **cp-connector:** Added return of error in queue subscribe function ([#8101](https://github.com/keptn/keptn/issues/8101)) ([7285f51](https://github.com/keptn/keptn/commit/7285f5120cd65df0c0d9cfc550c1517cedd32b91))
* **cp-connector:** Synchronized shutdown of cp-connector during cancellation ([#8063](https://github.com/keptn/keptn/issues/8063)) ([a3f3010](https://github.com/keptn/keptn/commit/a3f301010f4f4bc48aa1fdae9c39ecd34ba2c582))
* **distributor:** Limit payload size sent to the distributor's API proxy ([#8200](https://github.com/keptn/keptn/issues/8200)) ([d40ee5b](https://github.com/keptn/keptn/commit/d40ee5bb5585f5d8110b6f1241fe13d285047d2a))
* **installer:** Add missing quotes to env var for distributor ([#8157](https://github.com/keptn/keptn/issues/8157)) ([4fcf792](https://github.com/keptn/keptn/commit/4fcf792d9197872df5f9ea918cdf49baa947fd13))
* **installer:** Revert immutable k8s labels ([#8213](https://github.com/keptn/keptn/issues/8213)) ([bed7b04](https://github.com/keptn/keptn/commit/bed7b045a32dc3f4ff77410dfcda6dafe7c40f9b))
* Integration tests ([#8198](https://github.com/keptn/keptn/issues/8198)) ([23038a1](https://github.com/keptn/keptn/commit/23038a14775f2ad82191c900bcc9789757d73548))
* Only trigger CLI command docs auto-generation for full release tags ([#8120](https://github.com/keptn/keptn/issues/8120)) ([8ffe5fc](https://github.com/keptn/keptn/commit/8ffe5fcdb85418d00585faab742a8a591fbb84e6))
* **resource-service:** Always delete local project directory when project creation fails ([#8123](https://github.com/keptn/keptn/issues/8123)) ([44cbcb3](https://github.com/keptn/keptn/commit/44cbcb33ec2f33e2240e7067f67cf6e6ffca1002))
* **resource-service:** Remove token enforcement ([#8040](https://github.com/keptn/keptn/issues/8040)) ([44f9a4a](https://github.com/keptn/keptn/commit/44f9a4a059addd2eb7a85d7d0a5fe6e428eba813))
* **shipyard-controller:** Add time property to EventFilter ([#8134](https://github.com/keptn/keptn/issues/8134)) ([37bb437](https://github.com/keptn/keptn/commit/37bb437670e5174a19a7eac368b9c9c67b2a892e))
* **shipyard-controller:** Fix project deletion unit test ([#8231](https://github.com/keptn/keptn/issues/8231)) ([12a60f2](https://github.com/keptn/keptn/commit/12a60f267115dc88275c411719adf575a5bafd50))
* **shipyard-controller:** Include namespace in call to provisioning service ([#8041](https://github.com/keptn/keptn/issues/8041)) ([9429678](https://github.com/keptn/keptn/commit/94296789a43ae6a7a4ad8491261a1d0b9ac7e8fb))
* **shipyard-controller:** Project should be deleted even if upstream delete fails ([#8204](https://github.com/keptn/keptn/issues/8204)) ([314c93a](https://github.com/keptn/keptn/commit/314c93abc506882131c32913e57433ab0905eded))
* **shipyard-controller:** Return `ErrProjectNotFound` instead of `nil, nil` when project is not in the db ([#8266](https://github.com/keptn/keptn/issues/8266)) ([2d20f6f](https://github.com/keptn/keptn/commit/2d20f6f891436b81ef168193420addbe55ee4a47))
* Use distributor values namespace and hostname in svc env vars ([#8297](https://github.com/keptn/keptn/issues/8297)) ([7140f5b](https://github.com/keptn/keptn/commit/7140f5ba6d01ec357bc38e32ebd441b2cf47103a))


### Docs

* **cli:** Improve CLI Documentation ([#8061](https://github.com/keptn/keptn/issues/8061)) ([922ba5b](https://github.com/keptn/keptn/commit/922ba5b16aac953b82224a833391291b012b9659))
* Typo: we are using swagger.yaml not swagger.json ([#8099](https://github.com/keptn/keptn/issues/8099)) ([ee6e18b](https://github.com/keptn/keptn/commit/ee6e18bba072c1b491961ca32774213e5e976cd8))


### Refactoring

* **bridge:** Introduce modules for app-header and environment components ([#8158](https://github.com/keptn/keptn/issues/8158)) ([c2174cf](https://github.com/keptn/keptn/commit/c2174cfb977075b9bf0540dca0845e3c433936ca))
* **bridge:** Make use of new Git API model ([#8180](https://github.com/keptn/keptn/issues/8180)) ([8da8df8](https://github.com/keptn/keptn/commit/8da8df85287e01b5bb4cc75bc14ef8fd2041abad))
* **bridge:** Update sequence screen data model ([#8083](https://github.com/keptn/keptn/issues/8083)) ([e031b2f](https://github.com/keptn/keptn/commit/e031b2f0c7c8a4b0c478344ef623b031411d51ac))


### Other

*  Updated webhook and remediation to new sdk ([#8170](https://github.com/keptn/keptn/issues/8170)) ([adfa700](https://github.com/keptn/keptn/commit/adfa7001d6dc2d04cd0489ebf3ba7adf7d2d4ed1))
* Add [@sarahhuber001](https://github.com/sarahhuber001) as member ([#7893](https://github.com/keptn/keptn/issues/7893)) ([1709806](https://github.com/keptn/keptn/commit/17098067f3be2830a2ead91da07aaffad4a8a1cb))
* Add @STRRL to CONTRIBUTORS ([#8149](https://github.com/keptn/keptn/issues/8149)) ([a2745b8](https://github.com/keptn/keptn/commit/a2745b81dd948cad50d51623c4cd5377868aa776))
* **bridge:** Added missing modules ([#8147](https://github.com/keptn/keptn/issues/8147)) ([f436de5](https://github.com/keptn/keptn/commit/f436de55c0942d4831a140337e8e18707d67f4cd))
* **bridge:** Added missing modules for evaluation-details ([#8156](https://github.com/keptn/keptn/issues/8156)) ([c4d75c2](https://github.com/keptn/keptn/commit/c4d75c21e69d1c878463afb259d5573350a4e717))
* **bridge:** Improve has-logs polling ([#8039](https://github.com/keptn/keptn/issues/8039)) ([8b67a23](https://github.com/keptn/keptn/commit/8b67a23746d7fd27891f16b2c4c1e8feaf138890))
* **bridge:** Removed remediation config, only poll remediations when needed ([#8217](https://github.com/keptn/keptn/issues/8217)) ([63bb742](https://github.com/keptn/keptn/commit/63bb7421ed39049fd426760966e4557ae779dcca))
* Bump swagger-ui to version 4.12.0 ([#8279](https://github.com/keptn/keptn/issues/8279)) ([7a9997a](https://github.com/keptn/keptn/commit/7a9997a5aa0d4d7b6ca03e3f1c56159966f38fe2))
* **cli:** Deprecate install uninstall and upgrade commands ([#8103](https://github.com/keptn/keptn/issues/8103)) ([d9c8d58](https://github.com/keptn/keptn/commit/d9c8d585a001ff4885bfb3c506cc08e5ee0bf5cf))
* **cp-connector:** Package restructuring ([#7910](https://github.com/keptn/keptn/issues/7910)) ([9072004](https://github.com/keptn/keptn/commit/90720040a24d5436634e931c42dc7f6ba48fd5f2))
* **cp-connector:** Added debug logs to controlplane ([#8012](https://github.com/keptn/keptn/issues/8012)) ([4f4069f](https://github.com/keptn/keptn/commit/4f4069f42d380975be6f217b66f97fc9c833119f))
* **cp-connector:** Additional debug logs ([#8016](https://github.com/keptn/keptn/issues/8016)) ([efe9ad5](https://github.com/keptn/keptn/commit/efe9ad550f8e4e7d01be7fe762bf94f5004fce54))
* **cp-connector:** Fixed missing error in queuesubscribe for nats ([#8122](https://github.com/keptn/keptn/issues/8122)) ([d57cd8c](https://github.com/keptn/keptn/commit/d57cd8c91758a1afe271ef6c302923adbca3d02d))
* **installer:** Added  API_PROXY_HTTP_TIMEOUT to distributor helm values ([#8138](https://github.com/keptn/keptn/issues/8138)) ([b84391f](https://github.com/keptn/keptn/commit/b84391fef7cc07f5eb26528a15a36224a147f726))
* **installer:** Moved automaticProvisionMsg under features ([#8145](https://github.com/keptn/keptn/issues/8145)) ([d1dcecb](https://github.com/keptn/keptn/commit/d1dcecb18af5d9f0b141fb1e6c833340000d2a0f))
* Mark kubernetes-utils as deprecated ([#8117](https://github.com/keptn/keptn/issues/8117)) ([9ba17c0](https://github.com/keptn/keptn/commit/9ba17c008bd26189ee4af0150a5a69b1ad75d965))
* Remove configuration-service from pipelines ([#8284](https://github.com/keptn/keptn/issues/8284)) ([6b136eb](https://github.com/keptn/keptn/commit/6b136ebcb57b259ac8279d58f528cc621dd2e8f7))
* Remove reference to go-sdk from renovate.json ([#8229](https://github.com/keptn/keptn/issues/8229)) ([5d14929](https://github.com/keptn/keptn/commit/5d14929bf74869920938bff6e966bb77154ea1bf))
* Removed BETA from uniform API ([#8135](https://github.com/keptn/keptn/issues/8135)) ([f1c6c7d](https://github.com/keptn/keptn/commit/f1c6c7dfbb2654cac2fa8f7f1ff763040fb1b72e))
* **shipyard-controller:** Move integration tests to faster component tests ([#8087](https://github.com/keptn/keptn/issues/8087)) ([4303cff](https://github.com/keptn/keptn/commit/4303cfffd79db3b1dad73000e3315a8f3900bec1))
* **shipyard-controller:** Remove references to deprecated subscription ([#8035](https://github.com/keptn/keptn/issues/8035)) ([18afeb4](https://github.com/keptn/keptn/commit/18afeb45fb41acd240d088fe970415eec851bf1f))
* Update cp connector ([#8133](https://github.com/keptn/keptn/issues/8133)) ([38cd84b](https://github.com/keptn/keptn/commit/38cd84bea1f816021072076774301c19e254a825))
* Update cp-connector ref in go-sdk ([#8094](https://github.com/keptn/keptn/issues/8094)) ([23d1878](https://github.com/keptn/keptn/commit/23d18789f3c812e489cd63f5d8d8443301edd4a5))
* Updated k8s dependencies ([#8173](https://github.com/keptn/keptn/issues/8173)) ([87cc798](https://github.com/keptn/keptn/commit/87cc79834333dfa965050f107caa95fc94c80fb6))
* Use logrus StandardLogger in webhook and remediation service ([#8292](https://github.com/keptn/keptn/issues/8292)) ([fd5c201](https://github.com/keptn/keptn/commit/fd5c201599049c2bd0808a551d7a60170bcbd394))

<details>
<summary>Kubernetes Resource Data</summary>

### Resource Stats

| Name                | Container Name      | CPU Request | CPU Limit | RAM Request | RAM Limit | Image                                               |
| ------------------- | ------------------- | ----------- | --------- | ----------- | --------- | --------------------------------------------------- |
| keptn-mongo         | mongodb             | null        | null      | null        | null      | docker.io/bitnami/mongodb:4.4.13-debian-10-r52      |
| api-gateway-nginx   | api-gateway-nginx   | 50m         | 100m      | 64Mi        | 128Mi     | docker.io/nginxinc/nginx-unprivileged:1.22.0-alpine |
| api-service         | api-service         | 50m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/api:0.17.0                          |
| approval-service    | approval-service    | 25m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/approval-service:0.17.0             |
| resource-service    | resource-service    | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/resource-service:0.17.0             |
| bridge              | bridge              | 25m         | 200m      | 64Mi        | 256Mi     | docker.io/keptn/bridge2:0.17.0                      |
| lighthouse-service  | lighthouse-service  | 50m         | 200m      | 128Mi       | 1Gi       | docker.io/keptn/lighthouse-service:0.17.0           |
| mongodb-datastore   | mongodb-datastore   | 50m         | 300m      | 32Mi        | 512Mi     | docker.io/keptn/mongodb-datastore:0.17.0            |
| remediation-service | remediation-service | 50m         | 200m      | 64Mi        | 1Gi       | docker.io/keptn/remediation-service:0.17.0          |
| secret-service      | secret-service      | 25m         | 200m      | 32Mi        | 64Mi      | docker.io/keptn/secret-service:0.17.0               |
| shipyard-controller | shipyard-controller | 50m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/shipyard-controller:0.17.0          |
| statistics-service  | statistics-service  | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/statistics-service:0.17.0           |
| statistics-service  | distributor         | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.17.0                  |
| webhook-service     | webhook-service     | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/webhook-service:0.17.0              |
| keptn-nats          | nats                | null        | null      | null        | null      | nats:2.7.3-alpine                                   |
| keptn-nats          | metrics             | null        | null      | null        | null      | natsio/prometheus-nats-exporter:0.9.1               |

</details>
