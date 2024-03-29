# Changelog

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
