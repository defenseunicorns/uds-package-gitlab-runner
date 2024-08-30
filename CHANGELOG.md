# Changelog

## [17.2.1-uds.0](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v17.1.0-uds.1...v17.2.1-uds.0) (2024-08-30)


### Features

* add SETUID and SETGID capabilities for gitlab runner container security context ([#116](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/116)) ([6609aa0](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/6609aa0503fa6b086c09a46a79197c7167337a9a))


### Miscellaneous

* cleanup tests to match pattern in other repos ([#112](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/112)) ([e7c2d33](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/e7c2d33249bd9ba0dd188d53c22ebc4ebcbab966))
* **deps:** update gitlab runner package dependencies ([#108](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/108)) ([beaec62](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/beaec62d6144e27fd74033fd53fc5b4d5cf759cc))

## [17.1.0-uds.1](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v17.1.0-uds.0...v17.1.0-uds.1) (2024-07-31)


### Features

* enable prometheus metrics to be Made for UDS ([#111](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/111)) ([27001f1](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/27001f1bea898bc4cbca7cbd45f90c7ac3dfad26))


### Miscellaneous

* **deps:** update gitlab runner support dependencies ([#110](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/110)) ([087aefc](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/087aefcc31f0ac2804659c0d02e41b106246491e))
* **deps:** update support-deps to v3.25.15 ([#107](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/107)) ([dafe6b2](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/dafe6b2b13a7464782b5885d2099aa84b20ebf7f))

## [17.1.0-uds.0](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v17.0.0-uds.1...v17.1.0-uds.0) (2024-07-23)


### Miscellaneous

* **deps:** update gitlab runner package dependencies ([#84](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/84)) ([313b471](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/313b471aec8b1422826e4e7eb4855eff7d5b7dfd))
* **deps:** update gitlab runner support dependencies ([#105](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/105)) ([bd43d5c](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/bd43d5cb3e4482c3d806807cc61fc49f60289109))

## [17.0.0-uds.1](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v17.0.0-uds.0...v17.0.0-uds.1) (2024-07-13)


### ⚠ BREAKING CHANGES

* update to the new runner registration system ([#93](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/93))
* allow for configurability to zarf ignore the sandbox ([#90](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/90))

### Features

* add wait for GLR package CR readiness ([#88](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/88)) ([1067019](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/10670191ad7472591771b42087f4f3b737302e0c))
* allow for configurability to zarf ignore the sandbox ([#90](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/90)) ([3da0e53](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/3da0e539b0441b836c9c4e8a64019286b320d492))


### Bug Fixes

* update to the new runner registration system ([#93](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/93)) ([6a4c5e0](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/6a4c5e092db7fbf48d67d9d600b36d6951f833b0))


### Miscellaneous

* add an ADR for the GitLab runner sandbox Zarf agent ignore setting ([#100](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/100)) ([6f13ee1](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/6f13ee1973e4b64d18733a524f45ac83734dbe50))
* add pre release testing ([#95](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/95)) ([a412c82](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/a412c82312314e6412a1668815888c77ff58ca96))
* **deps-dev:** bump braces from 3.0.2 to 3.0.3 in /test ([#97](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/97)) ([5eedf1a](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/5eedf1a4a0541c66dcf0623897d7df5be4a98620))
* **deps-dev:** bump ws from 8.16.0 to 8.17.1 in /test ([#94](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/94)) ([545c583](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/545c58338f93a7418b3b6cfe50ce1b9cc7c1aa10))
* **deps:** update gitlab runner support dependencies ([#103](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/103)) ([a0439e7](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/a0439e7f37fa530bc670654ee1241875a4c4823b))
* **deps:** update gitlab runner support dependencies ([#85](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/85)) ([ace6a61](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/ace6a619ca2d773306014fdd878a6fcf9815c283))
* **deps:** update gitlab runner support dependencies ([#91](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/91)) ([ccc1f1a](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/ccc1f1a1a931989b7d1019d9ed362d987887e3fd))
* fix renovate config for gitlab runner sandbox images ([#98](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/98)) ([18028e4](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/18028e4d6e0b92ec4b239b1c2116a38252cdd3f6))
* move the variables from common to root for discoverability ([#102](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/102)) ([78e17f4](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/78e17f4424993cf630de1bcd025e92ec51728fdd))
* update license ([#92](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/92)) ([5c7b0fe](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/5c7b0feecd513cba4a8f5a6eb4cb66f76a75b32c))

## [17.0.0-uds.0](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v16.11.0-uds.0...v17.0.0-uds.0) (2024-05-29)


### ⚠ BREAKING CHANGES

* add netpols and monitoring ([#81](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/81))

### Features

* add netpols and monitoring ([#81](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/81)) ([71c40fb](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/71c40fb034c78bdfb1247f749f9b620a2b013408))


### Miscellaneous

* **deps:** update gitlab runner package dependencies ([#80](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/80)) ([8393282](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/83932820933c7c17d405984cf0f4656712e01f6f))
* **deps:** update gitlab runner support dependencies ([#78](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/78)) ([a203bac](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/a203baca75cb7ec99b9a4bd0d210044802aa3790))

## [16.11.0-uds.0](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v16.10.0-uds.0...v16.11.0-uds.0) (2024-05-07)


### Miscellaneous

* **deps:** update gitlab runner package dependencies ([#77](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/77)) ([a74125e](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/a74125ebd5469f5b0015d148e86c76dda19a0a7c))
* **deps:** update gitlab runner support dependencies ([#71](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/71)) ([19eabac](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/19eabac881b710ba0fc0d7baa03aaf8b9d71db75))
* **deps:** update gitlab runner support dependencies ([#75](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/75)) ([f8c97fb](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/f8c97fbf41a61b355f64d4583da1a809af6ceb0a))
* hotfix the update to spoof the release ([#69](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/69)) ([5056b18](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/5056b189f7f6491e15b19cce079cbce3ff5fbf17))
* improve jest test patterns ([#73](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/73)) ([6c60a90](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/6c60a90feaefc7873b2bd87ace27e1beb198845d))

## [16.10.0-uds.0](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v16.9.1-uds.2...v16.10.0-uds.0) (2024-03-29)


### Miscellaneous

* add a renovate schedule to reduce paid runner churn ([#67](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/67)) ([0e08dfe](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/0e08dfe8a58b8f712c1682a3277c24d3a9177198))
* add upgrade tests to gitlab-runner ([#60](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/60)) ([df343fe](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/df343fe6cc71a9f0ba3601e8cd34218aec5118be))
* **deps:** update gitlab runner package dependencies ([#63](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/63)) ([ad21fa7](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/ad21fa7fbed7175132499e49d28157778b93841c))
* **deps:** update gitlab runner support dependencies ([#52](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/52)) ([345a28f](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/345a28f55b880fc8cf1c09c37fd6e4725c57e394))
* **deps:** update gitlab runner support dependencies ([#62](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/62)) ([6264f7a](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/6264f7a3d31c91fccc6e54a9d25c6859374f651f))
* hotfix upgrade test action ([#61](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/61)) ([040ab3a](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/040ab3a70a0ebcbf0905d8d908ea05b0a03ed8e0))
* release v16.10.0-uds.0 ([#68](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/68)) ([8f13492](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/8f134922ea3e1eec8b4669e8e4886b8ae9c3250e))
* update CODEOWNERS to new style/group ([#58](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/58)) ([422e776](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/422e7769719ba5c31741c97891a12b472be06dca))
* update gitlab-runner to be simpler and more in line with patterns ([#65](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/65)) ([4064d7e](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/4064d7ef63d39aeaab02c395460d9cedb4ed5499))

## [16.9.1-uds.2](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v16.9.1-uds.1...v16.9.1-uds.2) (2024-03-13)


### Bug Fixes

* architecture issues in nested uds-cli publish ([#53](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/53)) ([2d44ae7](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/2d44ae71db143b63ec7293f1e844cb086168b22c))


### Miscellaneous

* change to use uds-common test action ([#55](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/55)) ([b0f4906](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/b0f49067d675eb3dae0bb722886e3dddf70df735))
* included ci docs shim ([#54](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/54)) ([c689c11](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/c689c118b4a2e2449f7b236e512de8703fed2d56))

## [16.9.1-uds.1](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v16.9.1-uds.0...v16.9.1-uds.1) (2024-03-07)


### Miscellaneous

* fix unvendored kubectl and zarf, remove --no-progress flag ([#49](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/49)) ([5c44943](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/5c449431cf685922fa6eb46e1bafb12ac433bdbd))

## [16.9.1-uds.0](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v16.8.0-uds.1...v16.9.1-uds.0) (2024-03-07)


### Miscellaneous

* **deps:** update gitlab runner package dependencies ([#34](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/34)) ([4cf733e](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/4cf733e36caff7713cec1a953c0a274f53b6fe58))
* **deps:** update gitlab runner support dependencies ([#40](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/40)) ([04c88c0](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/04c88c00a1085400a00cb315f61d884fb6ba6e36))
* **deps:** update gitlab runner support dependencies ([#45](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/45)) ([6f41a63](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/6f41a6315a116748727c34ee69399736d9964ff4))
* fix scorecard issues ([#42](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/42)) ([d9e473f](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/d9e473f688abfaa49301bbe216d0e0efdd508cfc))

## [16.8.0-uds.1](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v16.8.0-uds.0...v16.8.0-uds.1) (2024-02-24)


### Bug Fixes

* build container security context ([#22](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/22)) ([435d65e](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/435d65e76ccbe1f7312eb4f10aca995a8bf1f0e3))
* pinning commitlint to avoid breaking change ([#27](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/27)) ([ea7eabe](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/ea7eabe15abe1aed49a9e0cb4e085e10c22fcac5))
* update 'kubectl' commands to 'uds zarf tools kubectl' ([f995554](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/f9955543a6295b345a2303e92c1a96a937ed2f1e))


### Miscellaneous

* **deps:** update gitlab runner support dependencies ([#35](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/35)) ([56dcfb0](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/56dcfb007ad99a0f299084f60bff442c875a8a31))
* fix broken link in README ([#29](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/29)) ([668cf25](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/668cf25aace3f4be01de8de6d38b864a8c41d79e))
* renovate updates ([#30](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/30)) ([7d911ac](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/7d911ac7c189df4b1407fbd1708f6d1f1e2c986c))
* update contributing guidelines + renovate ([#24](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/24)) ([9025c6b](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/9025c6bf550361ec7c93b1ec623d8c14a74e2c5b))
* Update README.md ([#25](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/25)) ([9410f23](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/9410f234da49f238469b5bffbace88b46bc78a48))

## [16.8.0-uds.0](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v16.6.0-uds.0...v16.8.0-uds.0) (2024-02-05)


### Bug Fixes

* copy paste error ([b046832](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/b0468320f39da2bfc5eedf1af171930348152b3f))
* registry1 values and images and renovate ([1c8c40c](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/1c8c40c42c99865a230870d4f2f0157d19f0e315))
* update registry1 values for upstream chart differences ([e586481](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/e586481fd4b6d1e8353c63f45d647053d06e2afe))
* update renovate ([0dc6fe3](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/0dc6fe34b9c5645c7f4c149fdc8f0237026fd2bd))
* update renovate comments and images for new renovate.json ([a2a9244](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/a2a9244efe45bc86e1794ffdcc04fe77d8742ac3))


### Miscellaneous

* release 16.8.0-uds.0 ([#17](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/17)) ([409816f](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/409816f6c4cbf0088c2cd0232a0b29c5387c6edb))
* standardize repo to template and update README.md ([#14](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/14)) ([cbda1cc](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/cbda1cc6bd1b020c73aac8f7fee0830f3d3fcf74))

## [16.6.0-uds.0](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v0.59.1-uds.1...v16.6.0-uds.0) (2024-02-02)


### Miscellaneous

* registration and rbac in zarf.yaml ([#10](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/10)) ([f17a0e7](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/f17a0e79bab8eb7f62f89286f49c8e891e90fab3))
* release 16.6.0-uds.0 ([#12](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/12)) ([ca2e168](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/ca2e168421e84ca218ddaa1515d14ada883260f9))

## [0.59.1-uds.1](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v0.59.1-uds.0...v0.59.1-uds.1) (2024-02-01)


### Bug Fixes

* publish task ([#6](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/6)) ([5910cc2](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/5910cc2f7608194a18af16d739cc54345b007781))

## [0.59.1-uds.0](https://github.com/defenseunicorns/uds-package-gitlab-runner/compare/v0.58.1-uds.1...v0.59.1-uds.0) (2024-02-01)


### Features

* runner creation ([#1](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/1)) ([96085eb](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/96085eb515f1c33bea03eb2d4a54e4217f09e79b))


### Bug Fixes

* re-add x-release-please-end ([#5](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/5)) ([37cc08e](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/37cc08e4a44f485bb0014cc09a7a3a3dff7ed12d))


### Miscellaneous

* release 0.59.1-uds.0 ([#4](https://github.com/defenseunicorns/uds-package-gitlab-runner/issues/4)) ([c944b7d](https://github.com/defenseunicorns/uds-package-gitlab-runner/commit/c944b7de5083a4c4fe6604690c415d93ee77652f))
