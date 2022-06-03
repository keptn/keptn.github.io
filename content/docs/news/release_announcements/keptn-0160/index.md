---
title: Keptn 0.16.0
weight: 72
---

# Release Notes 0.16.0

Keptn 0.16.0 provides the ability to upgrade your Keptn installation without any downtime. For this, Keptn requires each project to have an [upstream Git repository](../manage/git_upstream).
Make sure to check the [upgrade instructions](../../../0.16.x/operate/upgrade/) to ensure that you do not lose any data.


---

**Key announcements**:

:tada: *Zero downtime upgrades*: Operators can upgrade Keptn without downtime.

:star: *Performance gains in backend and frontend*: Performance implications when working with resource files have been resolved due to a new backend service. In addition, the Keptn Bridge received performance improvements by an adapted polling behavior.

:sparkles: *(experimental) New heatmap for SLI breakdown*: Keptn Bridge is leveraging a new rendering library that offers more flexibility for displaying the SLI breakdown. If you want to try it out, you can enable it by setting the Helm value `control-plane.bridge.d3heatmap.enabled` to `true`.

---


### ⚠ BREAKING CHANGES

* The `resource-service` replaces the old `configuration-service`. The new service always requires a Git upstream to be configured for a Keptn project. The new service will bring many advantages, such as faster response times and the possibility to upgrade Keptn without any downtime.

### Features

* Add ability to customize client_max_body_size in the nginx gateway ([#7727](https://github.com/keptn/keptn/issues/7727)) ([d27033b](https://github.com/keptn/keptn/commit/d27033bcbc20770f73bd758b9e1181b49b62e344))
* **api:** Send events directly to nats instead via distributor ([#7672](https://github.com/keptn/keptn/issues/7672)) ([58f9615](https://github.com/keptn/keptn/commit/58f9615679006fd74c3fb23bceb448499b7aba02))
* **approval-service:** Consider nats connection in readiness probe ([#7723](https://github.com/keptn/keptn/issues/7723)) ([d170354](https://github.com/keptn/keptn/commit/d1703544a4999feeac7ac0f4c49d141b01f680d6))
* **approval-service:** Run approval-service without distributor sideCar ([#7689](https://github.com/keptn/keptn/issues/7689)) ([bceaf4b](https://github.com/keptn/keptn/commit/bceaf4b5e298170073c566fc28361ae474e80898))
* **bridge:** Automatic provisioning url makes git form optional and ap message can be set and displayed ([60bd257](https://github.com/keptn/keptn/commit/60bd2573c02a875c44cfaa876be23d36ad6597d5))
* **bridge:** Implement heatmap with d3 ([#7658](https://github.com/keptn/keptn/issues/7658)) ([84dc4a0](https://github.com/keptn/keptn/commit/84dc4a08e806446edb6cef2da3ac9435d0af042b))
* **bridge:** Introduce Module (ktb-notification) ([#7897](https://github.com/keptn/keptn/issues/7897)) ([a87254a](https://github.com/keptn/keptn/commit/a87254a911001d86c197f4e3546f262e71fe9168))
* **bridge:** Make filters in sequence view stable across page refresh ([#7526](https://github.com/keptn/keptn/issues/7526)) ([0b18e45](https://github.com/keptn/keptn/commit/0b18e45695648e96d37f5d61b621fe0301de6e64))
* **bridge:** Remove millis and micros from evaluation time frame ([#7774](https://github.com/keptn/keptn/issues/7774)) ([15b4735](https://github.com/keptn/keptn/commit/15b4735e43a2d3b380342c1939b4af7aac6de25c))
* **bridge:** Remove polling for evaluation history in environment screen ([#7851](https://github.com/keptn/keptn/issues/7851)) ([71874bd](https://github.com/keptn/keptn/commit/71874bdac5da1ab4cc1c8fe7ffb961cd49858880))
* **bridge:** Remove polling for services in settings screen ([#7853](https://github.com/keptn/keptn/issues/7853)) ([b99032c](https://github.com/keptn/keptn/commit/b99032c8c9d808535df6e02a4943cf05c7e3300f))
* **bridge:** Remove tag input field for creating a sequence ([#7757](https://github.com/keptn/keptn/issues/7757)) ([2e16548](https://github.com/keptn/keptn/commit/2e16548b8f3775e7252d60b6645254b2841920f9))
* **bridge:** Removes projects polling on dashboard [#7796](https://github.com/keptn/keptn/issues/7796) ([#7812](https://github.com/keptn/keptn/issues/7812)) ([7a71e05](https://github.com/keptn/keptn/commit/7a71e056f59e65edc99918763aa71759b16af6c5))
* **bridge:** Trigger sequence - Remove polling for custom sequences ([#7813](https://github.com/keptn/keptn/issues/7813)) ([138a773](https://github.com/keptn/keptn/commit/138a77374deb34e69adb67299d7cff22b67c193b))
* **bridge:** Use ktb-heatmap component ([#7816](https://github.com/keptn/keptn/issues/7816)) ([5bca4bd](https://github.com/keptn/keptn/commit/5bca4bd3a077f8eef400508d61b81d9126611ab7))
* Change default values of preStop hook time and grace period ([#7682](https://github.com/keptn/keptn/issues/7682)) ([a31023b](https://github.com/keptn/keptn/commit/a31023b46f36e7566886767423c23681177d6214))
* **cp-connector:** Ensure mandatory CloudEvent attributes are set ([#7744](https://github.com/keptn/keptn/issues/7744)) ([becb01f](https://github.com/keptn/keptn/commit/becb01f3a1b68d666f4f0c96b611975a20c3574a))
* **cp-connector:** Introduce log forwarding to `cp-connector` library ([#7713](https://github.com/keptn/keptn/issues/7713)) ([c36faf0](https://github.com/keptn/keptn/commit/c36faf0071dc689abbc692c460dfd35981f4b962))
* **cp-connector:** Make sure event timestamp is always set  ([#7743](https://github.com/keptn/keptn/issues/7743)) ([6473142](https://github.com/keptn/keptn/commit/64731420f4215b1cc45a0f75f2740612e1169ae5))
* Enable Resource-Service by default ([#7826](https://github.com/keptn/keptn/issues/7826)) ([73d264b](https://github.com/keptn/keptn/commit/73d264b376a20f52f71d63e6960a58eeb5dcdb34))
* **lighthouse-service:** Adapt readiness probe of lighthouse service to consider nats subscription ([#7735](https://github.com/keptn/keptn/issues/7735)) ([51837d7](https://github.com/keptn/keptn/commit/51837d7e3ddd893b61476fb6c0e23c734ece5108))
* **lighthouse-service:** Run lighthouse-service without distributor sidecar ([#7691](https://github.com/keptn/keptn/issues/7691)) ([b2ad6ad](https://github.com/keptn/keptn/commit/b2ad6adf4cdfa11aab37e5031b116fd586a0f43c))
* **mongodb-datastore:** Use cp-connector library ([#7685](https://github.com/keptn/keptn/issues/7685)) ([defee50](https://github.com/keptn/keptn/commit/defee50b0a039ecec36312a315dc466141ebb31c))
* Refactor `go-sdk` to use `cp-connector` internally ([#7686](https://github.com/keptn/keptn/issues/7686)) ([1712149](https://github.com/keptn/keptn/commit/171214903be538942fbc32e41435a1746abd56cc))
* **resource-service:** Removed NATS ([#7694](https://github.com/keptn/keptn/issues/7694)) ([fa48649](https://github.com/keptn/keptn/commit/fa48649afe87d11bdebc773d37f695ca6fca1c87))


### Bug Fixes

* Added retry to url provisioning integration test ([#7815](https://github.com/keptn/keptn/issues/7815)) ([93095eb](https://github.com/keptn/keptn/commit/93095ebcc9bc544377d081730b54adca0fdca7c9))
* **approval-service:** Use deployment name for registration name to fix queue group functionality ([#7718](https://github.com/keptn/keptn/issues/7718)) ([42cf370](https://github.com/keptn/keptn/commit/42cf370969c21b46d000098bc660ae368e84120b))
* **bridge:** Add missing update project notification ([#7770](https://github.com/keptn/keptn/issues/7770)) ([4bdaa71](https://github.com/keptn/keptn/commit/4bdaa717415d34ed2866b32224e3fb7a53b916a2))
* **bridge:** Allow Webhook configuration URL to be a secret ([#7728](https://github.com/keptn/keptn/issues/7728)) ([0372484](https://github.com/keptn/keptn/commit/0372484907c9a7ce0a70f1397fb672205b2c4e52))
* **bridge:** Duplicate headline in project settings page ([#7988](https://github.com/keptn/keptn/issues/7988)) ([1645230](https://github.com/keptn/keptn/commit/1645230fffa3df299c6270b13bb8196ce5e3eb23))
* **bridge:** Fix D3 heatmap selection ([#7842](https://github.com/keptn/keptn/issues/7842)) ([c15740a](https://github.com/keptn/keptn/commit/c15740a9cc6e72531b430bede317509ff59e4fc0))
* **bridge:** Fix logout not being visible if metadata is not returned ([#7794](https://github.com/keptn/keptn/issues/7794)) ([1c2b196](https://github.com/keptn/keptn/commit/1c2b1967442db69e6d398e07631370d8b3a1e63e))
* **bridge:** Fixed D3 heatmap issues ([#7833](https://github.com/keptn/keptn/issues/7833)) ([3e697bf](https://github.com/keptn/keptn/commit/3e697bf16d700d6398ca3c907b0b1a7c14068843))
* **bridge:** Fixed missing 'View service details' button ([#7806](https://github.com/keptn/keptn/issues/7806)) ([41cb52d](https://github.com/keptn/keptn/commit/41cb52de9552d1d9b56d1625be3474b4360924e2))
* **bridge:** Fixed triggering of validation on token reset ([#7766](https://github.com/keptn/keptn/issues/7766)) ([85dc15b](https://github.com/keptn/keptn/commit/85dc15b92eb222c098aa457166cb354812c2fc15))
* **cli:** Remove unnecessary `--sequence` flag from `keptn trigger sequence` ([#7902](https://github.com/keptn/keptn/issues/7902)) ([b252b6d](https://github.com/keptn/keptn/commit/b252b6d70ec70d34afc2dc02709e9cde30a6544f))
* Correctly match nginx location for Bridge ([#7729](https://github.com/keptn/keptn/issues/7729)) ([dd236ef](https://github.com/keptn/keptn/commit/dd236ef4fa97ece1b9ba3703c2b66e939dbc9215))
* **cp-connector:** Added missing Register() method to FixedSubscriptionSource ([#7731](https://github.com/keptn/keptn/issues/7731)) ([fe5b978](https://github.com/keptn/keptn/commit/fe5b9782f67d7ae14524d38f1712ea0cf3eb9703))
* **cp-connector:** Fix passing deduplicated subjects to nats subscriber ([#7782](https://github.com/keptn/keptn/issues/7782)) ([39124e1](https://github.com/keptn/keptn/commit/39124e19d65f7455ad2aaffee0110fd33b503cba))
* **cp-connector:** Flaky unit test ([#7976](https://github.com/keptn/keptn/issues/7976)) ([be9cafb](https://github.com/keptn/keptn/commit/be9cafbd2b97d36e86198b2f8ca78993639ccdc4))
* **cp-connector:** Subscribe to integrations before creating a job ([#7952](https://github.com/keptn/keptn/issues/7952)) ([ccc4f26](https://github.com/keptn/keptn/commit/ccc4f2648267e54bc6b92893120183420064c409))
* **cp-connector:** Unsubscribe instead of disconnect from nats on cancel ([#7795](https://github.com/keptn/keptn/issues/7795)) ([8854339](https://github.com/keptn/keptn/commit/885433905cc0bc0eb727d89986c41d048c5cfd46))
* Disallow calls to `SendEvent` or `GetMetaData` when used via `InternalAPISet` ([#7939](https://github.com/keptn/keptn/issues/7939)) ([d683005](https://github.com/keptn/keptn/commit/d683005ae55f7f871821e0f492e040d651369050))
* Ensure that all mongodb cursors are being closed after use ([#7909](https://github.com/keptn/keptn/issues/7909)) ([01c0a9d](https://github.com/keptn/keptn/commit/01c0a9df26ca7222611aec26aa2c365ac17fe5f2))
* Fixed zd test to run without UI tests ([#7908](https://github.com/keptn/keptn/issues/7908)) ([bd8fb20](https://github.com/keptn/keptn/commit/bd8fb209478eea9536002697bd7f59e9234d878f))
* **go-sdk:** Return from event handler when wg for graceful shutdown cannot be retrieved from context ([#7810](https://github.com/keptn/keptn/issues/7810)) ([2c2ed2c](https://github.com/keptn/keptn/commit/2c2ed2c2c496c360c1b082a187ed54952e4e000e))
* **go-sdk:** Use the correct env var for setting the integration version ([#7930](https://github.com/keptn/keptn/issues/7930)) ([cd130b7](https://github.com/keptn/keptn/commit/cd130b7b8291b16fc3aecac8347b06e15a4ee533))
* **installer:** Adapt preStop hook times for lighthouse, statistics and webhook ([#7947](https://github.com/keptn/keptn/issues/7947)) ([3e9f9b5](https://github.com/keptn/keptn/commit/3e9f9b51839aa0da3fdea1372a4698d3a8a3ec97))
* **installer:** Add resource service to airgapped installer script ([#7869](https://github.com/keptn/keptn/issues/7869)) ([2196c11](https://github.com/keptn/keptn/commit/2196c11be8ceddb2935317675d760a13e47efb09))
* **installer:** Configure default preStopHook and grafefulPeriods timeouts ([#7926](https://github.com/keptn/keptn/issues/7926)) ([7a6489c](https://github.com/keptn/keptn/commit/7a6489c3360521a9294676f1b382a20b2fdee4c8))
* **installer:** Fix airgapped setup not finding correct nginx image ([#7935](https://github.com/keptn/keptn/issues/7935)) ([2ee4bab](https://github.com/keptn/keptn/commit/2ee4bab3b1a885cc749be0b8ed7acf9e896fba45))
* **installer:** Fix wrong regex for log location ([#7921](https://github.com/keptn/keptn/issues/7921)) ([295099d](https://github.com/keptn/keptn/commit/295099dc4de84f95832f1f644c5268f0874e7c33))
* **installer:** Redirect output of preStop hook command to /dev/null ([#7837](https://github.com/keptn/keptn/issues/7837)) ([117f1fb](https://github.com/keptn/keptn/commit/117f1fb9a35540a76e7c5c20e8908e81af660568))
* **installer:** Use exec preStop hook for shipyard controller ([#7768](https://github.com/keptn/keptn/issues/7768)) ([283f72f](https://github.com/keptn/keptn/commit/283f72f71950c0341967a3c26fb85b03c716151d))
* **lighthouse-service:** Ensure sloFileContent property is always a base64 encoded string ([#7892](https://github.com/keptn/keptn/issues/7892)) ([e19fcfc](https://github.com/keptn/keptn/commit/e19fcfc9291c8751f0cdc34109b6f6ab5f48c197))
* Make sure that all events are being processed before shutting down lighthouse/approval service ([#7787](https://github.com/keptn/keptn/issues/7787)) ([0facb58](https://github.com/keptn/keptn/commit/0facb58c8a295aec4a594db7c965552056ff46fb))
* **mongodb-datastore:** Change name of integration to name of service instead of pod name ([#7777](https://github.com/keptn/keptn/issues/7777)) ([21d2774](https://github.com/keptn/keptn/commit/21d2774b751b7dde6b7bf341d4ecce5200eb9797))
* **mongodb-datastore:** Return [] instead of nil from get methods ([#7919](https://github.com/keptn/keptn/issues/7919)) ([4992bc5](https://github.com/keptn/keptn/commit/4992bc56f6632f8c76e91c1c81baef8409be4d1c))
* Removed wrong beta11 from webhook integration test ([#7861](https://github.com/keptn/keptn/issues/7861)) ([08ee81d](https://github.com/keptn/keptn/commit/08ee81d2bec8d452e0433bae2b559c2157044a9e))
* Return missing error in test-utils ([#7928](https://github.com/keptn/keptn/issues/7928)) ([d42af22](https://github.com/keptn/keptn/commit/d42af221680d7f24d49d8a52a47ab9b20f84ac91))
* **secret-service:** Deleting a secret does not remove references from related roles ([#7789](https://github.com/keptn/keptn/issues/7789)) ([56786b8](https://github.com/keptn/keptn/commit/56786b8b1aef7b87e12ce4b3ca26d1cb9b1ff6a8))
* **shipyard-controller:** Allow parallel sequence execution if the service is different ([#7775](https://github.com/keptn/keptn/issues/7775)) ([5f2dc74](https://github.com/keptn/keptn/commit/5f2dc7495ec33202a01712ef767ccbc41f872cfd))
* **shipyard-controller:** Avoid lost writes to subscriptions due to concurrent writes ([#7960](https://github.com/keptn/keptn/issues/7960)) ([1c9b40b](https://github.com/keptn/keptn/commit/1c9b40b7d11d6659fd208e40b56e2d27d829ca8f))
* **shipyard-controller:** Dispatch new sequence directly only if no older sequence is waiting ([#7793](https://github.com/keptn/keptn/issues/7793)) ([b8bad71](https://github.com/keptn/keptn/commit/b8bad7162821aba8c7d09794a4a1337756adee5e))
* **shipyard-controller:** Make sure result and status are set if sequence is timed out ([#7901](https://github.com/keptn/keptn/issues/7901)) ([81858c0](https://github.com/keptn/keptn/commit/81858c0372ee9d494f8976594598fe989b3731b9))
* **shipyard-controller:** Set the sequence execution state back to `started` when approval task has been finished ([#7838](https://github.com/keptn/keptn/issues/7838)) ([8444b48](https://github.com/keptn/keptn/commit/8444b481dbb315f234116530e0c1d03040436446))
* **webhook-service:** Added denied curl in webhook beta based on host ([#7716](https://github.com/keptn/keptn/issues/7716)) ([d194367](https://github.com/keptn/keptn/commit/d1943671b8ccc5a13c50dafd833c486a54aedb9b))
* **webhook-service:** Added missing webhook-config version check ([#7832](https://github.com/keptn/keptn/issues/7832)) ([445000a](https://github.com/keptn/keptn/commit/445000a88258801aae32ad395b073d47dff9ffc7))


### Performance

* **bridge:** Use adapted sequence endpoint for project endpoint of bridge server ([#7696](https://github.com/keptn/keptn/issues/7696)) ([5bed56d](https://github.com/keptn/keptn/commit/5bed56d4b62cd996b09f8c15ab5a81e02aa03d70))


### Docs

* Added zero downtime tests documentation ([#7895](https://github.com/keptn/keptn/issues/7895)) ([cefdab5](https://github.com/keptn/keptn/commit/cefdab5fbb76b4d24e22b2a30549867880731ab7))
* Improve developer API + integration tests docs ([#7771](https://github.com/keptn/keptn/issues/7771)) ([b6fb2d6](https://github.com/keptn/keptn/commit/b6fb2d64afad324f75a85fec0ec24f6acd9d1cec))
* Improve documentation for resource-service ([#7765](https://github.com/keptn/keptn/issues/7765)) ([0995fda](https://github.com/keptn/keptn/commit/0995fda85ac681a4d82219109ad801c9132af553))
* Update version for installation of Helm and JMeter services ([#7700](https://github.com/keptn/keptn/issues/7700)) ([788366a](https://github.com/keptn/keptn/commit/788366aa1af7ba4414d4fced30cb3bbe0f7b3080))


### Other

* Add [@heinzburgstaller](https://github.com/heinzburgstaller) as member ([#7847](https://github.com/keptn/keptn/issues/7847)) ([e3ac5fc](https://github.com/keptn/keptn/commit/e3ac5fcb3f36cedc0fa4ebbbb28e11510dc100a9))
* Add New Integration and Keptn Slack to the new issue screen ([#7669](https://github.com/keptn/keptn/issues/7669)) ([48ba7aa](https://github.com/keptn/keptn/commit/48ba7aaaedb19d9426d961b4f7f4c02067ae5ea6))
* Added cp-common to keptn repo and to pipeline ([#7814](https://github.com/keptn/keptn/issues/7814)) ([05ef470](https://github.com/keptn/keptn/commit/05ef470de8840c1de94e3c620a13db6e86029626))
* **bridge:** Only update sequence metadata when needed ([#7733](https://github.com/keptn/keptn/issues/7733)) ([e2473ec](https://github.com/keptn/keptn/commit/e2473ec7993b4e23384e972076088ee16f81d836))
* **bridge:** Remove dev-dependency jest-fetch-mock ([#7703](https://github.com/keptn/keptn/issues/7703)) ([d130add](https://github.com/keptn/keptn/commit/d130adddcc742df80ec423d30b4a33a506eca013))
* **bridge:** Remove sequence metadata polling ([#7870](https://github.com/keptn/keptn/issues/7870)) ([91360bc](https://github.com/keptn/keptn/commit/91360bca828f6b8ce7ba98fdcea161a268c402a6))
* **bridge:** Upgrade to Angular 12 ([#7724](https://github.com/keptn/keptn/issues/7724)) ([34434be](https://github.com/keptn/keptn/commit/34434be3737c61a232b137bc711c630bc09e54ee))
* Bump go-sdk version ([#7931](https://github.com/keptn/keptn/issues/7931)) ([f9cc0e7](https://github.com/keptn/keptn/commit/f9cc0e7b7613a2ecb2d95421defdb7ba2393b990))
* **cli:** Clean up auth messages ([#7911](https://github.com/keptn/keptn/issues/7911)) ([4d013cc](https://github.com/keptn/keptn/commit/4d013cc9ca43681b9128aa065e03e6048d951aeb))
* **cp-connector:** Remove unnecesarry logs ([#7966](https://github.com/keptn/keptn/issues/7966)) ([92d5991](https://github.com/keptn/keptn/commit/92d59919c8786f4e7445ed17a3712265d6ac90b2))
* Executed swag fmt to format swag annotations ([#7871](https://github.com/keptn/keptn/issues/7871)) ([8a7c809](https://github.com/keptn/keptn/commit/8a7c8093a6990addbeac5cac5ea624f7027f3bb2))
* **installer:** Adapted default values for preStop hook times and resource-service resource limits ([#7894](https://github.com/keptn/keptn/issues/7894)) ([51000d2](https://github.com/keptn/keptn/commit/51000d256ea7d2770310726b49c7d126f81e9afa))
* Reduce execution time of shipyard-controller tests ([#7929](https://github.com/keptn/keptn/issues/7929)) ([3562e44](https://github.com/keptn/keptn/commit/3562e44ca8359e1ce77137480dfbeef5b2b02db8))
* **shipyard-controller:** Improve logs with ctx of blocking sequence ([#7948](https://github.com/keptn/keptn/issues/7948)) ([6cc9544](https://github.com/keptn/keptn/commit/6cc9544f7a456b571cedb9d3061984e3a7ef89af))
* Update references to cp-common ([#7823](https://github.com/keptn/keptn/issues/7823)) ([a07259f](https://github.com/keptn/keptn/commit/a07259f33b53c38984a707bd1519f3dbbe36f8ea))
* Updated refs to go-sdk ([#7811](https://github.com/keptn/keptn/issues/7811)) ([5a03c55](https://github.com/keptn/keptn/commit/5a03c555f674138af9c39ad938817a87de505290))

