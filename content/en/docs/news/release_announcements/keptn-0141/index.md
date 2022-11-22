---
title: Keptn 0.14.1
weight: 75
---

Keptn 0.14.1 contains improvements in the inner models used by the Keptn core services. This improves the resiliency of Keptn and pushes forward upgrading your Keptn installation without any downtime.
Besides, it is now possible to trigger any sequence using the CLI and the Bridge.
Furthermore, the environment screen contains new features: the button for triggering a sequence is on the top of the page and the history of the previous evaluations for the selected service is shown.
The webhook UI allows configuring if Keptn has to wait for the acknowledgment of the webhook receiver.
Finally, Keptn 0.14.x upgrades the NATS dependency and with that, the cluster name changed.
For existing integration that are not yet updated to use a 0.14.x distributor, please update the `PUBSUB_URL` environment variable and set it to `nats://keptn-nats`.


---

**Key announcements:**

:tada: *Improved internal models*: This release is another major step towards zero downtime updates of Keptn core services.

:star: *Trigger sequences* from the Bridge/CLI: It is possible to trigger any sequences directly from the CLI and the Environment screen.

:mailbox: *Webhook UI* supports the configuration to wait for the webhook receiver to send their started event.

:gift: *Evaluation history*: In the Environment screen, the history of the quality gate results for a service is displayed.

---


## [0.14.1](https://github.com/keptn/keptn/compare/0.13.0...0.14.1) (2022-04-01)


### ⚠ BREAKING CHANGES

* **cli:** The CLI does not require anymore passing git_user as a parameter to create or upgrade a project. In case you are experiencing issues with the command, we suggest trying it without specifying the user.
* **configuration-service:** adding invalid token results in a 404 HTTP status code (424 previously)
* **nats**: the NATS cluster name changed from `keptn-nats-cluster` to `keptn-nats`. Please check the [upgrade documentation](https://keptn.sh/docs/0.14.x/operate/upgrade/).

### Features

* Add prometheus-service scope to secret-service ([#6938](https://github.com/keptn/keptn/issues/6938)) ([b2993f2](https://github.com/keptn/keptn/commit/b2993f223444dca7722b204a9d2307ebdb081195))
* Add SSH publicKey auth support ([#6855](https://github.com/keptn/keptn/issues/6855)) ([b1b3d11](https://github.com/keptn/keptn/commit/b1b3d11c6d0ed6dea1016b0757ce4a1d0bddbc85))
* **api:** Added automaticProvisioning helm value to api-service ([#7269](https://github.com/keptn/keptn/issues/7269)) ([0bda1c7](https://github.com/keptn/keptn/commit/0bda1c78c4f6c553109177bbc2b87e088c5dd23f))
* **bridge:** Allow to configure sendStarted flag for webhook config ([#7183](https://github.com/keptn/keptn/issues/7183)) ([7117204](https://github.com/keptn/keptn/commit/7117204fffeab07af57cdbc6b881763057bf6ff5))
* **bridge:** Make secret selection dynamic ([#6940](https://github.com/keptn/keptn/issues/6940)) ([be8394d](https://github.com/keptn/keptn/commit/be8394de2f7bc7a9d5abc5b47375e7f76ce85378))
* **bridge:** Show history of quality gates in environment details ([#7009](https://github.com/keptn/keptn/issues/7009)) ([d1b96ef](https://github.com/keptn/keptn/commit/d1b96ef72ed369e71fcca90290d869ea803193a7))
* **bridge:** Trigger a sequence from Bridge ([#4507](https://github.com/keptn/keptn/issues/4507)) ([84322f3](https://github.com/keptn/keptn/commit/84322f37e19e50e96757f35643287e81530b1b13))
* **bridge:** Use new evaluation finished payload and UI adoptions in SLI breakdown ([#6813](https://github.com/keptn/keptn/issues/6813)) ([711b845](https://github.com/keptn/keptn/commit/711b84512ab47fd3b6e9f066afadb8b92da0b462))
* **cli:** Added keptn trigger `sequence` cmd ([#7070](https://github.com/keptn/keptn/issues/7070)) ([80f2f7d](https://github.com/keptn/keptn/commit/80f2f7d1e2f4fbac9af222fe546e927baf5ce691))
* **cli:** trigger authorization code flow when refresh token is expired ([#7014](https://github.com/keptn/keptn/issues/7014)) ([d596efb](https://github.com/keptn/keptn/commit/d596efbe44b4fbfa182797705a91a293b88ad1fe))
* **distributor:** Added preamble to distributor logs ([#7296](https://github.com/keptn/keptn/issues/7296)) ([1413ad6](https://github.com/keptn/keptn/commit/1413ad6d7f3b5deb93d7f846ec055bea92fa3cd1))
* Improve denied URLs of webhook-service ([#7147](https://github.com/keptn/keptn/issues/7147)) ([d5c1d3c](https://github.com/keptn/keptn/commit/d5c1d3c8ab2573719ad8ba275cfce11b61d3c2ba))
* **resource-service:** Delete project via cloud events ([#7024](https://github.com/keptn/keptn/issues/7024)) ([86b0cb9](https://github.com/keptn/keptn/commit/86b0cb940e69b6cb70019ae6f8538c6ef4499c1b))
* **shipyard-controller:** Added leader election ([#6967](https://github.com/keptn/keptn/issues/6967)) ([c5264bd](https://github.com/keptn/keptn/commit/c5264bd67ba52b65affed9cc8029daa45cfdb10f))
* **shipyard-controller:** Introduce new data model ([#6977](https://github.com/keptn/keptn/issues/6977)) ([f46905a](https://github.com/keptn/keptn/commit/f46905ad97ba5d566737e5703a7a5593b0c2fe1b))
* **shipyard-controller:** Subscribe to events using Jetstream ([#6834](https://github.com/keptn/keptn/issues/6834)) ([753547b](https://github.com/keptn/keptn/commit/753547b592dfd588a51aed939c1e6a5a1d11df43))
* Support --git-commit-id flag in CLI trigger evaluation ([#6956](https://github.com/keptn/keptn/issues/6956)) ([f98155c](https://github.com/keptn/keptn/commit/f98155c54c8732a5caf408ccd12b8c14ed4f2cde))
* Support auth via proxy ([#6984](https://github.com/keptn/keptn/issues/6984)) ([63fca54](https://github.com/keptn/keptn/commit/63fca54f18379d98dba21ed2d5121dc23bb82f05))


### Bug Fixes

* add default helm value for project name max size ([#7289](https://github.com/keptn/keptn/issues/7289)) ([1b016a1](https://github.com/keptn/keptn/commit/1b016a164e2b5ed812b19ff88896c2395fa7d05c))
* Backup git-credentials when using resource-service in integration tests ([#7111](https://github.com/keptn/keptn/issues/7111)) ([cafab72](https://github.com/keptn/keptn/commit/cafab722d95da8579960ac46d85362afdf6e9f76))
* **bridge:** Add latestEvaluationTrace to every stage ([8048020](https://github.com/keptn/keptn/commit/8048020f7f5387c255e6fbcb25f61a1851f12c60))
* **bridge:** Break words in project tile, to keep fix width ([#7214](https://github.com/keptn/keptn/issues/7214)) ([3227f8a](https://github.com/keptn/keptn/commit/3227f8aa02861383d9e9e5163fbc2fd71660dafa))
* **bridge:** Fix duplicated sequence and incorrect show older sequences ([#7054](https://github.com/keptn/keptn/issues/7054)) ([95c5bdc](https://github.com/keptn/keptn/commit/95c5bdc300dd6d3112578c205ad61cead8d1da6c))
* **bridge:** Fix incorrect content security policy ([e575943](https://github.com/keptn/keptn/commit/e5759437196cc189edce635762e1d616812f2d3e))
* **bridge:** Fix no-services message and link ([#7035](https://github.com/keptn/keptn/issues/7035)) ([c9e58a7](https://github.com/keptn/keptn/commit/c9e58a7df8091276c1323250d8911faa0f062388))
* **bridge:** Fix quick filter overflow ([#7077](https://github.com/keptn/keptn/issues/7077)) ([2dff06a](https://github.com/keptn/keptn/commit/2dff06afaba6ea440c4432a69de10da8ea8ea3e9))
* **bridge:** Fix wrong time in sequence timeline ([#7036](https://github.com/keptn/keptn/issues/7036)) ([76811ec](https://github.com/keptn/keptn/commit/76811ece751193cf62dd9d8f38d541771a677b40))
* **bridge:** load projects, also if version.json could not be loaded ([#7241](https://github.com/keptn/keptn/issues/7241)) ([50acc3a](https://github.com/keptn/keptn/commit/50acc3ace3058b3716cf0cdd8b98a420fc6f682c))
* **bridge:** Prevent spaces in URL ([#7023](https://github.com/keptn/keptn/issues/7023)) ([0d01639](https://github.com/keptn/keptn/commit/0d016390bf3f88f6e93493f50f9828ce8d463f79))
* **bridge:** Remove line breaks and unnecessary escaping in strings in webhook.yaml ([#7025](https://github.com/keptn/keptn/issues/7025)) ([23ac339](https://github.com/keptn/keptn/commit/23ac339e9b0a42d72f50d613e1fc42499f98bc99))
* **bridge:** Rounding evaluation score correctly ([#6976](https://github.com/keptn/keptn/issues/6976)) ([5b89a91](https://github.com/keptn/keptn/commit/5b89a916b5542af2e21b016edffa4147a3a90d68))
* **bridge:** Truncate evaluation score ([#6993](https://github.com/keptn/keptn/issues/6993)) ([df8e03a](https://github.com/keptn/keptn/commit/df8e03a4cef074595940be83fb2c8818d8cb29ce))
* **bridge:** Validate start end date duration ([0596eae](https://github.com/keptn/keptn/commit/0596eaec6e5beb363ba3e122af60eea2b45d0456))
* **bridge:** Do not send a start date for evaluation if none is given by the user  ([12d83c3](https://github.com/keptn/keptn/commit/12d83c3adfba400752060783c78a077d4f691bcd))
* **bridge:** Show remediation sequence in default color while running ([#7300](https://github.com/keptn/keptn/issues/7300)) ([#7319](https://github.com/keptn/keptn/issues/7319)) ([4d0887d](https://github.com/keptn/keptn/commit/4d0887d21ac63c2ca8b5f987ce075266f8f8b0cd))
* **cli:** Provide values needed for upgrading the nats dependency ([#7316](https://github.com/keptn/keptn/issues/7316)) ([d3d9faf](https://github.com/keptn/keptn/commit/d3d9faf9edaddb20a2dfef15f1bd7565df63f236))
* **cli:** Added missing env variables to tests ([#6867](https://github.com/keptn/keptn/issues/6867)) ([33feef1](https://github.com/keptn/keptn/commit/33feef190a54d6c8414d897ddf9604af6b912034))
* **cli:** Fixed parsing of image option in trigger delivery ([#7302](https://github.com/keptn/keptn/issues/7302)) ([171a979](https://github.com/keptn/keptn/commit/171a979e5f510c25f0d17ae8f0f81824c9c93dc9))
* **cli:** Removed user check from create/update project and added simple tests ([#7193](https://github.com/keptn/keptn/issues/7193)) ([2b490d5](https://github.com/keptn/keptn/commit/2b490d597e4718b76954d0a1b0179148bcaddb64))
* **configuration-service:** Return 404 when token is invalid ([#7121](https://github.com/keptn/keptn/issues/7121)) ([6805da2](https://github.com/keptn/keptn/commit/6805da214c6c620ffab5edbbd152681c24c9dd6c))
* correct passing of projectNameMaxSize helm value with quotes ([#7288](https://github.com/keptn/keptn/issues/7288)) ([517e2a2](https://github.com/keptn/keptn/commit/517e2a2b74d7bd67320a5aae999b8582daf5294d))
* **distributor:** Added longer sleep for Nats down test in forwarder ([#7205](https://github.com/keptn/keptn/issues/7205)) ([3fff36d](https://github.com/keptn/keptn/commit/3fff36dd8ddaa0d7fd6d27f9a90e7ec9c2fff27c))
* **distributor:** Fixed reconnection issue of (re)used ce clients ([#7109](https://github.com/keptn/keptn/issues/7109)) ([9b69d64](https://github.com/keptn/keptn/commit/9b69d648055b6131a3cc49e7655b4fbfc8e61659))
* **distributor:** Include event filter for project, stage, service ([#6968](https://github.com/keptn/keptn/issues/6968)) ([#6972](https://github.com/keptn/keptn/issues/6972)) ([6ab050d](https://github.com/keptn/keptn/commit/6ab050d6bbc37a02ea8506d6c3fc5dd2472805c0))
* **distributor:** Increase timout of http client to 30s ([#6948](https://github.com/keptn/keptn/issues/6948)) ([#6954](https://github.com/keptn/keptn/issues/6954)) ([3ccbd77](https://github.com/keptn/keptn/commit/3ccbd77f32d95bf3540817a9d59f89591e88a3fb))
* **distributor:** shut down distributor when not able to send heartbeat to control plane ([#7263](https://github.com/keptn/keptn/issues/7263)) ([7c50feb](https://github.com/keptn/keptn/commit/7c50feb198a95d8663bd2dfa4bb7f6a839237011))
* ensure indicators are set in computeObjectives ([#6922](https://github.com/keptn/keptn/issues/6922)) ([b1cc56d](https://github.com/keptn/keptn/commit/b1cc56d543982212772acf32ef4ca398943822a0))
* Forbid project names longer than a certain size ([#7277](https://github.com/keptn/keptn/issues/7277)) ([237c4cf](https://github.com/keptn/keptn/commit/237c4cf2e32567e928ddd18c9ac29574c09df6b9))
* hardening of oauth in distributor and cli ([#6917](https://github.com/keptn/keptn/issues/6917)) ([b73a379](https://github.com/keptn/keptn/commit/b73a3798aa393edef7d17b6b577683415ca3bfae))
* **helm-service:** Handling of helm-charts loading problems ([#7108](https://github.com/keptn/keptn/issues/7108)) ([3a60e50](https://github.com/keptn/keptn/commit/3a60e50d2bb35f6ef704e8335c2a329012150cd9))
* **installer:** Make securityContext configurable ([#6932](https://github.com/keptn/keptn/issues/6932)) ([#6949](https://github.com/keptn/keptn/issues/6949)) ([b711b0a](https://github.com/keptn/keptn/commit/b711b0a1b1fa4d137eb9177015726de8f134e128))
* **lighthouse-service:** Fail sequence when evaluation is aborted/errored ([#7211](https://github.com/keptn/keptn/issues/7211)) ([1faca09](https://github.com/keptn/keptn/commit/1faca099c982b4536748d8559ef438f664d0d056))
* Normalize error messages ([#7080](https://github.com/keptn/keptn/issues/7080)) ([0730f1d](https://github.com/keptn/keptn/commit/0730f1d1cb33bf604893b55aba5922365b50455d))
* **resource-service:** fix nats subscription and added retry logic ([#7215](https://github.com/keptn/keptn/issues/7215)) ([180d833](https://github.com/keptn/keptn/commit/180d833bcbc3cdd35f3d71694a653d9550e9ce9e))
* **resource-service:** Make sure to delete "/" prefix in resourcePath when resolving git commit id ([#6919](https://github.com/keptn/keptn/issues/6919)) ([2ae4c52](https://github.com/keptn/keptn/commit/2ae4c5223a59f774c040b65f2fd38df2cc3756f4))
* **shipyard-controller:** Abort multi-stage sequences ([#7175](https://github.com/keptn/keptn/issues/7175)) ([d06aefb](https://github.com/keptn/keptn/commit/d06aefb519108436840be23b566a27046345ea72))
* **shipyard-controller:** Consider parallel stages when trying to set overall sequence state to finished ([#7250](https://github.com/keptn/keptn/issues/7250)) ([9550f59](https://github.com/keptn/keptn/commit/9550f5986e20ad70b5d5d00bf58dc055462d7fe5))
* **shipyard-controller:** Do not exit pull subscription loop when invalid event has been received ([#7255](https://github.com/keptn/keptn/issues/7255)) ([75c5971](https://github.com/keptn/keptn/commit/75c59716d6a042a923c8b4557dfa2f7f02f39544))
* **shipyard-controller:** Do not reset subscriptions when updating distributor/integration version ([#7046](https://github.com/keptn/keptn/issues/7046)) ([#7059](https://github.com/keptn/keptn/issues/7059)) ([5865cf1](https://github.com/keptn/keptn/commit/5865cf1c3a538c332e5522dce307a578f5dc60fd)), closes [#6598](https://github.com/keptn/keptn/issues/6598) [#6613](https://github.com/keptn/keptn/issues/6613) [#6618](https://github.com/keptn/keptn/issues/6618) [#6619](https://github.com/keptn/keptn/issues/6619) [#6634](https://github.com/keptn/keptn/issues/6634) [#6559](https://github.com/keptn/keptn/issues/6559) [#6642](https://github.com/keptn/keptn/issues/6642) [#6643](https://github.com/keptn/keptn/issues/6643) [#6659](https://github.com/keptn/keptn/issues/6659) [#6670](https://github.com/keptn/keptn/issues/6670) [#6632](https://github.com/keptn/keptn/issues/6632) [#6718](https://github.com/keptn/keptn/issues/6718) [#6816](https://github.com/keptn/keptn/issues/6816) [#6819](https://github.com/keptn/keptn/issues/6819) [#6820](https://github.com/keptn/keptn/issues/6820) [#6875](https://github.com/keptn/keptn/issues/6875) [#6763](https://github.com/keptn/keptn/issues/6763) [#6857](https://github.com/keptn/keptn/issues/6857) [#6804](https://github.com/keptn/keptn/issues/6804) [#6931](https://github.com/keptn/keptn/issues/6931) [#6944](https://github.com/keptn/keptn/issues/6944) [#6966](https://github.com/keptn/keptn/issues/6966) [#6971](https://github.com/keptn/keptn/issues/6971)
* **webhook-service:** Disallow `@` file uploads inside data block ([#7158](https://github.com/keptn/keptn/issues/7158)) ([aa0f71e](https://github.com/keptn/keptn/commit/aa0f71e4fffda8c0959d7e7ef32dd90f6f9914f5))
* **webhook-service:** enhance denylist of disallowed urls ([#7191](https://github.com/keptn/keptn/issues/7191)) ([048dbe4](https://github.com/keptn/keptn/commit/048dbe45685b3b383cea052f42612f37079bd323))
* **webhook-service:** Fix retrieval of webhook config ([#7144](https://github.com/keptn/keptn/issues/7144)) ([08ae798](https://github.com/keptn/keptn/commit/08ae798e5436055e936f60628ca2c3b41fdce341))


### Docs

* **bridge:** Add documentation for environment variables ([0bb45a9](https://github.com/keptn/keptn/commit/0bb45a9475a4d4411e1d0b0ee86ae468a9b03e39))
* Reference the code of conduct in the .github repository ([#7110](https://github.com/keptn/keptn/issues/7110)) ([3dbd75c](https://github.com/keptn/keptn/commit/3dbd75c52f99fb0a7864801021eef037e4aa2342))
* Stop-gap info about filtering by stage, project,service ([#7155](https://github.com/keptn/keptn/issues/7155)) ([ee03d92](https://github.com/keptn/keptn/commit/ee03d9260d55c197d7b7aed7b54b707adedf0b9c))
* Use K3d 5.3.0 in README for developing ([#6926](https://github.com/keptn/keptn/issues/6926)) ([f02cad5](https://github.com/keptn/keptn/commit/f02cad5de1c584621504fdd4b3fe7bf4c19870e2))


### Other

*  Changed all integration tests to use go utils ([#7165](https://github.com/keptn/keptn/issues/7165)) ([d926eb4](https://github.com/keptn/keptn/commit/d926eb429404f892c1628862a3d5ff6bf075d4d8))
* Add [@j-poecher](https://github.com/j-poecher) as member ([#7294](https://github.com/keptn/keptn/issues/7294)) ([979e81d](https://github.com/keptn/keptn/commit/979e81daa1803f2b21069ba12274fe24275968ad))
* Add [@pchila](https://github.com/pchila) as member to maintainers.md ([#6946](https://github.com/keptn/keptn/issues/6946)) ([b919720](https://github.com/keptn/keptn/commit/b9197205ce633f6b0dd277337d72aff1840b1931))
* Add [@raffy23](https://github.com/raffy23) as member ([#7174](https://github.com/keptn/keptn/issues/7174)) ([67fa5a5](https://github.com/keptn/keptn/commit/67fa5a5e4c139e6672c28e88015af62118366593))
* Add Slack issue link ([#7181](https://github.com/keptn/keptn/issues/7181)) ([33bd789](https://github.com/keptn/keptn/commit/33bd7896038684343ec779edd581f55f28d4ac83))
* **bridge:** Remove unused dependencies ([#7012](https://github.com/keptn/keptn/issues/7012)) ([9be7608](https://github.com/keptn/keptn/commit/9be760883d44ed513f391a2fef1fee4bef109659))
* **distributor:** cleanup of package structure ([#7028](https://github.com/keptn/keptn/issues/7028)) ([e97875c](https://github.com/keptn/keptn/commit/e97875cad6031bbe175aaedf865a9ebec1ea2c58))
* **distributor:** hardening of unit test stability ([#6992](https://github.com/keptn/keptn/issues/6992)) ([f4f1365](https://github.com/keptn/keptn/commit/f4f13650de9b5a9efb984bb466b9397bd32bab77))
* **installer:** Cleaned up common labels ([#6796](https://github.com/keptn/keptn/issues/6796)) ([1f6f6dc](https://github.com/keptn/keptn/commit/1f6f6dcb77f2cb5bd548ac7b11ce1b5f74ea4f42))
* **jmeter-service:** Updated Dynatrace JMeter extension to 1.8.0 ([#6879](https://github.com/keptn/keptn/issues/6879)) ([89b2ba1](https://github.com/keptn/keptn/commit/89b2ba170deb10f400295c64103c53dffcb7a452))
* Move Stage API endpoint into the correct subsection ([#6994](https://github.com/keptn/keptn/issues/6994)) ([bac751d](https://github.com/keptn/keptn/commit/bac751d74a3e60f107d9824c341a1bdc2be555f9))
* Removed makefile and all usages of it ([#6804](https://github.com/keptn/keptn/issues/6804)) ([e55355f](https://github.com/keptn/keptn/commit/e55355ffaa7b19c9ce2394400e8405876778c03a))
* Replace the Security guidelines by the hyperlink ([#7145](https://github.com/keptn/keptn/issues/7145)) ([f640e2c](https://github.com/keptn/keptn/commit/f640e2c308ef56e1641507f7059912852018bd73))
* Upgrade to Go 1.17 ([#7095](https://github.com/keptn/keptn/issues/7095)) ([9deafc9](https://github.com/keptn/keptn/commit/9deafc95f694796ebdfc6fc9388878eccea348ca))
* Use correct Keptn branding logo and spelling ([#7240](https://github.com/keptn/keptn/issues/7240)) ([376ce36](https://github.com/keptn/keptn/commit/376ce36952f1e3e632a5ea972417b9648db41563))
* **webhook-service:** added test for being able to use @ char inside payload ([#7166](https://github.com/keptn/keptn/issues/7166)) ([68db33c](https://github.com/keptn/keptn/commit/68db33cd041f55ae82d4f745b482d73c635517e3))
* **webhook-service:** replaced "unallowed" with "denied" ([#7286](https://github.com/keptn/keptn/issues/7286)) ([ac3e52e](https://github.com/keptn/keptn/commit/ac3e52e274f1c61e5119afac3f4b3435cf817214))

<details>
<summary>Kubernetes Resource Data</summary>

### Resource Stats

| Name                  | Container Name        | CPU Request | CPU Limit | RAM Request | RAM Limit | Image                                               |
| --------------------- | --------------------- | ----------- | --------- | ----------- | --------- | --------------------------------------------------- |
| keptn-mongo           | mongodb               | null        | null      | null        | null      | docker.io/bitnami/mongodb:4.4.9-debian-10-r0        |
| api-gateway-nginx     | api-gateway-nginx     | 50m         | 100m      | 64Mi        | 128Mi     | docker.io/nginxinc/nginx-unprivileged:1.21.6-alpine |
| api-service           | api-service           | 50m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/api:0.14.1                          |
| api-service           | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.14.1                  |
| approval-service      | approval-service      | 25m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/approval-service:0.14.1             |
| approval-service      | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.14.1                  |
| configuration-service | configuration-service | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/configuration-service:0.14.1        |
| remediation-service   | remediation-service   | 50m         | 200m      | 64Mi        | 1Gi       | docker.io/keptn/remediation-service:0.14.1          |
| remediation-service   | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.14.1                  |
| bridge                | bridge                | 25m         | 200m      | 64Mi        | 256Mi     | docker.io/keptn/bridge2:0.14.1                      |
| mongodb-datastore     | mongodb-datastore     | 50m         | 300m      | 32Mi        | 512Mi     | docker.io/keptn/mongodb-datastore:0.14.1            |
| mongodb-datastore     | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.14.1                  |
| lighthouse-service    | lighthouse-service    | 50m         | 200m      | 128Mi       | 1Gi       | docker.io/keptn/lighthouse-service:0.14.1           |
| lighthouse-service    | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.14.1                  |
| secret-service        | secret-service        | 25m         | 200m      | 32Mi        | 64Mi      | docker.io/keptn/secret-service:0.14.1               |
| shipyard-controller   | shipyard-controller   | 50m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/shipyard-controller:0.14.1          |
| statistics-service    | statistics-service    | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/statistics-service:0.14.1           |
| statistics-service    | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.14.1                  |
| webhook-service       | webhook-service       | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/webhook-service:0.14.1              |
| webhook-service       | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.14.1                  |
| keptn-nats            | nats                  | null        | null      | null        | null      | nats:2.7.3-alpine                                   |
| keptn-nats            | metrics               | null        | null      | null        | null      | natsio/prometheus-nats-exporter:0.9.1               |

</details>
